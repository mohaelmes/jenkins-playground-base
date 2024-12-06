#!/bin/bash

# Función para mostrar el uso del script
show_usage() {
    echo "Uso: ./clean.sh [opciones]"
    echo "Opciones:"
    echo "  --all         Limpia todo, incluyendo claves SSH"
    echo "  --docker      Limpia solo contenedores, volúmenes e imágenes"
    echo "  --keys        Limpia solo las claves SSH"
    echo "  -h, --help    Muestra esta ayuda"
}

# Función para limpiar Docker
clean_docker() {
    echo "Stopping all containers..."
    docker compose down

    echo "Removing volumes..."
    docker compose down -v

    echo "Removing images..."
    docker rmi jenkins-cluster-jenkins-master 2>/dev/null || true
    docker rmi jenkins-cluster-jenkins-agent1 2>/dev/null || true
    docker rmi jenkins-cluster-jenkins-agent2 2>/dev/null || true
    docker rmi jenkins-cluster-nginx-web 2>/dev/null || true
}

# Función para limpiar claves SSH
clean_keys() {
    echo "Cleaning SSH directories..."
    rm -rf jenkins-master/ssh/*
    rm -rf jenkins-agent/ssh/*
    rm -rf nginx/ssh/*
    echo "SSH keys removed"
}

# Si no hay argumentos, mostrar ayuda
if [ $# -eq 0 ]; then
    show_usage
    exit 1
fi

# Procesar argumentos
for arg in "$@"
do
    case $arg in
        --all)
        clean_docker
        clean_keys
        echo "Full cleanup completed successfully!"
        ;;
        --docker)
        clean_docker
        echo "Docker cleanup completed successfully!"
        ;;
        --keys)
        clean_keys
        echo "SSH keys cleanup completed successfully!"
        ;;
        -h|--help)
        show_usage
        exit 0
        ;;
        *)
        echo "Opción desconocida: $arg"
        show_usage
        exit 1
        ;;
    esac
done