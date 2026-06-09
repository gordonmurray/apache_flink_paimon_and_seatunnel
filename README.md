# Apache Flink, Paimon and SeaTunnel

![Static Badge](https://img.shields.io/badge/Just_testing-Not_production_ready-red)

Seeing if Seatunnel can read data stored in s3 created using Flink and Paimon

### Build a SeaTunnel image

The stack uses a local SeaTunnel image. Build it with:

```
cd seatunnel

docker build -t seatunnel:2.3.11 -f Dockerfile .
```

Compose can also build it for you with `docker compose build seatunnel`.

Once built, run `docker compose up -d`

### Submit the Flink CDC job

`docker compose up -d` starts MariaDB, MinIO and the Flink cluster, but it does not submit any work. Submit the CDC pipeline in `jobs/job.sql` with:

```
make submit
```

This waits for Flink, MinIO and MariaDB to be ready, then runs the Flink SQL client against `jobs/job.sql`. The job streams the MariaDB `products` table into the Paimon `myproducts` table on MinIO.

Open the Flink UI at http://localhost:8081 and look under **Running Jobs**; you should see `insert-into_s3_catalog.paimon_database.myproducts` in the `RUNNING` state.

### Verify the data landed in Paimon

Give the job a few seconds to take its first checkpoint (Paimon commits on checkpoint), then read the table back:

```
make verify
```

This runs a one-off batch query against the Paimon table and prints a row count and a sample with ids, names and prices, for example:

```
+-----------+
| row_count |
+-----------+
|        30 |
+-----------+

+----+------------------------+--------+
| id |                   name |  price |
+----+------------------------+--------+
|  1 |  Organic Almond Butter |  10.99 |
|  2 |      Whole Grain Bread |   3.49 |
|  3 | Cold Pressed Olive Oil |  15.99 |
+----+------------------------+--------+
```

### Watch change data capture

The job keeps running, so changes made in MariaDB after the initial snapshot flow through to Paimon as well. Apply a sample change with:

```
make cdc-change
```

This updates one product's price and deletes another in MariaDB. Wait about ten seconds for the next checkpoint, then run `make verify` again: the row count drops to 29 and `Organic Almond Butter` now shows a price of `12.49`.

To tear everything down and remove the volumes, run `make down`.

### Smoke test the SeaTunnel image

To confirm the image starts and loads its config, run the bundled sample job, which generates a few fake rows and prints them to the console:

```
docker compose run --rm seatunnel
```

You should see rows logged through the console sink and the job finish without errors.
