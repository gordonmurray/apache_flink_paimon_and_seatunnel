#!/usr/bin/env bash
#
# Reads the Paimon myproducts table back from SeaweedFS with a one-off batch query
# to confirm the CDC job landed rows.

set -euo pipefail

echo "Reading the Paimon myproducts table ..."
docker compose exec -T jobmanager /opt/flink/bin/sql-client.sh -f /opt/flink/jobs/verify.sql
