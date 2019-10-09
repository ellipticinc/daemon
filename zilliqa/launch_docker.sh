#!/bin/bash

prog=$(basename $0)
mykeyfile=mykey.txt
myaddrfile=myaddr.txt
image=zilliqa/zilliqa:v5.0.1
os=$(uname)
testnet_name='mainnet-potong-pasir'
exclusion_txbodies_mb="false"
bucket_name='c5b68604-8540-4887-ad29-2ab9e680f997'

case "$os" in
    Linux)
        # we should be good on Linux
        ;;
    Darwin)
        echo "This script doesn not support Docker for Mac"
        exit 1
        ;;
    *)
        echo "This script does not support Docker on your platform"
        exit 1
        ;;
esac

function genkeypair() {
if [ -s $mykeyfile ]
then
    echo -n "$mykeyfile exist, overwrite [y/N]?"
    read confirm && [ "$confirm" != "yes" -a "$confirm" != "y" ] && return
fi
sudo docker run --rm $image -c genkeypair > $mykeyfile
}

function run() {

name="zilliqa"
ip=""
port="33133"

if [ "$1" = "cuda" ]
then
    cuda_docker="--runtime=nvidia"
    image="$image-cuda"
fi

workdir=/run/zilliqa

if [ ! -s $mykeyfile ]
then
    echo "Cannot find $mykeyfile, generating new keypair for you..."
    sudo docker run $image -c genkeypair > $mykeyfile && echo "$mykeyfile generated"
fi

prikey=$(cat $mykeyfile | awk '{ print $2 }')
pubkey=$(cat $mykeyfile | awk '{ print $1 }')
echo -n "Assign a name to your container (default: $name): " && read name_read && [ -n "$name_read" ] && name=$name_read
echo -n "Enter your IP address ('NAT' or *.*.*.*): " && read ip_read && [ -n "$ip_read" ] && ip=$ip_read
echo -n "Enter your listening port (default: $port): " && read port_read && [ -n "$port_read" ] && port=$port_read

MY_PATH="`dirname \"$0\"`"
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"

#FIXME-LATER -Now replace TESTNET_NAME in downloadIncrDB.py directly because it will be invoked by zilliqa process in some cases and 
#             and will need the testnet name.
cmd="sed -i \"/TESTNET_NAME=/c\TESTNET_NAME= '${testnet_name}'\" /zilliqa/scripts/downloadIncrDB.py && sed -i \"/BUCKET_NAME=/c\BUCKET_NAME= '${bucket_name}'\" /zilliqa/scripts/downloadIncrDB.py && /zilliqa/scripts/downloadIncrDB.py /run/zilliqa ${exclusion_txbodies_mb} > download.log 2>&1"
sudo docker run $cuda_docker --network host --rm -v $(pwd):$workdir -w $workdir --name $name $image -c "$cmd"
sudo docker stop $name

sudo docker run $image -c "getaddr --pubk $pubkey" > $myaddrfile

sudo docker run $cuda_docker --network host -d -v $(pwd):$workdir -w $workdir --name $name $image -c "tail -f /dev/null"
sleep 5

cmd="cp /zilliqa/scripts/downloadIncrDB.py /run/zilliqa/downloadIncrDB.py && sed -i \"/TESTNET_NAME=/c\TESTNET_NAME= '${testnet_name}'\" /run/zilliqa/downloadIncrDB.py && zilliqa --privk $prikey --pubk $pubkey --address $ip --port $port --synctype 6 --recovery"
echo "Running in docker : ${name} with command: '$cmd'"
sudo docker exec -d -w $workdir $name bash -c "$cmd"

# Please note - Do not remove below line
sudo docker exec -d -it $name bash -c '/zilliqa/daemon/run.sh cseed && tail -f /dev/null'

echo
echo "Use 'docker ps' to check the status of the docker"
echo "Use 'docker stop $name' to terminate the container"
echo "Use 'tail -f zilliqa-00001-log.txt' to see the runtime log"
}

function cleanup() {
rm -rfv "*-log.txt"
}

function usage() {
cat <<EOF
Usage: $prog [OPTIONS]
Options:
    --genkeypair            generate new keypair and saved to '$mykeyfile'
    --cuda                  use nvidia-docker for mining
    --cleanup               remove log files
    --help                  show this help message
EOF
}

case "$1" in
    "") run;;
    --genkeypair) genkeypair;;
    --cleanup) cleanup;;
    --cuda) run cuda;;
    --help) usage;;
    *) echo "Unrecongized option '$1'"; usage;;
esac
