#!/bin/bash

# Increase maximum amount of file descriptors available, recommended for production
ulimit -n 8192
# Run the server
sudo ./caddy/caddy -conf "./config/$GAZELLE_ENV.caddy"
