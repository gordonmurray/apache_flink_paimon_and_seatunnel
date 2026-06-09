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

### Smoke test the SeaTunnel image

To confirm the image starts and loads its config, run the bundled sample job, which generates a few fake rows and prints them to the console:

```
docker compose run --rm seatunnel
```

You should see rows logged through the console sink and the job finish without errors.
