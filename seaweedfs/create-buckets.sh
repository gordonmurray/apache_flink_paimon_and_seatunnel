#!/bin/sh
#
# Creates the demo buckets in SeaweedFS and waits until both are visible through
# the S3 gateway. weed shell's exit code is not reliable on its own, so this
# creates and then verifies, retrying until both buckets exist.

set -eu

MASTER="seaweedfs:9333"

create() {
  echo "s3.bucket.create -name $1" | weed shell -master="$MASTER" >/dev/null 2>&1 || true
}

i=0
while [ "$i" -lt 30 ]; do
  create "$PAIMON_BUCKET"
  create "$ICEBERG_BUCKET"
  list=$(echo "s3.bucket.list" | weed shell -master="$MASTER" 2>/dev/null || true)
  if echo "$list" | grep -q "$PAIMON_BUCKET" && echo "$list" | grep -q "$ICEBERG_BUCKET"; then
    echo "buckets $PAIMON_BUCKET and $ICEBERG_BUCKET ready"
    exit 0
  fi
  echo "waiting for seaweedfs buckets ..."
  i=$((i + 1))
  sleep 2
done

echo "ERROR: buckets did not become ready" >&2
exit 1
