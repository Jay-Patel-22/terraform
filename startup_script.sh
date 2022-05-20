#!/bin/bash
set -e

export HOSTNAME=$(hostname)
export MAX=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/MAX -H "Metadata-Flavor: Google")
export SERVER_NAME=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/SERVER_NAME -H "Metadata-Flavor: Google")
echo "----------------host: $HOSTNAME"

sudo mkdir -p /usr/soft/zookeeper/
sudo chmod 777 /usr/soft/zookeeper/

for i in `seq 1 $MAX`
do
    server=$(gcloud compute instances describe $SERVER_NAME-$i --zone asia-south1-a --format='get(networkInterfaces[0].networkIP)')
    sudo chmod 777 /etc/hosts
    echo "$server $SERVER_NAME-$i" >> /etc/hosts
    sudo chmod 444 /etc/hosts
    if [ "$HOSTNAME" = $SERVER_NAME-$i ]; then
        echo "node-$i"
        sudo docker run -d -p 2181:2181 -p 2888:2888 -p 3888:3888 -p 7000:7000 --name zookeeper_node --restart always \
        -v /usr/soft/zookeeper/data:/data \
        -v /usr/soft/zookeeper/datalog:/datalog \
        -v /usr/soft/zookeeper/logs:/logs \
        -v /usr/soft/zookeeper/conf:/conf \
        --network host \
        -e ZOO_MY_ID=$i zookeeper
        sudo chmod 777 /usr/soft/zookeeper/conf
        sudo echo "dataDir=/data
dataLogDir=/datalog
tickTime=2000
initLimit=5
syncLimit=2
autopurge.snapRetainCount=3
autopurge.purgeInterval=0
metricsProvider.className=org.apache.zookeeper.metrics.prometheus.PrometheusMetricsProvider
globalOutstandingLimit=100000
maxClientCnxns=60" > /usr/soft/zookeeper/conf/zoo.cfg
      for x in `seq 1 $MAX`
      do
        sudo echo "server.$x=$SERVER_NAME-$x:2888:3888;2181" >> /usr/soft/zookeeper/conf/zoo.cfg
      done
    else
        echo "no node"
        fi
done

sudo apt-get -y update
#sudo apt-get --allow-releaseinfo-change update
sudo apt-get -y upgrade 
sudo apt-get -y install wget
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar -xzvf node_exporter-1.3.1.linux-amd64.tar.gz
sudo mv node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/node_exporter
sudo useradd -rs /bin/false nodeusr
echo "[Unit]
Description=Node Exporter
After=network.target
[Service]
User=nodeusr
Group=nodeusr
Type=simple
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

