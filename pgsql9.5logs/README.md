# PGSQL image

Configured to populate the Database with the `20-nuxeodb.sql`

    docker build -t <container-name> .

# Logs

Adding logs collector to image through the Dockerfile CMD part

    CMD ["postgres", "-c", "logging_collector=on"]
