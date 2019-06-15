#!/bin/bash
set -e

php -r "set_time_limit(60);for(;;){if(@fsockopen('db',3306)){break;}echo \"Waiting for MySQL\n\";sleep(1);}"
bin/console doctrine:migration:migrate -n
bin/console cache:clear --no-warmup
bin/console cache:warmup
chown -R www-data var

exec "$@"
