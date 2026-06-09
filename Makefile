.PHONY: up submit verify logs down

# Start the core stack: MariaDB, MinIO, the bucket init step and the Flink cluster.
up:
	docker compose up -d

# Submit the CDC pipeline (jobs/job.sql) to Flink once the stack is ready.
submit:
	./scripts/submit_job.sh

# Read the Paimon table back to confirm rows landed.
verify:
	./scripts/verify_job.sh

# Follow the Flink JobManager logs.
logs:
	docker compose logs -f jobmanager

# Stop the stack and remove its volumes.
down:
	docker compose down -v
