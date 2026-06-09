#!/usr/bin/env bash
#
# Waits for the stack to be ready and submits jobs/job.sql to the Flink cluster.
# The job is the CDC pipeline that streams the MariaDB products table into the
# Paimon myproducts table on SeaweedFS.

set -euo pipefail

FLINK_URL="${FLINK_URL:-http://localhost:8081}"

echo "Waiting for the Flink JobManager at ${FLINK_URL} ..."
until curl -sf "${FLINK_URL}/overview" >/dev/null 2>&1; do
  sleep 2
done
echo "Flink is up."

echo "Waiting for SeaweedFS ..."
until curl -s "http://localhost:9000" >/dev/null 2>&1; do
  sleep 2
done
echo "SeaweedFS is up."

echo "Waiting for MariaDB ..."
until docker compose exec -T mariadb mysqladmin ping -uroot -prootpassword --silent >/dev/null 2>&1; do
  sleep 2
done
echo "MariaDB is up."

echo "Submitting jobs/job.sql ..."
docker compose exec -T jobmanager /opt/flink/bin/sql-client.sh -f /opt/flink/jobs/job.sql

echo
echo "Done. The CDC job is now running on the cluster."
echo "Open ${FLINK_URL} and look under Running Jobs to see it."
echo "Run 'make verify' (or scripts/verify_job.sh) to read the rows back from Paimon."
