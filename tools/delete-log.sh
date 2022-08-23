#!/usr/bin/env bash

SERVER_LOG_DIR="/data/log/audit-server/"
ENGINE_LOG_DIR="/data/log/engines/dpi/"

find $SERVER_LOG_DIR -mtime +7 -name "[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_*.log" -exec rm -Rf {} \;
find $ENGINE_LOG_DIR -mtime +7 -name "[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_*.log" -exec rm -Rf {} \;
