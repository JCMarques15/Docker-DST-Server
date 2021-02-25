#!/bin/bash

# Fuction to handle exit of container
cleanup() {
    ./dstserver stop > /dev/null
    exit 0
}

configure_server () {

    # Configuring Server Name
    if [ -v DST_NAME ]
    then
        echo "Name: $DST_NAME"
        sed -i "s/cluster_name = .*/cluster_name = $DST_NAME/" .klei/DoNotStarveTogether/Cluster_1/cluster.ini
    fi

    # Configuring Description
    if [ -v DST_DESCRIPTION ]
    then
        echo "Description: $DST_DESCRIPTION"
        sed -i "s/cluster_description = .*/cluster_description = $DST_DESCRIPTION/" .klei/DoNotStarveTogether/Cluster_1/cluster.ini
    fi

    # Configuring Server mode
    if [ -v DST_PASSWORD ]
    then
        echo "Password: $DST_PASSWORD"
        sed -i "s/cluster_password = .*/cluster_password = $DST_PASSWORD/" .klei/DoNotStarveTogether/Cluster_1/cluster.ini
    fi

    # Configuring Game Mode
    if [ -v DST_MODE ]
    then
        echo "Game Mode: $DST_MODE"
        sed -i "s/game_mode = .*/game_mode = $DST_MODE/" .klei/DoNotStarveTogether/Cluster_1/cluster.ini
    fi

    # Configuring Server Intention
    if [ -v DST_INTENTION ]
    then
        echo "Intention: $DST_INTENTION"
        sed -i "s/cluster_intention = .*/cluster_intention = $DST_INTENTION/" .klei/DoNotStarveTogether/Cluster_1/cluster.ini
    fi

    # Configuring Max Players
    if [ -v DST_MAX_PLAYERS ]
    then
        echo "Max Players: $DST_MAX_PLAYERS"
        sed -i "s/max_players = .*/max_players = $DST_MAX_PLAYERS/" .klei/DoNotStarveTogether/Cluster_1/cluster.ini
    fi

    # Configuring PVP
    if [ -v DST_PVP ]
    then
        echo "PVP: $DST_PVP"
        sed -i "s/pvp = .*/pvp = $DST_PVP/" .klei/DoNotStarveTogether/Cluster_1/cluster.ini
    fi

    # Configure LinuxGSM server
    if [ "$DST_SHARD" = "Master" ]
    then
        echo -e "Master shard detected, configuring server..."
        sed -i "s/sharding=\"false\"/sharding=\"true\"/" lgsm/config-lgsm/dstserver/dstserver.cfg
        sed -i "s/master=\"false\"/master=\"true\"/" lgsm/config-lgsm/dstserver/dstserver.cfg
        sed -i "s/shard=\"Caves\"/shard=\"Master\"/" lgsm/config-lgsm/dstserver/dstserver.cfg
        sed -i "s/cave=\"true\"/cave=\"false\"/" lgsm/config-lgsm/dstserver/dstserver.cfg
        sed -i "s/shard_enabled = false/shard_enabled = true/" .klei/DoNotStarveTogether/Cluster_1/cluster.ini
    elif [ "$DST_SHARD" = "Caves" ]
    then
        echo -e "Caves shard detected, configuring server..."
        sed -i "s/sharding=\"false\"/sharding=\"true\"/" lgsm/config-lgsm/dstserver/dstserver.cfg
        sed -i "s/master=\"true\"/master=\"false\"/" lgsm/config-lgsm/dstserver/dstserver.cfg
        sed -i "s/shard=\"Master\"/shard=\"Caves\"/" lgsm/config-lgsm/dstserver/dstserver.cfg
        sed -i "s/cave=\"false\"/cave=\"true\"/" lgsm/config-lgsm/dstserver/dstserver.cfg
        sed -i "s/shard_enabled = false/shard_enabled = true/" .klei/DoNotStarveTogether/Cluster_1/cluster.ini
    else
        echo -e "No environment variable set, not enabling sharding!"
    fi

    # Check if token is present
    if [ ! -f ".klei/DoNotStarveTogether/Cluster_1/cluster_token.txt" ] && [ -v DST_TOKEN ]
    then
        echo "Token not found, adding it from env variable..."
        echo "$DST_TOKEN" > .klei/DoNotStarveTogether/Cluster_1/cluster_token.txt
    elif [ ! -f ".klei/DoNotStarveTogether/Cluster_1/cluster_token.txt" ] && [ ! -v DST_TOKEN ]
    then
        echo "Token not found, adding it interactively..."
        ./dstserver cluster-token
        sleep 1
    fi
}

# Trap the SIGTERM signal
trap cleanup SIGTERM

# Call function to configure server:
configure_server

# Start Server
echo -e "Server configured, starting server."
./dstserver start

# Follow console log
tail -F log/console/dstserver-console.log &

# Wait Indefinitly
wait $!