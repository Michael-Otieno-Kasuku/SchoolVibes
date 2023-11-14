/*---------------PostgreSQL 13.10------------*/
/*access the postgresSQL terminal*/
sudo -i -u postgres
psql
/* Create the database */
CREATE DATABASE secondarydb;

/* Grant all the permissions to user kasuku */
GRANT ALL PRIVILEGES ON DATABASE secondarydb TO kasuku;

/* Connect to the database as kasuku */
psql -h localhost -U kasuku -d secondarydb -W

