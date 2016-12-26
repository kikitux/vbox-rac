#!/bin/bash


scan="${dc}${prefix}-scan.${domain}"
gns="${dc}${prefix}.${domain}"
gnsvip="${dc}${prefix}-cluster-gns.${domain}"

if [ ! "${GIVER}" ] ; then
  GIVER="12.1.0.2"
fi

if [ ! "${DBVER}" ] ; then
  DBVER="12.1.0.2"
fi

PATHTOFILES=/media/ansible/oravirt

p="libselinux-python lvm2 ntp"
rpm -q ${p} &>/dev/null || {
  yum install -y ${p}
}

# Set cluster_type to 'standard' if nothing is passed to this script. Needed as we always pass cluster_type to the playbook
if [[ "${cluster_type}" == "flex" && $GIVER && "$GIVER" =~ "12" ]]; then
  cluster_type="flex"
else
  cluster_type="standard"
fi

#using associative array:
unset oracle_sw
declare -A oracle_sw

oracle_sw["db":"12.1.0.2"]='{"oracle_sw_image_db":[{"filename":"linuxamd64_12102_database_1of2.zip","version":"12.1.0.2"},{"filename":"linuxamd64_12102_database_2of2.zip","version":"12.1.0.2"}]}'
oracle_sw["db":"12.1.0.1"]='{"oracle_sw_image_db":[{"filename":"linuxamd64_12c_database_1of2.zip","version":"12.1.0.1"},{"filename":"linuxamd64_12c_database_2of2.zip","version":"12.1.0.1"}]}'
oracle_sw["db":"11.2.0.4"]='{"oracle_sw_image_db":[{"filename":"p13390677_112040_Linux-x86-64_1of7.zip","version":"11.2.0.4"},{"filename":"p13390677_112040_Linux-x86-64_2of7.zip","version":"11.2.0.4"}]}'
#oracle_sw["db":"11.2.0.3"]='{"oracle_sw_image_db":[{"filename":"p10404530_112030_Linux-x86-64_1of7.zip","version":"11.2.0.3"},{"filename":"p10404530_112030_Linux-x86-64_2of7.zip","version":"11.2.0.3"}]}'

oracle_sw["gi":"12.1.0.2"]='true'
oracle_sw["gi":"12.1.0.1"]='true'
oracle_sw["gi":"11.2.0.4"]='true'
#oracle_sw["gi":"11.2.0.3"]='true'

#must pass 3 checks
#variable set
#variable is on the defined options
#value must be 8 character long. Otherwise 11 or 12 would be a valid option. We need nn.n.n.n

if [[ $GIVER && "${!oracle_sw[@]}" =~ "gi:$GIVER" && "${#GIVER}" -eq 8 ]]; then
  echo "GIVER VALID"
else
  echo "ERROR: GIVER INVALID. Check the version and/or format: e.g 12.1.0.2 "
  exit 1
fi

if [[ $DBVER && "${!oracle_sw[@]}" =~ "db:$DBVER" && "${#DBVER}" -eq 8 ]]; then
  echo "DBVER VALID"
else
  echo "ERROR: DBVER INVALID. Check the version and/or format: e.g 12.1.0.2 "
  exit 1
fi

echo "Setting up cluster with GI version: $GIVER and DB version: $DBVER, cluster_type: $cluster_type"
time ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook $PATHTOFILES/ansible-oracle/vbox-rac-full-install.yml -i /media/ansible/inventory.${dc} -e oracle_gi_cluster_type=$cluster_type -e oracle_install_version_gi=$GIVER -e '{"oracle_databases":[{"home":"rachome1","oracle_version_db":"'"$DBVER"'","oracle_edition":"EE","oracle_db_name":"orcl","oracle_db_passwd":"Password1","oracle_db_type":"RAC","is_container":"false","pdb_prefix":"pdb","num_pdbs":"1","is_racone":"false","storage_type":"ASM", "service_name":"orcl_serv","oracle_init_params":"open_cursors=300,processes=500","oracle_db_mem_percent":"25","oracle_database_type":"MULTIPURPOSE","redolog_size_in_mb":"100 ", "state":"present" }]}' -e '${oracle_sw["db":"'$DBVER'"]}' -e '{"oracle_scan":"'${scan}'"}' -e '{"oracle_gi_gns_subdomain":"'${gns}'"}' -e '{"oracle_gi_gns_vip":"'${gnsvip}'"}' -e '{"role_separation":true}'
