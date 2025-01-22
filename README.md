# Docker containers for Postgres 16 pg16-bundle

####  This Docker repo contains all the necessary packages to begin training for Postgres 16 including the following.  

- postgresql16
- patroni
- pgbackrest
- pgbouncer
- haproxy 
- pg_repack
- pg_top
- pg_activity


If you are running Docker and have the resources to host these on your laptop / pc feel free to set it up following the instructions below.

### Clone this repo

    git clone git@github.com:jtorral/pgTraining.git

### Build the image

    docker build -t pg16-rocky8-pg16-bundle .

### Create the network 

    docker network create --driver=bridge --subnet=172.18.0.0/16 pgnet

You can create the network above with your choice of subnet. For this example, I am using `172.18.0.0` if you change this, make the appropriate changes to the --ip option in the docker run commands  to reflect your custom subnet.

You can always inspect a network and see the settings with docker inspect.  For example.

List existing networks on your host

docker network ls  

|NETWORK| ID| NAMEDRIVER |SCOPE|
|---|---|---|---|
|4f664d36595d|pgnet|bridge|local|
|78bd06f9260a|host|host|local|



Then inspect the network with ...

    docker network inspect pgnet | grep Subnet

This will grep the json output for subnet and display the netwrk setting

    "Subnet": "172.18.0.0/16",


### Run the 1st db containers

    docker run -p 5411:5432 --ip 172.18.0.11  --env=PGPASSWORD=postgres -v pg1-pgdata:/pgdata --hostname pg1 --network=pgnet --name=pg1 -d pg16-rocky8-pg16-bundle

### Run the 2nd db containers


    docker run -p 5412:5432 --ip 172.18.0.12  --env=PGPASSWORD=postgres -v pg2-pgdata:/pgdata --hostname pg2 --network=pgnet --name=pg2 -d pg16-rocky8-pg16-bundle


### WAIT !!! IF Instructed to do so, run the 3rd db containers

    docker run -p 5413:5432 --ip 172.18.0.13  --env=PGPASSWORD=postgres -v pg3-pgdata:/pgdata --hostname pg3 --network=pgnet --name=pg3 -d pg16-rocky8-pg16-bundle

### Run a container for the pgbackrest server

    docker run -p 5415:5432 --ip 172.18.0.15  --env=PGPASSWORD=postgres -v pgbackrest-pgdata:/pgdata --hostname pgbackrest --network=pgnet --name=pgbackrest -d pg16-rocky8-pg16-bundle


We will run the ETCD services on the same container as the database server.  If, we wanted them on separate conatiners we would run them like so

### WAIT !!! If instructed to do so,  run the etcd containers

    docker run --hostname etcd1 --ip 172.18.0.21 --network=pgnet --name=etcd1 -d pg16-rocky8-pg16-bundle
    docker run --hostname etcd2 --ip 172.18.0.22 --network=pgnet --name=etcd2 -d pg16-rocky8-pg16-bundle
