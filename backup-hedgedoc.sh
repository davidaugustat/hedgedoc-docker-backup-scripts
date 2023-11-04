#!/bin/bash
# Backs up the Docker volumes of the Hedgedoc installation.
# Usage:
# bash backup-hedgedoc.sh
# No arguments required. Run with normal user privileges.
#
# This script requires the 'vackup' script from the following link to be in the same directory:
# https://github.com/BretFisher/docker-vackup/blob/main/vackup

# Adjust docker volume names according to your installation:
source config.sh

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
output_file="hedgedoc_backup_${timestamp}.tgz"

# Export the volumes to temporary files
bash vackup.sh export "$uploads_docker_volume_name" "$uploads_archive_file"
bash vackup.sh export "$database_docker_volume_name" "$database_archive_file"

# Combine the exported archives into a single archive
tar czf "$output_file" "$uploads_archive_file" "$database_archive_file"

# Clean up the temporary files
rm -f "$uploads_archive_file" "$database_archive_file"

echo "Backup created: $output_file"
