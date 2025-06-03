# Hospitality Hub

This repository contains a backend written in NestJS and a placeholder frontend.

## Docker Setup

Dockerfiles are provided for both the backend and the (placeholder) frontend. A `docker-compose.yml` is available to run the entire stack, including a PostgreSQL database.

### Start the stack

```bash
docker compose up --build
```

The services started are:

- **db** – PostgreSQL database available on port 5432.
- **backend** – NestJS application available on port 3000.
- **frontend** – Next.js application served by Node on port 8080.

The backend receives a `DATABASE_URL` environment variable pointing at the Postgres service.
