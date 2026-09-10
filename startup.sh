#!/bin/bash

# 1. Start Velocity Proxy (Allocating 512MB RAM)
echo "Starting Velocity proxy..."
cd velocity
# We use the $PORT environment variable provided by Render so it detects an active web port
java -Xms256M -Xmx512M -jar velocity-3.5.0-all.jar --port ${PORT:-25565} &
sleep 5  # Give Velocity a few seconds to initialize
cd ..

# 2. Start Limbo (Allocating 256MB RAM)
echo "Starting Limbo..."
cd limbo
java -Xms128M -Xmx256M -jar server.jar &
sleep 3
cd ..

# 3. Start Paper server (Allocating 2GB RAM to prevent the OutOfMemory crash)
echo "Starting Paper server..."
cd server
# Added -Xmx2G to give the Paperclip bootstrapper enough room to download and extract files
java -Xms1G -Xmx2G -jar server.jar --nogui

# --- Clean up background tasks if Paper stops ---
echo "------------------------------------------------------------------------------"
echo "[JmoCorp]: You have stopped the server!"
echo "[JmoCorp]: (origin: /stop or ctrl + c, or server crashed either on startup or from in-game actions.)"
echo "[JmoCorp]: (message origin: startup.sh)"
echo "[JmoCorp]: Paper Server was stopped after starting so this message appeared."
echo "[JmoCorp]: You can edit this message inside the file startup.sh"
echo "[JmoCorp]: bye!"
echo "------------------------------------------------------------------------------"

echo "Shutting down background proxy and limbo instances..."
kill $(jobs -p) 2>/dev/null
sleep 2
echo "Everything Successfully Stopped."
