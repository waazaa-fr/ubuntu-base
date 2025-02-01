#!/usr/bin/env bash
set -e

# Si aucun argument n'est passé, exécuter une commande par défaut (comme crond)
if [ -z "$1" ]; then
    exec cron -f -l 2
else
    # Exécuter la commande ou le service principal du conteneur
    exec "$@"
fi