.PHONY: up submit verify cdc-change seatunnel-read logs down

# Start the core stack: MariaDB, MinIO, the bucket init step and the Flink cluster.
up:
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

# Run SeaTunnel to read the Paimon table from MinIO and print the rows.
seatunnel-read:
	docker compose run --rm seatunnel /opt/seatunnel/bin/seatunnel.sh --config /config/paimon-to-console.conf -m local

# Follow the Flink JobManager logs.
logs:
	docker compose logs -f jobmanager

# Stop the stack and remove its volumes.
down:
	docker compose down -v
