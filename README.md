# Daemon

At Elliptic, we use containers to run our blockchain daemons in a secure, reliable and replicable way.

## Supported Daemons

| Network | Build Version (tested) | Docker Hub  |
| ------------- | --------------| ------------|
| Bitcoin | 0.17.x, 0.18.x | 0.18.0, 0.18.1 |
| Bitcoin Cash (ABC) | 0.19.x | 0.19.8, 0.19.9, 0.19.10 |
| Litecoin | 0.17.x | 0.17.1 |
| Dash | 0.14.x.x | 0.14.0.2, 0.14.0.3 |
| Monero | 0.14.1.2 | 0.14.1.2 |
| Parity (Ethereum) | 2.5.9-stable | 2.5.9-stable |
| Zilliqa | coming soon |   |
| Zcash | coming soon |  |

The blockchain you want not supported? Create an issue and we'll get to it. Or, even better, make a pull request (see [contributing](/CONTRIBUTING.md))!

## Getting Started

### Docker Hub 

For each supported deamon, you can pull images directly Docker Hub. 

The Convention is as follows:
```
docker run elliptic/${NETWORK_NAME}:${DAEMON_VERSION}
```
For example, you can run version 0.18.0 bitcoind as follows:
```
docker run elliptic/bitcoin:0.18.0
```
This will pull and run the latest version of the container for the given daemon version.

### Build Yourself
We'll try to be on top of pushing new versions. Alternatively you can easily build the images yourself. From the project root run:

```
docker build -t my-bitcoin-cash --build-arg VERSION=0.19.9 bitcoin-cash 
docker run my-bitcoin-cash
```


### Docker Compose
We've provided a docker-compose file as a template to get started.
```
docker-compose up bitcoin
```
This will run the the given daemon on its respective testnet with the JSON rpc server enabled and exposed on 18332.

## Configuration

You can add config arguments as follows (if only arguments are given, the container automatically applies them to the respective daemon command):
```
docker run elliptic/bitcoin:0.18.0 -server=1 \
	-rpcuser=rpcuser \
	-rpcpassword=rpcpassword \
	-rpcallowip=0.0.0.0/0
```
You can stil overwrite the command:
```
docker run -it elliptic/bitcoin:0.18.0 bash
```
Or if already running:
```
docker exec -it ${CONTAINER_ID} bash
```

## Convention
One of the most time consuming parts of running different daemons is the naming conventions of .conf files, data directories, wallet files, ports etc.
Containerisation allows us to make this much more consistent:
  - Each daemon will be run by the "daemon" user
  - The data directory will default to /home/daemon/.daemon
  - Each container will have a default .conf file. This file will contain a number of basic defaults:
  ⋅⋅* Set the data directory to /home/daemon/.daemon
  ..* Ensure logs are sent to stdout so are visible from the host
	..* Reliable ports (regardles of testnet/mainnet and daemon): Listening: 8333, RPC: 8332

*All defaults can be overwritten - see advanced below.*

## Deployment

We use Kubernetes / Helm to deploy our daemons. 
These containers work nicely with the [bitcoind](https://github.com/helm/charts/tree/master/stable/bitcoind) Helm Chart with varying amounts of configuration depending on the daemon.
In the future, example configuration will be provided here to aid deployments.

## Advanced
TODO: This section will include examples of how you can:
 -> Overwite .conf files (rather than provide cli args)
 -> Run multiple wallets
 -> Volume cloning (for scaling in kubernetes)

Please create an issue if you'd like to see any of this (or anything else!).

## Contributing
Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

