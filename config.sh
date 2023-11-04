#!/bin/bash
# Shared variables for backup and restore scripts

# Adjust docker volume names according to your installation:
uploads_docker_volume_name=hedgedoc1_uploads
database_docker_volume_name=hedgedoc1_database

# File names in the backup archive:
uploads_archive_file="hedgedoc_uploads_backup.tgz"
database_archive_file="hedgedoc_database_backup.tgz"
