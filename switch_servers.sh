#!/bin/bash

CONFIG_DIR="/etc/nginx/sites-enabled"
CURRENT_CONFIG="$CONFIG_DIR/reverse_proxy.conf"
NEW_CONFIG="$(pwd)/reverse_proxy_xeon.conf"

if [ -f "$CURRENT_CONFIG" ]; then
    echo "reverse_proxy.conf found. Replacing with reverse_proxy_xeon.conf..."
    sudo rm "$CURRENT_CONFIG"
    sudo cp "$NEW_CONFIG" "$CURRENT_CONFIG"
else
    echo "reverse_proxy.conf not found. Restoring original configuration..."
    sudo cp "$CURRENT_CONFIG" "$NEW_CONFIG"
fi

sudo systemctl restart nginx

echo "Nginx configuration updated."
