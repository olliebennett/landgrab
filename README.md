# LandGrab

Source at [GitHub](https://github.com/olliebennett/landgrab)

Demo running at [landgrabdemo.herokuapp.com](https://landgrabdemo.herokuapp.com/)

## Setup

You'll need Rails and PostgreSQL set up.

Checkout this repo and navigate to the directory.

Install the required PostGIS (spatial PostgreSQL extension);

```
brew install postgis
```

Create the required databases and load schema;

```
bin/rails db:setup
```

Create an `.env` file to hold required environment variables.

```
touch .env
```

Run the server...

```
bin/rails s
```

Open the site at [localhost:3000](http://localhost:3000)!

## Troubleshooting

Database filling up (> 8,000 rows with no records);

```sh
heroku pg:psql
DELETE FROM spatial_ref_sys WHERE srid <> 4326;
```
