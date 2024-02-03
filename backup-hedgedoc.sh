#!/bin/bash
# Backs up the Docker volumes of the Hedgedoc installation.
# Usage:
# bash backup-hedgedoc.sh
# No arguments required. Run with normal user privileges.
#
# This script requires the 'vackup' script from the following link to be in the same directory:
# https://github.com/BretFisher/docker-vackup/blob/main/vackup
#
# Adjust parameters in the config.sh file according to your installation.

source config.sh

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
output_file="hedgedoc_backup_${timestamp}.tgz"

# Check if the container $database_docker_container_name exists:
if ! docker ps -a --format '{{.Names}}' | grep -Eq "^${database_docker_container_name}$"; then
    echo "Error: Docker container '$database_docker_container_name' does not exist."
    echo "Please make sure that the container is running and the config.sh file is set up correctly."
    exit 1
fi

# Check if the volume $uploads_docker_volume_name exists:
if ! docker volume ls --format '{{.Name}}' | grep -Eq "^${uploads_docker_volume_name}$"; then
    echo "Error: Docker volume '$uploads_docker_volume_name' does not exist."
    exit 1
fi

# Export the uploads volume (for pictures) to an archive:
bash vackup.sh export "$uploads_docker_volume_name" "$uploads_archive_file"

# Create a database dump from the Postgres container:
docker exec "$database_docker_container_name" pg_dump -c "$hedgedoc_database_name" -U "$hedgedoc_postgres_user" > "$database_archive_file"

# Combine the exported archives into a single archive
tar czf "$output_file" "$uploads_archive_file" "$database_archive_file"

# Clean up the temporary files
rm -f "$uploads_archive_file" "$database_archive_file"

echo "Backup created: $output_file"
