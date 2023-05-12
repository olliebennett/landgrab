# SETUP

You'll need [Docker](https://www.docker.com/) installed.

Checkout this repo and navigate to the directory.

Create an `.env` file to hold required environment variables.

```sh
cp .env.sample .env
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

Register in the UI, then set yourself (the first user) as admin;

```sh
docker-compose exec app bin/rails runner 'User.first.update!(admin: true)'
```

Access the Rails console (for any other changes);

```sh
docker-compose exec app bin/rails c
```

## Troubleshooting

### Database filling up (> 8,000 rows with no records);

```sh
heroku pg:psql
DELETE FROM spatial_ref_sys WHERE srid <> 4326;
```

### Error when starting the container: "A server is already running."

```sh
docker compose run app rm /usr/app/landgrab/tmp/pids/server.pid
```
