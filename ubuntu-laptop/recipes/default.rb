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
#package 'jmtpfs'
package 'mtpfs'
package 'mtp-tools'
package 'exfat-utils'
package 'exfat-fuse'
package 'emacs24'
package 'ack-grep'

#http://ubuntuhandbook.org/index.php/2014/04/enable-ssh-ubuntu-14-04-trusty-tahr/
package 'openssh-server'

execute "install tuxboot key" do
	command 'apt-add-repository -y ppa:thomas.tsai/ubuntu-tuxboot'
end
package 'tuxboot'


# -----------------------------------------------------------
# Install git
package 'git' do
	options "--install-suggests"
	options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
	action :install
end
package 'git-cola'
package 'xclip'


# -----------------------------------------------------------
# Install sublime text
package 'sublime-text' do
	options "--install-suggests"
	options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
	action :install
end

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
package 'handbrake' do
	options "--install-suggests"
	options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
	action :install
end
package 'handbrake-cli' do
	options "--install-suggests"
	options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
	action :install
end
package 'dvdbackup' do
	options "--install-suggests"
	options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
	action :install
end

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
package 'mkvtoolnix' do
	options "--install-suggests -f -y"
	action :install
end
package 'mkvtoolnix-gui' do
	options "--install-suggests -f -y"
	action :install
end


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


# ----------------------------------------------------------
# WINE, YNAB and DropBox
package 'wine' do
	options "--install-suggests"
	action :install
end
package 'wine-mono' do
	options "--install-suggests"
	action :install
end
package 'wine-gecko' do
	options "--install-suggests"
	action :install
end
package 'dropbox' do
	options "--install-suggests"
	action :install
end
execute "download ynab" do
	command "wget -O - https://raw.github.com/WolverineFan/YNABLinuxInstall/master/YNAB4_LinuxInstall.pl > /tmp/ynab4_linuxinstall.pl"
end
file '/tmp/ynab4_linuxinstall.pl' do
	action :create
	mode '0700'
end
#execute "install ynab" do
#	options "3"
#	command "perl /tmp/ynab4_linuxinstall.pl"
#end


# -----------------------------------------------------------
# Hibernation support
directory '/var/lib/polkit-1/localauthority/50-local.d/' do
	mode '0755'
	group 'root'
	owner 'root'
	action :create
end
template '/var/lib/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla' do
	source 'com-ubuntu-enable-hibernate-pkla.erb'
	mode '0755'
	group 'root'
	owner 'root'
end
template '/etc/pm/sleep.d/modules' do
	source './templates/sleep_d_modules.erb'
	mode '0755'
	group 'root'
	owner 'root'
end
template '/etc/pm/sleep.d/20_custom-xhci_hcd' do
	source './templates/custom_xhci.erb'
	mode '0755'
	group 'root'
	owner 'root'
end
# http://chriseiffel.com/everything-linux/step-by-step-how-to-get-hibernate-working-for-linux-ubuntu-11-04-mint-11/#not-resuming-session
# capture swap partition UUID
resumeid = `blkid /dev/sda5 -o value -s UUID`
template '/etc/initramfs-tools/conf.d/resume' do
	source './templates/resume.erb'
	variables(
		resumeid: resumeid
	)
	mode '0755'
	group 'root'
	owner 'root'
end

package 'pm-utils' do
	options "--install-suggests"
	action :install
end
package 'gparted' do
	options "--install-suggests"
	action :install
end


# -----------------------------------------------------------
# Unifi/Ubiquiti
# https://community.ubnt.com/t5/UniFi-Updates-Blog/UniFi-3-2-10-is-released/ba-p/1165532
file '/etc/apt/sources.list.d/ubiquiti.list' do
	content 'deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti
'
	action :create
	mode '0644'
	group 'root'
	owner 'root'
end
# set JAVA_HOME variable in /etc/init.d/unifi to JAVA_HOME=/usr/lib/jvm/java-6-openjdk
execute 'install ubiquiti key' do
	command 'apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50'
end
# probably best to use a template here to modify the ubiquiti scripts...
=begin
execute "apt-get update" do
	command "apt-get update"
end
package 'unifi' do
	options "--install-suggests -f -y"
	action :install
end
=end


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


# -----------------------------------------------------------
# Clone github repo's
# call into the repositories.rb chef script...

