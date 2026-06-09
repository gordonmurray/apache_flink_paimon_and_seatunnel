.PHONY: jars up submit verify cdc-change seatunnel-read seatunnel-iceberg verify-iceberg logs down

# Download the Flink, Paimon and CDC connector jars (verified against pinned checksums).
jars:
	./scripts/download_jars.sh

# Start the core stack: MariaDB, SeaweedFS, the bucket init step and the Flink cluster.
up: jars
	docker compose up -d

# Submit the CDC pipeline (jobs/job.sql) to Flink once the stack is ready.
submit:
	./scripts/submit_job.sh

# Read the Paimon table back to confirm rows landed.
verify:
	./scripts/verify_job.sh

# Change a row in MariaDB to watch CDC flow through to Paimon.
cdc-change:
	./scripts/cdc_change.sh

# Run SeaTunnel to read the Paimon table from SeaweedFS and print the rows.
seatunnel-read:
	docker compose run --rm seatunnel /opt/seatunnel/bin/seatunnel.sh --config /config/paimon-to-console.conf -m cluster

# Run SeaTunnel to read Paimon, add a price_band column and write an Iceberg table on SeaweedFS.
seatunnel-iceberg:
	docker compose run --rm seatunnel /opt/seatunnel/bin/seatunnel.sh --config /config/paimon-to-iceberg.conf -m cluster

# Read the Iceberg table back to confirm the transformed rows landed.
verify-iceberg:
	docker compose run --rm seatunnel /opt/seatunnel/bin/seatunnel.sh --config /config/iceberg-to-console.conf -m cluster

# Follow the Flink JobManager logs.
logs:
	docker compose logs -f jobmanager

# Stop the stack and remove its volumes.
down:
	docker compose down -v
