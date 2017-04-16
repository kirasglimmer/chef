#
# install chef with
#   wget -q -O - https://www.chef.io/chef/install.sh | sudo bash
#
# download this file:
#   wget https://raw.githubusercontent.com/dachew/chef/master/ubuntu-laptop/setup.rb -O setup.rb
#
# run with:
#   sudo chef-apply personal-setup.rb
# -----------------------------------------------------------
#user_home = "/#{node[:matching_node][:user]}"
user = 'matthew'
home = '/home/#{user}'

# -----------------------------------------------------------
# Ensure everything is updated
=begin
execute "apt-get update" do
	command "apt-get update"
end
execute "apt-get upgrade" do
	command "apt-get upgrade -y"
end
=end


# -----------------------------------------------------------
# Install system tools
package 'gparted'
package 'tree'
package 'cu'
package 'minicom'
package 'mtpfs'
package 'mtp-tools'
package 'exfat-utils'
package 'exfat-fuse'
package 'ack-grep'
package 'nfs-common'
package 'autofs'

#http://ubuntuhandbook.org/index.php/2014/04/enable-ssh-ubuntu-14-04-trusty-tahr/
package 'openssh-server'

execute "install tuxboot key" do
	command 'apt-add-repository -y ppa:thomas.tsai/ubuntu-tuxboot'
end
package 'tuxboot'


# -----------------------------------------------------------
# Install git
package 'git'
package 'git-cola'
package 'xclip'


# -----------------------------------------------------------
# Install sublime text
execute "install sublime text 3" do
	command "add-apt-repository ppa:webupd8team/sublime-text-3"
	command "apt update"
end
package "sublime-text"


# -----------------------------------------------------------
# Install digiKam
package 'sqlite' do
	options "--install-suggests"
	options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
	action :install
end
package 'sqlite3' do
	options "--install-suggests"
	options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
	action :install
end
package 'digikam' do
	options "--install-suggests"
	options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
	action :install
end


# -----------------------------------------------------------
# Install KRDC for remote desktop access
package 'krdc' do
	options "--install-suggests"
	options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
	action :install
end


# -----------------------------------------------------------
# Install media tools for dvd cloning
# from /etc/apt/souces.list.d/mkvtools.list
execute "install handbrake and handbrake ppa" do
	command "add-apt-repository ppa:stebbins/handbrake-releases"
	command "apt update"
end
package "handbrake-gtk"
package "handbrake-cli"
package "dvdbackup"

# MKVTools
# https://www.bunkus.org/videotools/mkvtoolnix/downloads.html
file '/etc/apt/sources.list.d/mkvtools.list' do
	content 'deb http://www.bunkus.org/ubuntu/trusty/ ./
deb-src http://www.bunkus.org/ubuntu/trusty/ ./
'
	action :create
	mode '0755'
	group 'root'
	owner 'root'
end
execute "install bunkus key" do
	command 'wget -q -O - https://www.bunkus.org/gpg-pub-moritzbunkus.txt | apt-key add -'
end
package 'mkvtoolnix'
package 'mkvtoolnix-gui'


# -----------------------------------------------------------
# libav-tools
package 'libav-tools'


# -----------------------------------------------------------
# Spotify
file '/etc/apt/sources.list.d/spotify.list' do
	content 'deb http://repository.spotify.com stable non-free'
	action :create
	mode '0755'
	group 'root'
	owner 'root'
end
execute "install spotify key" do
	command 'apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886'
end
package 'spotify-client' do
	options "--force-yes"
	options "-y"
	action :install
end
package 'audacity'


# ----------------------------------------------------------
# Other media tools
package 'cheese'
package 'imagemagick'
package 'exiv2'


# -----------------------------------------------------------
# Electronics!
#execute "install eagle" do
#	command "wget -O - http://web.cadsoft.de/ftp/eagle/program/7.2/eagle-lin-7.2.0.run | sh"
#end
package 'gcc-avr'
package 'binutils-avr'
package 'gdb-avr'
package 'avr-libc'
package 'avrdude'
package 'avra'
package 'arduino-mk'
package 'g++'
package 'gcc'
package 'automake'
package 'ddd'
package 'arduino'
package 'arduino-core'
execute 'remove modem manager' do
	command 'apt purge modemmanager'
end
file '/etc/udev/rules.d/77-arduino.rules' do
	content "ATTRS{idVendor}==2a03, ENV{ID_MM_DEVICE_IGNORE}=1"
	action :create
	mode '0755'
	group 'root'
	owner 'root'
end
file '/etc/udev/rules.d/99-saleae.rules' do
	content '# Saleae Logic Analyzer \
	# This file should be installed to /etc/udev/rules.d so that you can access the Logic hardware without being root \
	# # \
	# # type this at the command prompt: sudo cp 99-SaleaeLogic.rules /etc/udev/rules.d \
	\
	SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="0925", ATTR{idProduct}=="3881", MODE="0666" \
	SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1001", MODE="0666" \
	SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1003", MODE="0666" \
	SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1004", MODE="0666" \
	SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1005", MODE="0666" \
	SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1006", MODE="0666"'

	action :create
	mode '0755'
	group 'root'
	owner 'root'
end


# -----------------------------------------------------------
# Install mono-develop
execute "install mono-develop key" do
	command "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
end
file '/etc/apt/sources.list.d/mono-xamarin.list' do
	content 'deb http://download.mono-project.com/repo/debian wheezy main
'
	action :create
	mode '0644'
	group 'root'
	owner 'root'
end
package 'mono-complete'
#http://typecastexception.com/post/2014/10/19/Setting-Up-for-Mono-Development-in-Linux-MintUbuntu.aspx#Making-Nuget-Package-Restore-Work-in-MonoDevelop
execute "install ssl certificates" do
	command "mozroots --import --sync"
end
#http://askubuntu.com/questions/481002/how-to-install-nuget-addin-for-monodevelop

