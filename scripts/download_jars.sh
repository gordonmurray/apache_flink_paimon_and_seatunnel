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

download flink-sql-connector-mysql-cdc-3.6.0-1.20.jar \
  "$MAVEN/org/apache/flink/flink-sql-connector-mysql-cdc/3.6.0-1.20/flink-sql-connector-mysql-cdc-3.6.0-1.20.jar" \
  a220d45d6cd25bf79f00d8f461a21df7aac2a4e00e4ec28b3029d839c053a316db4af9c664ff23a23f3f9707b3a2e750af337687875918026a2724176998766d

# The MySQL CDC connector no longer bundles the JDBC driver; it is needed for the snapshot phase.
download mysql-connector-j-8.4.0.jar \
  "$MAVEN/com/mysql/mysql-connector-j/8.4.0/mysql-connector-j-8.4.0.jar" \
  02f4b5a07b9d34106ae85ee6f41b23c4182dab4925a5200e70c75a71d6e9b97369de2904c17a7b77ed3c14db755237848c65f7af0d5c0bc7a2b3e5802e4127f1

download flink-shaded-hadoop-2-uber-2.8.3-10.0.jar \
  "$MAVEN/org/apache/flink/flink-shaded-hadoop-2-uber/2.8.3-10.0/flink-shaded-hadoop-2-uber-2.8.3-10.0.jar" \
  c04d217fb53123054c58c5c492cc8d87e75aa72b798e3b4858757cb4d389ccd9866c224662a012e1e9b012c05e481372e2bbc97cd45746f924814733d864591f

download flink-s3-fs-hadoop-1.20.4.jar \
  "$MAVEN/org/apache/flink/flink-s3-fs-hadoop/1.20.4/flink-s3-fs-hadoop-1.20.4.jar" \
  f59a0dc3375cc0be5b85941d13bac27edcd140c68f99f5691420d3cce0742a59aec664926a9f0d373fdc606aa45676776545a1cd02944dac8543b7d11ca28de0

download paimon-flink-1.20-1.2.0.jar \
  "$MAVEN/org/apache/paimon/paimon-flink-1.20/1.2.0/paimon-flink-1.20-1.2.0.jar" \
  469ca157e33d40405fffa29f3ff841b634ddc0a8a48a0652b338f46515a7e409c8cc73709494a7e3daceba54997a7ec4d8901cf76b7f76dc95253fbbf2e30345

download paimon-s3-1.2.0.jar \
  "$MAVEN/org/apache/paimon/paimon-s3/1.2.0/paimon-s3-1.2.0.jar" \
  37349d311411f46a71be8d337db08e549613707f8350dd396b0809fddbbe6e1648a5bf0b8560ebf364287de9ca3eeb73eb05ee5d82583a7982c2708aaa643e8a

echo "All connector jars present in $JARS_DIR"
