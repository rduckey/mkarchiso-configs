#!/usr/bin/env bash
set -e
echo "Running ClamAV Scan..."
read -p "Enter path to scan: " scanpath
clamscan -r "$scanpath"
