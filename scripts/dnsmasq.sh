#!/usr/bin/env bash

echo ${domain} ${lan} ${priv} ${dcprefix} ${dca} ${prefix}
exit


p="dnsmasq"
rpm -q ${p} &>/dev/null || {
  yum install -y ${p}
}


if [ ! "${domain}" ]; then
  domain=racattack
fi

for param in "addn-hosts=/vagrant/hosts.${domain}" "server=/${dcprefix}.${domain}/192.168.${lan}.244" "interface=lo" "bind-interfaces" "listen-address=127.0.0.1"
do
  grep "^${param}" /etc/dnsmasq.conf || {
    echo "${param}" | tee -a /etc/dnsmasq.conf
  }
done

cat > /vagrant/hosts.${domain} <<EOF
192.168.${lan}.51 ${dcprefix}n1.${domain} ${dcprefix}n1
172.16.${priv}.51 ${dcprefix}n1-priv.${domain} ${dcprefix}n1-priv
192.168.${lan}.61 ${dcprefix}n1-vip.${domain} ${dcprefix}n1-vip
192.168.${lan}.52 ${dcprefix}n2.${domain} ${dcprefix}n2
172.16.${priv}.52 ${dcprefix}n2-priv.${domain} ${dcprefix}n2-priv
192.168.${lan}.62 ${dcprefix}n2-vip.${domain} ${dcprefix}n2-vip
192.168.${lan}.53 ${dcprefix}n3.${domain} ${dcprefix}n3
172.16.${priv}.53 ${dcprefix}n3-priv.${domain} ${dcprefix}n3-priv
192.168.${lan}.63 ${dcprefix}n3-vip.${domain} ${dcprefix}n3-vip
192.168.${lan}.54 ${dcprefix}n4.${domain} ${dcprefix}n4
172.16.${priv}.54 ${dcprefix}n4-priv.${domain} ${dcprefix}n4-priv
192.168.${lan}.64 ${dcprefix}n4-vip.${domain} ${dcprefix}n4-vip
192.168.${lan}.55 ${dcprefix}n5.${domain} ${dcprefix}n5
172.16.${priv}.55 ${dcprefix}n5-priv.${domain} ${dcprefix}n5-priv
192.168.${lan}.65 ${dcprefix}n5-vip.${domain} ${dcprefix}n5-vip
192.168.${lan}.56 ${dcprefix}n6.${domain} ${dcprefix}n6
172.16.${priv}.56 ${dcprefix}n6-priv.${domain} ${dcprefix}n6-priv
192.168.${lan}.66 ${dcprefix}n6-vip.${domain} ${dcprefix}n6-vip
192.168.${lan}.57 ${dcprefix}n7.${domain} ${dcprefix}n7
172.16.${priv}.57 ${dcprefix}n7-priv.${domain} ${dcprefix}n7-priv
192.168.${lan}.67 ${dcprefix}n7-vip.${domain} ${dcprefix}n7-vip
192.168.${lan}.58 ${dcprefix}n8.${domain} ${dcprefix}n8
172.16.${priv}.58 ${dcprefix}n8-priv.${domain} ${dcprefix}n8-priv
192.168.${lan}.68 ${dcprefix}n8-vip.${domain} ${dcprefix}n8-vip
192.168.${lan}.59 ${dcprefix}n9.${domain} ${dcprefix}n9
172.16.${priv}.59 ${dcprefix}n9-priv.${domain} ${dcprefix}n9-priv
192.168.${lan}.69 ${dcprefix}n9-vip.${domain} ${dcprefix}n9-vip
192.168.${lan}.71 ${dcprefix}l1.${domain} ${dcprefix}l1
172.16.${priv}.71 ${dcprefix}l1-priv.${domain} ${dcprefix}l1-priv
192.168.${lan}.81 ${dcprefix}l1-vip.${domain} ${dcprefix}l1-vip
192.168.${lan}.72 ${dcprefix}l2.${domain} ${dcprefix}l2
172.16.${priv}.72 ${dcprefix}l2-priv.${domain} ${dcprefix}l2-priv
192.168.${lan}.82 ${dcprefix}l2-vip.${domain} ${dcprefix}l2-vip
192.168.${lan}.73 ${dcprefix}l3.${domain} ${dcprefix}l3
172.16.${priv}.73 ${dcprefix}l3-priv.${domain} ${dcprefix}l3-priv
192.168.${lan}.83 ${dcprefix}l3-vip.${domain} ${dcprefix}l3-vip
192.168.${lan}.74 ${dcprefix}l4.${domain} ${dcprefix}l4
172.16.${priv}.74 ${dcprefix}l4-priv.${domain} ${dcprefix}l4-priv
192.168.${lan}.84 ${dcprefix}l4-vip.${domain} ${dcprefix}l4-vip
192.168.${lan}.75 ${dcprefix}l5.${domain} ${dcprefix}l5
172.16.${priv}.75 ${dcprefix}l5-priv.${domain} ${dcprefix}l5-priv
192.168.${lan}.85 ${dcprefix}l5-vip.${domain} ${dcprefix}l5-vip
192.168.${lan}.76 ${dcprefix}l6.${domain} ${dcprefix}l6
172.16.${priv}.76 ${dcprefix}l6-priv.${domain} ${dcprefix}l6-priv
192.168.${lan}.86 ${dcprefix}l6-vip.${domain} ${dcprefix}l6-vip
192.168.${lan}.77 ${dcprefix}l7.${domain} ${dcprefix}l7
172.16.${priv}.77 ${dcprefix}l7-priv.${domain} ${dcprefix}l7-priv
192.168.${lan}.87 ${dcprefix}l7-vip.${domain} ${dcprefix}l7-vip
192.168.${lan}.78 ${dcprefix}l8.${domain} ${dcprefix}l8
172.16.${priv}.78 ${dcprefix}l8-priv.${domain} ${dcprefix}l8-priv
192.168.${lan}.88 ${dcprefix}l8-vip.${domain} ${dcprefix}l8-vip
192.168.${lan}.79 ${dcprefix}l9.${domain} ${dcprefix}l9
172.16.${priv}.79 ${dcprefix}l9-priv.${domain} ${dcprefix}l9-priv
192.168.${lan}.89 ${dcprefix}l9-vip.${domain} ${dcprefix}l9-vip
192.168.${lan}.91 ${dcprefix}a1.${domain} ${dcprefix}a1
192.168.${lan}.92 ${dcprefix}a2.${domain} ${dcprefix}a2
192.168.${lan}.93 ${dcprefix}a3.${domain} ${dcprefix}a3
192.168.${lan}.94 ${dcprefix}a4.${domain} ${dcprefix}a4
192.168.${lan}.95 ${dcprefix}a5.${domain} ${dcprefix}a5
192.168.${lan}.96 ${dcprefix}a6.${domain} ${dcprefix}a6
192.168.${lan}.97 ${dcprefix}a7.${domain} ${dcprefix}a7
192.168.${lan}.98 ${dcprefix}a8.${domain} ${dcprefix}a8
192.168.${lan}.99 ${dcprefix}a9.${domain} ${dcprefix}a9
192.168.${lan}.244 ${dcprefix}-cluster-gns.${domain} ${dcprefix}-cluster-gns
EOF

dci=78
for dc in ${dca}; do
  echo 192.168.${dci}.251 ${dc}${prefix}-scan.${domain} ${dc}${prefix}-scan >> /vagrant/hosts.${domain}
  echo 192.168.${dci}.252 ${dc}${prefix}-scan.${domain} ${dc}${prefix}-scan >> /vagrant/hosts.${domain}
  echo 192.168.${dci}.253 ${dc}${prefix}-scan.${domain} ${dc}${prefix}-scan >> /vagrant/hosts.${domain}
  let dci++
done

chkconfig dnsmasq on
service dnsmasq restart
