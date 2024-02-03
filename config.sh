#!/bin/bash
# Shared variables for backup and restore scripts

# Parameters for uploads volume (adjust according to your installation):
uploads_docker_volume_name=hedgedoc_uploads

# Parameters for Postgres database container (adjust according to your installation):
database_docker_container_name=hedgedoc-database-1
hedgedoc_database_name="hedgedoc"
hedgedoc_postgres_user="hedgedoc"

# File names in the backup archive:
uploads_archive_file="hedgedoc_uploads_backup.tgz"
database_archive_file="hedgedoc_database_backup.sql"
