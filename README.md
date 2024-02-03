# Hedgedoc Docker Backup and Restore Scripts
This repository contains scripts to backup and restore a Hedgedoc installation running in Docker containers. The scripts backup and restore the Docker volumes of the installation.
[Hedgedoc](https://hedgedoc.org/) is a web-based open-source collaborative markdown editor.

A typical Hedgedoc installation [as recommended by the Hedgedoc docs](https://docs.hedgedoc.org/setup/docker/) consists of two Docker containers: one for the Hedgedoc app and one for the PostgreSQL database. The Hedgedoc app container stores the uploaded pictures in a Docker volume. The database container stores the database in a Docker volume.

It is important to backup the Docker volumes of the installation regularly. The scripts in this repository help with this task.

## How to use
### Setup
In the `config.sh` file adjust the following parameters to match your installation. The default names are:

```bash
uploads_docker_volume_name=hedgedoc_uploads

database_docker_container_name=hedgedoc-database-1
hedgedoc_database_name="hedgedoc"
hedgedoc_postgres_user="hedgedoc"
```

### Backup
1. Make sure that the Hedgedoc instance is running (at least the PostgreSQL container). This is required, because the PostgreSQL server is used to create a database dump.
2. Run
    ```bash
    bash backup-hedgedoc.sh
    ```
    This script produces a `hedgedoc_backup_YYYY-mm-dd_HH-MM-SS.tgz` file containing the two Docker volumes of the installation:

    ```
    hedgedoc_backup_YYYY-mm-dd_HH-MM-SS.tgz
    ├── hedgedoc_uploads_backup.tgz
    └── hedgedoc_database_backup.sql
    ```
3. Save this file to a secure location.


### Restore
The restore script assumes that you already have a Hedgedoc installation running in Docker containers. If you want to restore the data to a new installation, you have to create the Docker volumes first, e.g., with the `docker-compose.yml` file from the [Hedgedoc docs](https://docs.hedgedoc.org/setup/docker/).

1. Make sure that the Hedgedoc instance is running (at least the PostgreSQL container).
2. Run
    ```
    bash hedgedoc-restore.sh hedgedoc_backup_YYYY-mm-dd_HH-MM-SS.tgz
    ```
    This script restores the two Docker volumes of the installation from the `hedgedoc_backup_YYYY-mm-dd_HH-MM-SS.tgz` file.
4. The restored data should be available now.
