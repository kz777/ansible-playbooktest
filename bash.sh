#!/bin/bash
## Install Ansible
ANSIBLE_USER_PASSWD=*DevOpsAsCode@YouTube*
ANSIBLE_USER=ubuntu
SERVER=100.25.17.86

apt update -y
apt install ansible -y
echo -e "[webservers] \n$SERVER ansible_user=ubuntu\n" >> /etc/ansible/hosts


## Install Jenkins

# Install Java.
apt install openjdk-8-jdk -y

# Add the Jenkins Debian repository.
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Install Jenkins.
sudo apt update -y
sudo apt install jenkins -y

## Use the following command to print the password on your terminal:
## sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Automated ssh-keygen without passphrase stored in Jenkins user's home dir.
mkdir /var/lib/jenkins/.ssh

ssh-keygen -b 2048 -t rsa -f /var/lib/jenkins/.ssh/id_rsa -q -N ""
chown -R jenkins:jenkins /var/lib/jenkins/.ssh/


# Copy ssh key to the target host
apt install sshpass -y

sshpass -p "$ANSIBLE_USER_PASSWD" ssh-copy-id -o "StrictHostKeyChecking no" -i /var/lib/jenkins/.ssh/id_rsa.pub $ANSIBLE_USER@$SERVER

apt remove sshpass -y




### TARGET HOST
#!/bin/bash

# Set env vars
ANSIBLE_USER_PASSWD=*DevOpsAsCode@YouTube*
ANSIBLE_USER=ubuntu

# Install python
apt update -y
sudo apt install python -y

# Set password for ubuntu user
echo "$ANSIBLE_USER:$ANSIBLE_USER_PASSWD" | /usr/sbin/chpasswd

# Enable PasswordAuthentication
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo service sshd restart




