#!/usr/bin/env bash
set -e
echo "Running RKHunter..."
rkhunter --update
rkhunter --check --skip-keypress
