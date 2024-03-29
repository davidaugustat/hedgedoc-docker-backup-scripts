#!/bin/bash
# This script restores the Docker volumes of the Hedgedoc installation from a backup.
# The backup file must be a tar archive created by the backup-hedgedoc.sh script.
# It uses the shared variables defined in config.sh.
#
# This script requires the 'vackup' script from the following link to be in the same directory:
# https://github.com/BretFisher/docker-vackup/blob/main/vackup
#
# Usage: Run this script in the terminal with the command './restore-hedgedoc.sh <backup_file.tgz>'.

source config.sh

# Check if an argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <backup_file.tgz>"
    exit 1
fi
backup_file="$1"

# Check if the backup file exists
if [ ! -f "$backup_file" ]; then
    echo "Error: Backup file '$backup_file' does not exist."
    exit 1
fi

# Check if the container $database_docker_container_name exists:
if ! docker ps -a --format '{{.Names}}' | grep -Eq "^${database_docker_container_name}$"; then
    echo "Error: Docker container '$database_docker_container_name' does not exist."
    exit 1
fi

# Check if the volume $uploads_docker_volume_name exists:
if ! docker volume ls --format '{{.Name}}' | grep -Eq "^${uploads_docker_volume_name}$"; then
    echo "Error: Docker volume '$uploads_docker_volume_name' does not exist."
    exit 1
fi

# Extract the backup
tar -xzf "$backup_file"

# Import the database backup
cat "$database_archive_file" | docker exec -i "$database_docker_container_name" psql -U "$hedgedoc_postgres_user"

# Import the uploads backup
bash vackup.sh import "$uploads_archive_file" "$uploads_docker_volume_name"

# Remove the extracted backup files
rm -f "$database_archive_file" "$uploads_archive_file"

echo "Backup import completed."
