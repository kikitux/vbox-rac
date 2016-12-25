## -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

#############################
#### BEGIN CUSTOMIZATION ####
#############################

prefix = "ora"
domain = "domain"

# array of dc names
#dc = ["prd"]
dc = ["prd","stb","dev"]

# define number of nodes
num_APPLICATION       = 1
num_LEAF_INSTANCES    = 1
num_DB_INSTANCES      = 1

#define number of cores for guest
num_CORE              = 2
 
#define memory for each type of node in MBytes
#
#for leaf nodes, the minimun can be  2300, otherwise pre-check will fail for
#automatic ulimit values calculated based on ram
#
#for database nodes, the minimum suggested is 3072 for standard cluster
#for flex cluster, consider 4500 or more
memory_APPLICATION    = 2500
memory_LEAF_INSTANCES = 3300
memory_DB_INSTANCES   = 5500
         
#size of shared disk in GB
size_shared_disk      = 5

#number of shared disks
count_shared_disk     = 4
 
#############################
##### END CUSTOMIZATION #####
#############################

#if not defined, set defaults
ENV['giver']||="12.1.0.2"
ENV['dbver']||="12.1.0.2"

#this will give us version in format of 12102
giver_i = ENV['giver'].gsub('.','').to_i
dbver_i = ENV['dbver'].gsub('.','').to_i

if dbver_i > giver_i
  puts "dbver found to be higher than giver, this will cause dbca to fail later"
  puts "dbver must be same or lower of giver"
  puts "failing now"
  exit 1
end

# cluster_type 
#define cluster type, standard or flex
if ENV['setup'] == "standard"
  cluster_type = "standard"
else
  cluster_type = "flex"
end

# We need 1 DB HUB, so assume 1 even if configured as 0 
num_DB_INSTANCES = 1 if num_DB_INSTANCES == 0

#note: if num_LEAF_INSTANCES is 1 or more, cluster will be defaulted to flex
cluster_type = "flex" if num_LEAF_INSTANCES > 0

# Force cluster_type to standard if GI Version is 11.2.0.4 or lower
if giver_i < 12101
  cluster_type = "standard"
  num_LEAF_INSTANCES = 0
end

## IMPORTANT
## vagrant works top to bottom.
## We reverse the oder, so higher node goes first
## when db node 1 is ready, we can configure rac as all nodes will be up

## Create hash table of all nodes
## key -> [value[0],value[1],value[2],value[3],value[3]]
## node -> [i,lanip,privip,kind,dc]

## iterate over nodes - begin
## create nodes hash
nodes = {}

## populate inventory for ansible
inventory_ansible = File.open("ansible/inventory","w") if ARGV[0]=="up"
dc.each.with_index do |dc,dci|
  prefixdc="#{dc}#{prefix}"
  inventory_ansible << "[#{prefixdc}-application]\n" if ARGV[0]=="up"
  (1..num_APPLICATION).each do |i|
    i=num_APPLICATION+1-i
    nodes["#{prefixdc}a%01d" % i] = [i,"192.168.#{78+dci}.#{90+i}",nil,"application",dc,dci]
    inventory_ansible << "#{prefixdc}a#{i} ansible_ssh_user=root ansible_ssh_pass=root\n" if ARGV[0]=="up"
  end
  inventory_ansible << "[#{prefixdc}-leaf]\n" if ARGV[0]=="up"
  (1..num_LEAF_INSTANCES).each do |i|
    i=num_LEAF_INSTANCES+1-i
    nodes["#{prefixdc}l%01d" % i] = [i,"192.168.#{78+dci}.#{70+i}","172.16.#{100+dci}.#{i+70}","leaf",dc,dci]
    inventory_ansible << "#{prefixdc}l#{i} ansible_ssh_user=root ansible_ssh_pass=root\n" if ARGV[0]=="up"
  end
  inventory_ansible << "[#{prefixdc}-hub]\n" if ARGV[0]=="up"
  (1..num_DB_INSTANCES).each do |i|
    i=num_DB_INSTANCES+1-i
    nodes["#{prefixdc}n%01d" % i] = [i,"192.168.#{78+dci}.#{50+i}","172.16.#{100+dci}.#{i+50}","hub",dc,dci]
    inventory_ansible << "#{prefixdc}n#{i} ansible_ssh_user=root ansible_ssh_pass=root\n" if ARGV[0]=="up"
  end
  if ARGV[0]=="up"
    inventory_ansible << "[#{prefixdc}:children]\n"
    inventory_ansible << "#{prefixdc}-leaf\n" if num_LEAF_INSTANCES > 0
    inventory_ansible << "#{prefixdc}-hub\n"  if num_DB_INSTANCES > 0
    inventory_ansible << "[#{prefixdc}-all:children]\n"
    inventory_ansible << "#{prefixdc}-application\n"  if num_APPLICATION > 0
    inventory_ansible << "#{prefixdc}-leaf\n" if num_LEAF_INSTANCES > 0
    inventory_ansible << "#{prefixdc}-hub\n"  if num_DB_INSTANCES > 0
  end
