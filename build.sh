#!/usr/bin/env bash
set -o errexit

python -m pip install -r requirements.txt
python busbuddy/manage.py collectstatic --noinput
python busbuddy/manage.py migrate
