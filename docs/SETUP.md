# SETUP

You'll need [Docker](https://www.docker.com/) installed.

Checkout this repo and navigate to the directory.

Create an `.env` file to hold required environment variables.

```sh
cp .env.sample.txt .env
```

Build the services via docker;

```sh
docker-compose build
```

Run the server...

```sh
docker-compose up
```

Open the site at [localhost:3000](http://localhost:3000)!

## Troubleshooting

Database filling up (> 8,000 rows with no records);

```sh
heroku pg:psql
DELETE FROM spatial_ref_sys WHERE srid <> 4326;
```
