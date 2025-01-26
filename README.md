# Docker containers for Postgres. pg16-bundle

####  This Docker repo contains a bunch of Postgres related packages. View the Dockerfile for a complete list of what is installed.

If you are running Docker and have the resources to host these on your laptop / pc feel free to set it up following the instructions below.

### Further down on this page are cleanup steps for removing after you are done.



### Clone this repo

    git clone git@github.com:jtorral/pgTraining.git


## Buildng the docker image.  There are 3 Options available for this build. 

### Standard build x86. Copy the DockerfileX86 to Dockerfile then

    docker build -t pg16-rocky8-bundle .

### ARM build for Mac ARM. Copy the DockerfileMacArm to Dockerfile then

    docker build -t pg16-rocky8-bundle .

### The Percona distribution of Postgres build. Copy the DockerfilePerconaDist to Dockerfile then

    docker build -t pg16-rocky8-bundle .



### Create the network 

    docker network create pgnet

### Run the 1st db containers

    docker run -p 5411:5432 --env=PGPASSWORD=postgres -v pg1-pgdata:/pgdata --hostname pg1 --network=pgnet --name=pg1 -d pg16-rocky8-bundle


### Run the 2nd db containers

    docker run -p 5412:5432 --env=PGPASSWORD=postgres -v pg2-pgdata:/pgdata --hostname pg2 --network=pgnet --name=pg2 -d pg16-rocky8-bundle


### Run the 3rd db containers

    docker run -p 5413:5432 --env=PGPASSWORD=postgres -v pg3-pgdata:/pgdata --hostname pg3 --network=pgnet --name=pg3 -d pg16-rocky8-bundle



### WAIT !!! Don't start the following containers unless you want to. They are optional. ### 


### Run a container for the pgbackrest server

    docker run -p 5415:5432 --env=PGPASSWORD=postgres -v pgbackrest-pgdata:/pgdata --hostname pgbackrest --network=pgnet --name=pgbackrest -d pg16-rocky8-bundle


We will run the ETCD services on the same container as the database server.  If, we wanted them on separate conatiners we would run them like so

    docker run --hostname etcd1 --network=pgnet --name=etcd1 -d pg16-rocky8-bundle
    docker run --hostname etcd2 --network=pgnet --name=etcd2 -d pg16-rocky8-bundle


### How to cleanup afterwards ###

If you wish to cleanup the docker containers afterwards you will need to stop them and remove them.
You can leave the volumes in place if you want the data saved or you can remove them as well. It is all detailed below



For example, if we are running just the 1 container pg1 and want to remove it ...


    docker stop pg1
    docker rm pg1


Then identify the volumes used by it

    docker volume ls


|DRIVER|    VOLUME NAME|
|---|---|
|local|pg1-pgdata|
|local|pgDipper-etc|
|local|pgDipper-home|
|local|pgDipper-pgdata|


Remove the volume if you want it gone for good.

    docker volume rm pg1-data

There may be additional volumes if you started the other containers

Finally, if you want to remove the network created earlier then run ...

    docker network rm pgnet


If you find this repo useful, feel free to send me a dozen classic glazed doughnuts from Krispy Kreme.
