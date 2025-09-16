#!/bin/bash

if [ ! -f "/pgdata/16/data/PG_VERSION" ]
then
        sudo -u postgres /usr/pgsql-16/bin/initdb -D /pgdata/16/data
        echo "include = 'pg_custom.conf'" >> /pgdata/16/data/postgresql.conf
        cp /pg_custom.conf /pgdata/16/data/
        cp /pg_hba.conf /pgdata/16/data/
        cp /pgsqlProfile /var/lib/pgsql/.pgsql_profile
        cp /photos.sql /pgdata/


	# add ssh keys
	mkdir -p /var/lib/pgsql/.ssh
        cp /id_rsa /var/lib/pgsql/.ssh
        cp /id_rsa.pub /var/lib/pgsql/.ssh
        cp /authorized_keys /var/lib/pgsql/.ssh
        chown -R postgres:postgres /var/lib/pgsql/.ssh
        chmod 0700 /var/lib/pgsql/.ssh
        chmod 0600 /var/lib/pgsql/.ssh/*

        chown postgres:postgres /var/lib/pgsql/.pgsql_profile
        chown postgres:postgres /pgdata/16/data/pg_custom.conf
        chown postgres:postgres /pgdata/16/data/pg_hba.conf
        chown postgres:postgres /pgdata/photos.sql
        sudo -u postgres /usr/pgsql-16/bin/pg_ctl -D /pgdata/16/data start
        sudo -u postgres psql -c "ALTER ROLE postgres PASSWORD 'postgres';"

        if [ -z "$PGSTART" ]
        then
           sudo -u postgres /usr/pgsql-16/bin/pg_ctl -D /pgdata/16/data stop
        else
           sudo -u postgres /usr/pgsql-16/bin/pg_ctl -D /pgdata/16/data restart
        fi
else
        if [ -z "$PGSTART" ]
        then
           sudo -u postgres /usr/pgsql-16/bin/pg_ctl -D /pgdata/16/data start
        fi
fi


# Setup some ssh stuff

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]
then
   ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
   ssh-keygen -t dsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
   ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''
fi

echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

/usr/sbin/sshd

rm -f /run/nologin

# /bin/bash better option than the tail -f especially without a supervisor
# consider using dumb_init in the future as a supervisor https://github.com/Yelp/dumb-init
 
/bin/bash

#exec tail -f /dev/null
#sleep infinity
