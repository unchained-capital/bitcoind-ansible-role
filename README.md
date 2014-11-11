This is an [Ansible](http://www.ansible.com/home) role for installing
[bitcoind](https://github.com/bitcoin/bitcoin).

# What it Does

## Software

Downloads, compiles, and installs `bitcoind` from source.

Also installs [blockparser](https://github.com/mcdee/blockparser) for
dumping the blockchain to text.

## Configuration & Logging

Creates the files:

* `/etc/bitcoin/bitcoind.conf` -- configuration file for Zabbix agent

## Services

Leaves the service `bitcoind` running on port 8333.  The JSON-RPC
interface can optionally be left running over port 8332, see
`bitcoind_server`.

# Usage

Use the role in a playbook like this:

```yaml
- hosts: all
  roles:
    - bitcoind
```

## Variables

The following variables are exposed for configuration

* `bitcoind_repo` -- the git repo to use to build bitcoind (default: http://github.com/bitcoin/bitcoin)
* `bitcoind_user` -- user running bitcoind (default: `bitcoind`)
* `bitcoind_group` -- group for user running bitcoind (default: `bitcoind`)

* `bitcoind_add_nodes` -- list of initial peers to add
* `bitcoind_only_nodes` -- list of peers to **limit** connections to
* `bitcoind_whitelist` -- list of peers given special treatment
* `bitcoind_banscore` -- threshold for disconnecting misbehaving peers (default: 100)
* `bitcoind_bantime` -- length of bans in seconds (default: 1 day)
* `bitcoind_seednode` -- connect to this seed node for peer addresses, then disconnect
* `bitcoind_dns` -- allow DNS lookups (default: 1)
* `bitcoind_dnsseed` -- query for more peer addresses via DNS (default: 1)
* `bitcoind_forcednsseed` -- **always** query for more peer addresses via DNS (default: 0)
* `bitcoind_externalip` -- explicit public address
* `bitcoind_proxy` -- use this SOCKS5 proxy
* `bitcoind_onion` -- use this Tor SOCKS5 proxy
* `bitcoind_net` -- only connect to peers in given net, one of: ipv4, ipv6, or onion
* `bitcoind_data_carrier` -- relay and mine data carrier transactions (default: 1)

* `bitcoind_alertnotify` -- command to run on an alert (`%s` replaced by message)
* `bitcoind_blocknotify` -- command to run when best block changes (`%s` replaced by block hash)

* `bitcoind_daemon` -- run as a daemon
* `bitcoind_listen` -- accept connections (default: 1 if no `bitcoind_proxy` or `bitcoind_only_nodes`)
* `bitcoind_port` -- listen for connections on the given port (default: 8333)
* `bitcoind_bind` -- specific network address to bind to
* `bitcoind_checkblocks` -- blocks to check at startup (default: 288, 0: all)
* `bitcoind_discover` -- discover own IP address (default: 1 when listening and no `bitcoind externalip`)

* `bitcoind_dbcache` -- size of database cache in MB (default: 100, range: 4-4096)
* `bitcoind_maxorphanblocks` -- Max number of unconnectable blocks kept in memory (default: 750)
* `bitcoind_maxorphantx` -- Max number of unconnectable transactions kept in memory (default: 100)
* `bitcoind_max_connections` -- Max number of connections
* `bitcoind_max_receive_buffer` -- Max per-connection receiver buffer size (default: 5000)
* `bitcoind_timeout` -- Connection timeout in ms (default: 5000, minimum: 1)
* `bitcoind_whitebind` -- bind to given address and whitelist peers connecting to it

* `bitcoind_debug` -- debug output
* `bitcoind_logips` -- include IP addresses in debug output (default: 0)
* `bitcoind_log_timestamps` -- prepend debug output with timestamp (default: 1)
* `bitcoind_min_relay_tx_fee` -- fees lower than this are considered to be zero (default: 0.00001)
* `bitcoind_print_to_console` -- print trace/debug info to console instead of debug.log file
* `bitcoind_shrink_debug_file` -- shrink debug.log file on startup (default: 1 when no `bitcoind_debug`)
* `bitcoind_testnet` -- run on the test network instead of the real network

* `bitcoind_block_min_size` -- minimum block size in bytes (default: 0)
* `bitcoind_block_max_size` -- maximum block size in bytes (default: 750000)
* `bitcoind_block_priority_size` -- maximum size of high-priority/low-fee transactions in bytes (default: 50000)

* `bitcoind_server` -- accept JSON-RPC commands
* `bitcoind_rpcbind` -- bind to this address (default: bind to all network interfaces)
* `bitcoind_rpcport` -- port to listen to (default: 8332)
* `bitcoind_rpcuser` -- required for JSON-RPC API
* `bitcoind_rpcpassword` -- required for JSON-RPC API
* `bitcoind_rpc_allow` -- list of addresses from which to allow JSON-RPC connections
* `bitcoind_rpc_threads` -- number of threads to service RPC calls (default: 4)

* `bitcoind_rpc_ssl` -- use SSL when communicated with bitcoind RPC
* `bitcoind_rpc_ssl_ciphers` -- list of acceptable ciphers (default: `TLSv1+HIGH:!SSLv2:!aNULL:!eNULL:!AH:!3DES:@STRENGTH`)
* `bitcoind_rpc_ssl_cert` -- SSL certificate for RPC over SSL
* `bitcoind_rpc_ssl_priv_key` -- SSL private key for RPC over SSL

