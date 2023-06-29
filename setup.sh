#!/bin/sh

# initial setup script
# for repeatability and consistency

username=mdt

apt update && apt install -y \
	git neovim docker.io docker-compose

# set up neovim
git clone https://github.com/mdvthu/vim-conf.git
cd vim-conf && sh install.sh
cd && rm -rf vim-conf
apt purge -y vim

# new user
id -u ${username} || adduser ${username}
# docker requirements
adduser ${username} docker

# improve ssh security
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
systemctl restart sshd

# copy ssh keys for the new user
test -d /home/${username}/.ssh || cp -r ~/.ssh/ /home/${username}/
chown -R ${username} /home/${username}/.ssh

# install cvat
test -d /home/${username}/cvat || \
	sudo -u ${username} sh -c 'cd; git clone https://github.com/opencv/cvat.git'
