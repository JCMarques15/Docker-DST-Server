# Dont-Starve-Together-Server
This is a simple Dont Starve Together server I created to learn and consolidate some docker concepts related to the building of images and running multi-container solutions. 

The entrypoint.sh script takes care of reading environment variables for easier configuration of the server at startup without the need to fiddle with files directly. To safeguard against restarts, a named volume is created at startup that mounts in both containers to hold server configuration and save information.

## Create Server Token
Browse to the website: https://accounts.klei.com/account/game/servers?game=DontStarveTogether

Add a cluster name and click 'Add new server' and finally copy the token.

## Starting the server
Configure environment variables as necessary.

Simple single shard (no caves)
```bash
docker run -d --name dst_master \
-e DST_NAME="<name>" \
-e DST_DESCRIPTION="<description>" \
-e DST_PASSWORD="<password>" \
-e DST_MODE="<survival|Wilderness|Endless>" \
-e DST_INTENTION="<Social|Cooperative|Competitive|Madness>" \
-e DST_MAX_PLAYERS="6" \
-e DST_PVP="<true|false>" \
-e DST_TOKEN="<token>" \
-v dst-cluster-config:/home/LinuxGSM/.klei/DoNotStarveTogether/Cluster_1/ \
jmarques15/dont-starve-together
```

Multi-shard (with caves)
```bash
docker network create dst_network

docker run -d --network dst_network -name dst_master \
-e DST_NAME="<name>" \
-e DST_DESCRIPTION="<description>" \
-e DST_PASSWORD="<password>" \
-e DST_MODE="<survival|Wilderness|Endless>" \
-e DST_INTENTION="<Social|Cooperative|Competitive|Madness>" \
-e DST_MAX_PLAYERS="6" \
-e DST_PVP="<true|false>" \
-e DST_TOKEN="<token>" \
-e DST_SHARD=Master \
-v dst-cluster-config:/home/LinuxGSM/.klei/DoNotStarveTogether/Cluster_1/ \
jmarques15/dont-starve-together

docker run -d --network dst_network -name dst_caves \
-e DST_NAME="<name>" \
-e DST_DESCRIPTION="<description>" \
-e DST_PASSWORD="<password>" \
-e DST_MODE="<survival|Wilderness|Endless>" \
-e DST_INTENTION="<Social|Cooperative|Competitive|Madness>" \
-e DST_MAX_PLAYERS="6" \
-e DST_PVP="<true|false>" \
-e DST_TOKEN="<token>" \
-e DST_SHARD=Caves \
-v dst-cluster-config:/home/LinuxGSM/.klei/DoNotStarveTogether/Cluster_1/ \
jmarques15/dont-starve-together
```

Note: docker-compose file for an easier way to spin up a multi-shard environment is included in the github repository. To configure server edit the server.env file.