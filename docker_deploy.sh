#!/bin/bash
# Specify the container name or ID
CONTAINER_DB="docker-db-1"
CONTAINER_SERVER="docker-server-1"

# Check if the container is running
if docker ps --filter "name=$CONTAINER_SERVER" --filter "status=running" | grep -q "$CONTAINER_SERVER"; then
    echo "Container '$CONTAINER_SERVER' is up and running."
    echo "Taking down..."
    # cd "$WORKING_DIR"  exit
    docker compose down --remove-orphans
    echo "Removing docker image..."
    docker rmi docker-server:latest
    sleep 10s 
    docker compose up -d
else
    echo "Container '$CONTAINER_SERVER' is not running."
    # cd "$WORKING_DIR"  exit
    docker compose up -d
fi