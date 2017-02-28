#!/bin/sh
 
# Run on VM to bootstrap Puppet Agent nodes
# http://blog.kloudless.com/2013/07/01/automating-development-environments-with-vagrant-and-puppet/
 
if ps aux | grep "puppet agent" | grep -v grep 2> /dev/null
then
    echo "Puppet Agent is already installed. Moving on..."
else
    sudo apt-get install -yq puppet
fi
 
if cat /etc/crontab | grep puppet 2> /dev/null
then
    echo "Puppet Agent is already configured. Exiting..."
else
    sudo apt-get update -yq && sudo apt-get upgrade -yq
 
    sudo puppet resource cron puppet-agent ensure=present user=root minute=30 \
        command='/usr/bin/puppet agent --onetime --no-daemonize --splay'
 
    sudo puppet resource service puppet ensure=running enable=true
 
    # Configure /etc/hosts file
    echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "# Host config for Puppet Master and Puppet Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "10.0.1.10    puppetmaster.lab.com  puppetmaster" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "10.0.1.20   puppetagent.lab.com  puppetagent" | sudo tee --append /etc/hosts 2> /dev/null && \
 
    # Add agent section to /etc/puppet/puppet.conf
    echo "" && echo "[agent]\nserver=puppetmaster" | sudo tee --append /etc/puppet/puppet.conf 2> /dev/null
 
   # Change startup option for agent
    sudo sed -i 's/no/yes/g' /etc/default/puppet 
 
   # Start service
    sudo puppet agent start
fi
