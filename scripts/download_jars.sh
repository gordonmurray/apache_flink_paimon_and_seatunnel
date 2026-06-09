#!/usr/bin/env bash
#
# Downloads the Flink, Paimon and CDC connector jars that the stack mounts into
# the Flink containers, verifying each against a pinned SHA512 checksum. These
# jars are not committed to the repository; run this once before 'make up'.
# 'make up' also runs it for you.

set -euo pipefail

JARS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/jars"
MAVEN="https://repo1.maven.org/maven2"

mkdir -p "$JARS_DIR"

# Download one jar and verify its checksum. Skips the download when a valid copy
# is already present, so re-running is cheap.
download() {
  name="$1"
  url="$2"
  sha="$3"
  path="$JARS_DIR/$name"

  if [ -f "$path" ] && printf '%s  %s\n' "$sha" "$path" | sha512sum -c - >/dev/null 2>&1; then
    echo "ok       $name"
    return
  fi

  echo "fetching $name"
  curl -fSL -o "$path" "$url"

  if ! printf '%s  %s\n' "$sha" "$path" | sha512sum -c - >/dev/null 2>&1; then
    echo "ERROR: checksum mismatch for $name" >&2
    rm -f "$path"
    exit 1
  fi
}

download flink-sql-connector-mysql-cdc-2.4.1.jar \
  "$MAVEN/com/ververica/flink-sql-connector-mysql-cdc/2.4.1/flink-sql-connector-mysql-cdc-2.4.1.jar" \
  89e6b96c1644fb1166e383485c3e4688264c59c0e6497cf0a5b9cca5b1c67117e2e1c947c0cac61898804e6543a28d330f7a499bcdd43ded04447490adabde87

download flink-connector-jdbc-3.1.0-1.17.jar \
  "$MAVEN/org/apache/flink/flink-connector-jdbc/3.1.0-1.17/flink-connector-jdbc-3.1.0-1.17.jar" \
  923b7bf753b88e4b3772bc5e3882e4022e31dcb0ce8a4c9e6fc8996a670851369651b378e6ff08c8afc7ca84e22c171c0071d7e1a3d8fbb51d2ccc6cc050eb47

download flink-shaded-hadoop-2-uber-2.8.3-10.0.jar \
  "$MAVEN/org/apache/flink/flink-shaded-hadoop-2-uber/2.8.3-10.0/flink-shaded-hadoop-2-uber-2.8.3-10.0.jar" \
  c04d217fb53123054c58c5c492cc8d87e75aa72b798e3b4858757cb4d389ccd9866c224662a012e1e9b012c05e481372e2bbc97cd45746f924814733d864591f

download flink-s3-fs-hadoop-1.17.1.jar \
  "$MAVEN/org/apache/flink/flink-s3-fs-hadoop/1.17.1/flink-s3-fs-hadoop-1.17.1.jar" \
  59f3a41d2c750c7ffe46ea0ebc43e46862b13ce376c70363ae2e324099556fcc56f14f6e653398abf38ce0647336a1e5dc8c9bfd0b82a8f8cc2fcaf96252efbd

download paimon-flink-1.17-0.6.0-incubating.jar \
  "$MAVEN/org/apache/paimon/paimon-flink-1.17/0.6.0-incubating/paimon-flink-1.17-0.6.0-incubating.jar" \
  52dced1ffb1b230aaa62785da7c88939f7062e92808b3de7173de885c178013b047d75092eea7f6fc40c91980d746cb1dba2e0d6918dde42ae8c2531840b266c

download paimon-s3-0.6.0-incubating.jar \
  "$MAVEN/org/apache/paimon/paimon-s3/0.6.0-incubating/paimon-s3-0.6.0-incubating.jar" \
  1fc6484491787b1c4c6e36def3176dd710b36391e6d20166cec0a2c23f439c0136fa5a2f96c66eb8ca74383dfb245df3e0d04b2250b15b158689a860f107b608

echo "All connector jars present in $JARS_DIR"
