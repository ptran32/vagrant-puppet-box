# puppet-box

#OS and Virtualization:

Ubuntu 16.04 & Virtualbox

#What this box do ?

This box creates two VM's on virtualbox:

- puppetmaster
- puppetagent

The puppetmaster is configured to auto sign certificates from agents

#Requirements:

Vagrant installed

#How to use this box?

You can connect to each VM with the following command:

vagrant ssh puppetmaster.lab.com
vagrant ssh puppetagent.lab.com

A manifest (site.pp) is sync from the local directory to the puppetmaster.

You can play with it for your first manifest ;)

