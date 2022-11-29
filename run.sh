##########################################
# CUBRID installation script
##########################################
# db
export binary=CUBRID-11.2-latest-Linux.x86_64.tar.gz
export CUBRID=/home/cubat/CUBRID
export db_cre_dest=$CUBRID/database/testdb
export db_log_dest=$CUBRID/database/testdb
export db_lob_dest=$CUBRID/database/testdb
export db_name=testdb
export db_charset=ko_KR.utf8
export ha_mode=on #on or off

# host
export ha_master_user_name=cubat
export ha_master_user_passwd=cubrid
export ha_master_host_ip=172.17.0.3
export ha_master_host_name=689cae454053

export ha_slave_user_name=cubat
export ha_slave_user_passwd=cubrid
export ha_slave_host_ip=172.17.0.10
export ha_slave_host_name=dcb03d85b8c6
##########################################
export ssh_port=22
export directory_config=tempconf
export directory_template=template
##########################################
mkdir -p $directory_config
sh $directory_template/cubrid.sh_template.cfg > $directory_config/cubrid.sh
sh $directory_template/cubrid.conf_template.cfg > $directory_config/cubrid.conf
sh $directory_template/cubrid_ha.conf_template.cfg > $directory_config/cubrid_ha.conf

scp -r $directory_config $ha_master_user_name@$ha_master_host_ip:/tmp/$directory_config

scp $binary $ha_master_user_name@$ha_master_host_ip:/tmp/$directory_config


sshpass -p $ha_master_user_passwd ssh $ha_master_user_name@$ha_master_host_ip 'tar -xvzf /tmp/'$directory_config'/'$binary
sshpass -p $ha_master_user_passwd ssh $ha_master_user_name@$ha_master_host_ip 'cp /tmp/'$directory_config'/cubrid.sh $HOME'
sshpass -p $ha_master_user_passwd ssh $ha_master_user_name@$ha_master_host_ip 'cp /tmp/'$directory_config'/cubrid.conf '$CUBRID'/conf'
sshpass -p $ha_master_user_passwd ssh $ha_master_user_name@$ha_master_host_ip 'cp /tmp/'$directory_config'/cubrid_ha.conf '$CUBRID'/conf'
sshpass -p $ha_master_user_passwd ssh $ha_master_user_name@$ha_master_host_ip 'echo . cubrid.sh  >> .bashrc'
sshpass -p $ha_master_user_passwd ssh $ha_master_user_name@$ha_master_host_ip 'mkdir -p '$db_cre_dest
sshpass -p $ha_master_user_passwd ssh $ha_master_user_name@$ha_master_host_ip 'mkdir -p '$db_log_dest
sshpass -p $ha_master_user_passwd ssh $ha_master_user_name@$ha_master_host_ip 'mkdir -p '$db_lob_dest
sshpass -p $ha_master_user_passwd ssh $ha_master_user_name@$ha_master_host_ip 'cubrid createdb --server-name='$ha_master_host_name':'$ha_slave_host_name' -F '$db_cre_dest' -L '$db_log_dest' -B '$db_lob_dest' '$db_name' '$db_charset

scp -r $directory_config $ha_slave_user_name@$ha_slave_host_ip:/tmp/$directory_config
scp $binary $ha_slave_user_name@$ha_slave_host_ip:/tmp/$directory_config
sshpass -p $ha_slave_user_passwd ssh $ha_slave_user_name@$ha_slave_host_ip 'tar -xvzf /tmp/'$directory_config'/'$binary
sshpass -p $ha_slave_user_passwd ssh $ha_slave_user_name@$ha_slave_host_ip 'cp /tmp/'$directory_config'/cubrid.sh $HOME'
sshpass -p $ha_slave_user_passwd ssh $ha_slave_user_name@$ha_slave_host_ip 'cp /tmp/'$directory_config'/cubrid.conf '$CUBRID'/conf'
sshpass -p $ha_slave_user_passwd ssh $ha_slave_user_name@$ha_slave_host_ip 'cp /tmp/'$directory_config'/cubrid_ha.conf '$CUBRID'/conf'
sshpass -p $ha_slave_user_passwd ssh $ha_slave_user_name@$ha_slave_host_ip 'echo . cubrid.sh  >> .bashrc'
sshpass -p $ha_slave_user_passwd ssh $ha_slave_user_name@$ha_slave_host_ip 'mkdir -p '$db_cre_dest
sshpass -p $ha_slave_user_passwd ssh $ha_slave_user_name@$ha_slave_host_ip 'mkdir -p '$db_log_dest
sshpass -p $ha_slave_user_passwd ssh $ha_slave_user_name@$ha_slave_host_ip 'mkdir -p '$db_lob_dest
sshpass -p $ha_slave_user_passwd ssh $ha_slave_user_name@$ha_slave_host_ip 'cubrid createdb --server-name='$ha_master_host_name':'$ha_slave_host_name' -F '$db_cre_dest' -L '$db_log_dest' -B '$db_lob_dest' '$db_name' '$db_charset

sshpass -p $ha_master_user_passwd ssh $ha_master_user_name@$ha_master_host_ip 'cat /etc/hosts'
sshpass -p $ha_slave_user_passwd ssh $ha_slave_user_name@$ha_slave_host_ip 'cat /etc/hosts'