-- Reads the Paimon myproducts table back from MinIO to confirm the CDC job
-- landed rows. Run this after submitting job.sql and giving it a few seconds
-- to take its first checkpoint.
SET 'execution.runtime-mode' = 'batch';
SET 'sql-client.execution.result-mode' = 'tableau';

USE CATALOG default_catalog;

DROP CATALOG IF EXISTS s3_catalog;

CREATE CATALOG s3_catalog WITH (
    'type' = 'paimon',
    'warehouse' = 's3://paimon/warehouse',
    's3.endpoint' = 'http://minio:9000',
    's3.access-key' = 'minioadmin',
    's3.secret-key' = 'minioadmin',
    's3.path.style.access' = 'true'
);

USE CATALOG s3_catalog;

USE paimon_database;

SELECT COUNT(*) AS row_count FROM myproducts;

SELECT * FROM myproducts ORDER BY id LIMIT 10;
