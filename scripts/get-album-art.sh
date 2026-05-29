#!/usr/bin/env bash
# Returns a local path to the current track's album art.
# Caches remote URLs (Spotify CDN) to /tmp to avoid re-downloading on every poll.

IGNORE="--ignore-player=firefox,librewolf"
CACHE_DIR="/tmp/eww-art-cache"
mkdir -p "$CACHE_DIR"

art_url=$(playerctl $IGNORE metadata mpris:artUrl 2>/dev/null)

if [ -z "$art_url" ]; then
    echo ""
    exit 0
fi

# Local file (kew and other local players)
if [[ "$art_url" == file://* ]]; then
    echo "${art_url#file://}"
    exit 0
fi

# Remote URL (Spotify CDN) — cache by URL hash
hash=$(echo -n "$art_url" | md5sum | cut -d' ' -f1)
cached="$CACHE_DIR/${hash}.jpg"

if [ ! -f "$cached" ]; then
    curl -sfL -o "$cached" "$art_url" || { echo ""; exit 0; }
fi

echo "$cached"
