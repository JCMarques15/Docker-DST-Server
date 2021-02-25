# Dont-Starve-Together-Server

## Create Server Token
Browse to the website: https://accounts.klei.com/account/game/servers?game=DontStarveTogether

Add a cluster name and click 'Add new server' and finally copy the token.

## Build Image
### Configure cluster
Modify as necessary the following files:
* build/src
    * dstserver.cfg -> Server settings (such as alerts)
    * dedicated_server_mods_setup.lua -> Subscribe to mods
* build/src/cluster
    * cluster.ini -> Cluster settings
    * adminlist.txt -> administrator IDs
    * blocklist.txt -> Blocked user IDs
    * whitelist.txe -> Whitelisted users IDs (slot reservation)
* build/src/cluster/Master
    * server.ini -> Master server configuration
    * modoverrides.lua -> Enable Mods for Master server
* build/src/cluster/Caves
    * server.ini -> Caves server configuration
    * modoverrides.lua -> Enable Mods for Caves server

Add token to build/src/cluster/cluster_token.txt (create file if necessary).

### Build and start servers
```bash
docker-compose up
```
Congratulations you have a server ready to use!

## Use pre-built image
Configure environment variables as necessary. Note: To use mods, the container needs to be started first and using a different entrypoint (to bash for example) mods need to be configured and the container restarted.

Simple single shard (no caves)
```bash
docker run -d --name dst_master \
-e DST_NAME="<name>" \
-e DST_DESCRIPTION="<description>" \
-e DST_PASSWORD="<password>" \
-e DST_MODE="<mode>" \
-e DST_INTENTION="<intention>" \
-e DST_MAX_PLAYERS="<num_max_players>" \
-e DST_PVP="<true|false>" \
-e DST_TOKEN="<token>" \
jmarques15/dont-starve-together
```

Multi-shard (with caves)
```bash
docker network create dst_network

docker run -d --network dst_network -name dst_master \
-e DST_NAME="<name>" \
-e DST_DESCRIPTION="<description>" \
-e DST_PASSWORD="<password>" \
-e DST_MODE="<mode>" \
-e DST_INTENTION="<intention>" \
-e DST_MAX_PLAYERS="<num_max_players>" \
-e DST_PVP="<true|false>" \
-e DST_TOKEN="<token>" \
-e DST_SHARD=Master \
jmarques15/dont-starve-together

docker run -d --network dst_network -name dst_caves \
-e DST_NAME="<name>" \
-e DST_DESCRIPTION="<description>" \
-e DST_PASSWORD="<password>" \
-e DST_MODE="<mode>" \
-e DST_INTENTION="<intention>" \
-e DST_MAX_PLAYERS="<num_max_players>" \
-e DST_PVP="<true|false>" \
-e DST_TOKEN="<token>" \
-e DST_SHARD=Caves \
jmarques15/dont-starve-together
```