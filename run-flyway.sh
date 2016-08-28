#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

host="$1" ## postgres server host
port="$2" ## post server is listening 
username="$3" ## the username in db
password="$4" ## the password in db
database_name="$5" ## the database name
shift

until PGPASSWORD=$password psql -h "$host" -p "$port" -U "$username" -c '\l'; do
  >&2 echo "Postgres is unavailable - sleeping for one second"
  sleep 1
done

>&2 echo "Postgres is up - so kicking Flyway off now"

# clean the database
>&2 echo "Flyway is cleaning the database first"
flyway -url=jdbc:postgresql://"$host":"$port"/"$database_name" -schemas=public,dbo -user="$username" -password="$password" clean

# migrate the database
>&2 echo "Flyway is running pending migrations -if any- on the database"
flyway -url=jdbc:postgresql://"$host":"$port"/"$database_name" -user="$username" -password="$password" migrate

