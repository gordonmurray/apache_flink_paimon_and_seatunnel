# Apache Flink, Paimon and SeaTunnel

![Static Badge](https://img.shields.io/badge/Just_testing-Not_production_ready-red)

Seeing if Seatunnel can read data stored in s3 created using Flink and Paimon

### Build a SeaTunnel image

At the time of writing, SeaTunnel doesn't have an up to date image on Dockerhub, so use the following to create a local image:

```
cd seatunnel

docker build -t seatunnel:2.3.0-flink-1.17 -f Dockerfile .
```

Once built, run `docker compose up -d`
