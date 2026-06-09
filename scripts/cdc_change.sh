#!/usr/bin/env bash
#
# Applies a change to the MariaDB products table so you can watch change data
# capture flow through to Paimon, not just the initial snapshot. After running
# this, give the job about ten seconds to checkpoint and run 'make verify'
# again: the row count drops by one and the updated price appears.

set -euo pipefail

echo "Updating a price and deleting a row in MariaDB ..."
docker compose exec -T mariadb mysql -uroot -prootpassword mydatabase <<'SQL'
UPDATE products SET price = 12.49 WHERE name = 'Organic Almond Butter';
DELETE FROM products WHERE name = 'Soy Milk';
SQL

echo "Done. Wait about ten seconds for the next checkpoint, then run 'make verify'."