end
inventory_ansible.close if ARGV[0]=="up"
## iterate over nodes - end

#variable used to provide information only once
give_info ||=true

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.ssh.insert_key = false
  config.vm.box = "kikitux/oracle6-racattack"

  if File.directory?("scripts")
    # our shared folder for scripts
    config.vm.synced_folder "scripts", "/media/scripts", :mount_options => ["dmode=555","fmode=444","gid=54321"]
  end

  if File.directory?("otn")
    # our shared folder for oracle 12c installation files
    config.vm.synced_folder "otn", "/media/otn", :mount_options => ["dmode=777","fmode=777","uid=54320","gid=54321"]
  end

  # Lets iterate over the nodes
  nodes.each do |vm_name,array|

    # add type 
    i      = array[0]
    lanip  = array[1]
    privip = array[2] unless array[2].nil?
    kind   = array[3]
    dc     = array[4]
    dci    = array[5]

    prefixdc="#{dc}#{prefix}"

$etc_hosts_script = <<SCRIPT
#!/bin/bash
grep PEERDNS /etc/sysconfig/network-scripts/ifcfg-eth0 || echo 'PEERDNS=no' >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "overwriting /etc/resolv.conf"
cat > /etc/resolv.conf <<EOF
nameserver 192.168.#{78+dci}.51
nameserver 192.168.#{78+dci}.52
nameserver 10.0.2.3
search #{domain} #{prefixdc}n.#{domain}
EOF

cat > /etc/hosts << EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost6 localhost6.localdomain6
EOF
SCRIPT

    config.vm.define vm_name = vm_name do |config|
      puts vm_name + " eth1 lanip : " + lanip if ARGV[0] == "status"

      #clean all
      if ENV['setup'] == "clean"
        config.vm.provision :shell, :path => "scripts/clean.sh", :args => "YES"
      else
        #run some scripts
        config.vm.provision :shell, :inline => $etc_hosts_script
      end

      config.vm.hostname = "#{vm_name}.#{domain}"
      config.vm.network :private_network, ip: lanip
      config.vm.network :private_network, ip: privip unless privip.nil?
      config.vm.provider :virtualbox do |vb|
        vb.name = vm_name + "." + Time.now.strftime("%y%m%d%H%M")
        vb.customize ["modifyvm", :id, "--paravirtprovider", "kvm" ]
        vb.customize ["modifyvm", :id, "--memory", memory_APPLICATION]    if vm_name.start_with?("#{prefix}a")
        vb.customize ["modifyvm", :id, "--memory", memory_LEAF_INSTANCES] if vm_name.start_with?("#{prefix}l")
        vb.customize ["modifyvm", :id, "--memory", memory_DB_INSTANCES]   if vm_name.start_with?("#{prefix}n")
        vb.customize ["modifyvm", :id, "--cpus", num_CORE]
        vb.customize ["modifyvm", :id, "--groups", "/#{prefix}"]

        if vm_name.start_with?("#{prefix}n")
          #first shared disk port
          port=2
          #iterate over shared disk
          (1..count_shared_disk).each do |disk|
            file_to_dbdisk = "#{prefix}-#{dc}-shared-disk"
            if !File.exist?("#{file_to_dbdisk}#{disk}.vdi") and num_DB_INSTANCES==i
              unless give_info==false
                puts "on first boot shared disks will be created, this will take some time"
                give_info=false
              end
              vb.customize ['createhd', '--filename', "#{file_to_dbdisk}#{disk}.vdi", '--size', (size_shared_disk * 1024).floor, '--variant', 'fixed']
              vb.customize ['modifyhd', "#{file_to_dbdisk}#{disk}.vdi", '--type', 'shareable']
            end
            vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', port, '--device', 0, '--type', 'hdd', '--medium', "#{file_to_dbdisk}#{disk}.vdi"]
            port=port+1
          end
        end
      end
      if vm_name == "#{prefix}n1" 
        puts vm_name + " dns server role is master"
        config.vm.provision :shell, :inline => "echo sh /media/stagefiles/named_master.sh"
        if ENV['setup']
          config.vm.provision :shell, :inline => "echo bash /media/stagefiles/run_ansible_playbook.sh #{cluster_type} #{ENV['giver']} #{ENV['dbver']}" 
        end
      end
    end
  end

#      if not ENV['setup'] == "clean"
#        if vm_name == "#{prefix}n2" 
#          puts vm_name + " dns server role is slave"
#          config.vm.provision :shell, :inline => "echo sh /media/stagefiles/named_slave.sh"
#        end
#        end
#      end

end