#!/usr/bin/env bash

echo ${domain} ${lan} ${priv} ${prefixdc}

p="dnsmasq"
rpm -q ${p} &>/dev/null || {
  yum install -y ${p}
}


if [ ! "${domain}" ]; then
  domain=racattack
fi

grep 'addn-hosts=/vagrant/hosts.domain' /etc/dnsmasq.conf || {
  echo 'addn-hosts=/vagrant/hosts.domain' | tee -a /etc/dnsmasq.conf 
}

cat > /vagrant/hosts.domain <<EOF
192.168.${lan}.251 ${prefixdc}-scan.${domain} ${prefixdc}-scan
192.168.${lan}.252 ${prefixdc}-scan.${domain} ${prefixdc}-scan
192.168.${lan}.253 ${prefixdc}-scan.${domain} ${prefixdc}-scan
192.168.${lan}.51 ${prefixdc}n1.${domain} ${prefixdc}n1
172.16.${priv}.51 ${prefixdc}n1-priv.${domain} ${prefixdc}n1-priv
192.168.${lan}.61 ${prefixdc}n1-vip.${domain} ${prefixdc}n1-vip
192.168.${lan}.52 ${prefixdc}n2.${domain} ${prefixdc}n2
172.16.${priv}.52 ${prefixdc}n2-priv.${domain} ${prefixdc}n2-priv
192.168.${lan}.62 ${prefixdc}n2-vip.${domain} ${prefixdc}n2-vip
192.168.${lan}.53 ${prefixdc}n3.${domain} ${prefixdc}n3
172.16.${priv}.53 ${prefixdc}n3-priv.${domain} ${prefixdc}n3-priv
192.168.${lan}.63 ${prefixdc}n3-vip.${domain} ${prefixdc}n3-vip
192.168.${lan}.54 ${prefixdc}n4.${domain} ${prefixdc}n4
172.16.${priv}.54 ${prefixdc}n4-priv.${domain} ${prefixdc}n4-priv
192.168.${lan}.64 ${prefixdc}n4-vip.${domain} ${prefixdc}n4-vip
192.168.${lan}.55 ${prefixdc}n5.${domain} ${prefixdc}n5
172.16.${priv}.55 ${prefixdc}n5-priv.${domain} ${prefixdc}n5-priv
192.168.${lan}.65 ${prefixdc}n5-vip.${domain} ${prefixdc}n5-vip
192.168.${lan}.56 ${prefixdc}n6.${domain} ${prefixdc}n6
172.16.${priv}.56 ${prefixdc}n6-priv.${domain} ${prefixdc}n6-priv
192.168.${lan}.66 ${prefixdc}n6-vip.${domain} ${prefixdc}n6-vip
192.168.${lan}.57 ${prefixdc}n7.${domain} ${prefixdc}n7
172.16.${priv}.57 ${prefixdc}n7-priv.${domain} ${prefixdc}n7-priv
192.168.${lan}.67 ${prefixdc}n7-vip.${domain} ${prefixdc}n7-vip
192.168.${lan}.58 ${prefixdc}n8.${domain} ${prefixdc}n8
172.16.${priv}.58 ${prefixdc}n8-priv.${domain} ${prefixdc}n8-priv
192.168.${lan}.68 ${prefixdc}n8-vip.${domain} ${prefixdc}n8-vip
192.168.${lan}.59 ${prefixdc}n9.${domain} ${prefixdc}n9
172.16.${priv}.59 ${prefixdc}n9-priv.${domain} ${prefixdc}n9-priv
192.168.${lan}.69 ${prefixdc}n9-vip.${domain} ${prefixdc}n9-vip
192.168.${lan}.71 ${prefixdc}l1.${domain} ${prefixdc}l1
172.16.${priv}.71 ${prefixdc}l1-priv.${domain} ${prefixdc}l1-priv
192.168.${lan}.81 ${prefixdc}l1-vip.${domain} ${prefixdc}l1-vip
192.168.${lan}.72 ${prefixdc}l2.${domain} ${prefixdc}l2
172.16.${priv}.72 ${prefixdc}l2-priv.${domain} ${prefixdc}l2-priv
192.168.${lan}.82 ${prefixdc}l2-vip.${domain} ${prefixdc}l2-vip
192.168.${lan}.73 ${prefixdc}l3.${domain} ${prefixdc}l3
172.16.${priv}.73 ${prefixdc}l3-priv.${domain} ${prefixdc}l3-priv
192.168.${lan}.83 ${prefixdc}l3-vip.${domain} ${prefixdc}l3-vip
192.168.${lan}.74 ${prefixdc}l4.${domain} ${prefixdc}l4
172.16.${priv}.74 ${prefixdc}l4-priv.${domain} ${prefixdc}l4-priv
192.168.${lan}.84 ${prefixdc}l4-vip.${domain} ${prefixdc}l4-vip
192.168.${lan}.75 ${prefixdc}l5.${domain} ${prefixdc}l5
172.16.${priv}.75 ${prefixdc}l5-priv.${domain} ${prefixdc}l5-priv
192.168.${lan}.85 ${prefixdc}l5-vip.${domain} ${prefixdc}l5-vip
192.168.${lan}.76 ${prefixdc}l6.${domain} ${prefixdc}l6
172.16.${priv}.76 ${prefixdc}l6-priv.${domain} ${prefixdc}l6-priv
192.168.${lan}.86 ${prefixdc}l6-vip.${domain} ${prefixdc}l6-vip
192.168.${lan}.77 ${prefixdc}l7.${domain} ${prefixdc}l7
172.16.${priv}.77 ${prefixdc}l7-priv.${domain} ${prefixdc}l7-priv
192.168.${lan}.87 ${prefixdc}l7-vip.${domain} ${prefixdc}l7-vip
192.168.${lan}.78 ${prefixdc}l8.${domain} ${prefixdc}l8
172.16.${priv}.78 ${prefixdc}l8-priv.${domain} ${prefixdc}l8-priv
192.168.${lan}.88 ${prefixdc}l8-vip.${domain} ${prefixdc}l8-vip
192.168.${lan}.79 ${prefixdc}l9.${domain} ${prefixdc}l9
172.16.${priv}.79 ${prefixdc}l9-priv.${domain} ${prefixdc}l9-priv
192.168.${lan}.89 ${prefixdc}l9-vip.${domain} ${prefixdc}l9-vip
192.168.${lan}.91 ${prefixdc}a1.${domain} ${prefixdc}a1
192.168.${lan}.92 ${prefixdc}a2.${domain} ${prefixdc}a2
192.168.${lan}.93 ${prefixdc}a3.${domain} ${prefixdc}a3
192.168.${lan}.94 ${prefixdc}a4.${domain} ${prefixdc}a4
192.168.${lan}.95 ${prefixdc}a5.${domain} ${prefixdc}a5
192.168.${lan}.96 ${prefixdc}a6.${domain} ${prefixdc}a6
192.168.${lan}.97 ${prefixdc}a7.${domain} ${prefixdc}a7
192.168.${lan}.98 ${prefixdc}a8.${domain} ${prefixdc}a8
192.168.${lan}.99 ${prefixdc}a9.${domain} ${prefixdc}a9
192.168.${lan}.244 ${prefixdc}-cluster-gns.${domain} ${prefixdc}-cluster-gns
EOF

chkconfig dnsmasq on
service dnsmasq restart
