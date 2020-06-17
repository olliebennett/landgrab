# LandGrab

Source at [GitHub](https://github.com/olliebennett/landgrab)

Demo running at [landgrabdemo.herokuapp.com](https://landgrabdemo.herokuapp.com/)

## Setup

You'll need Rails and PostgreSQL set up.

Checkout this repo and navigate to the directory.

Create the required dev database and load schema;

```
createdb landgrab_development
createdb landgrab_test
bin/rails db:schema:load
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
