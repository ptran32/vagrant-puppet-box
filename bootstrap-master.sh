#!/bin/sh
 
# Run on VM and bootstrap Puppet Master server
 
if ps aux | grep "puppet master" | grep -v grep 2> /dev/null
then
    echo "Puppet Master is already installed. Exiting..."
else
    # Install Puppet Master
    wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb && \
    sudo dpkg -i puppetlabs-release-trusty.deb && \
    sudo apt-get update -yq && apt-get upgrade -yq && \
    sudo apt-get install -yq puppetmaster
 
    # Configure /etc/hosts file
    echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "10.0.1.10    puppetmaster.lab.com  puppetmaster" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "10.0.1.11   puppetagent.lab.com  puppetagent" | sudo tee --append /etc/hosts 2> /dev/null && \
 
    # Add optional alternate DNS names to /etc/puppet/puppet.conf
    sudo sed -i 's/.*\[main\].*/&\ndns_alt_names = puppet,puppetmaster.lab.com/' /etc/puppet/puppet.conf

    # Add basic autosign.conf 
    sudo echo "autosign = true" >> /etc/puppet/puppet.conf
 
    # Install some initial puppet modules on Puppet Master server
    sudo puppet module install puppetlabs-ntp
    sudo puppet module install garethr-docker
    sudo puppet module install puppetlabs-git
    sudo puppet module install puppetlabs-vcsrepo
    sudo puppet module install garystafford-fig
 
    # symlink manifest from Vagrant synced folder location
    ln -s /vagrant/site.pp /etc/puppet/manifests/site.pp
fi