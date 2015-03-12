# run with:
# sudo chef-apply personal-setup.rb
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

#http://ubuntuhandbook.org/index.php/2014/04/enable-ssh-ubuntu-14-04-trusty-tahr/
package 'openssh-server'


# -----------------------------------------------------------
# Install git
package 'git' do
	options "--install-suggests"
	options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
	action :install
end

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
file '/var/lib/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla' do
	content '[Re-enable hibernate by default in upower]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes

[Re-enable hibernate by default in logind]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate
ResultActive=yes
'
	action :create
	mode '0744'
	group 'root'
	owner 'root'
end
file '/etc/pm/sleep.d/modules' do
	content 'SUSPEND_MODULES="xhci ehci_hcd xhci_hcd xhci-hcd ehci-hcd"
'
	action :create
	mode '0744'
	group 'root'
	owner 'root'
end
file '/etc/pm/sleep.d/20_custom-xhci_hcd' do
	content '#!/bin/sh
# File: "/etc/pm/sleep.d/20_custom-xhci_hcd".
 
#inspired by http://art.ubuntuforums.org/showpost.php?p=9744970&postcount=19
#...and http://thecodecentral.com/2011/01/18/fix-ubuntu-10-10-suspendhibernate-not-working-bug    
# tidied by tqzzaa :)
#also inspiried by http://unix.stackexchange.com/questions/138220/no-usb-3-arch-linux-3-15-1
 
 
VERSION=1.1
DEV_LIST=/tmp/usb-dev-list
DRIVERS_DIR=/sys/bus/pci/drivers
DRIVERS="ehci xhci" # ehci_hcd, xhci_hcd
HEX="[[:xdigit:]]"
MAX_BIND_ATTEMPTS=2
BIND_WAIT=0.1
 
unbindDev() {
  #unbind
  echo "Unbinding xhci device"
  echo -n "0000:04:00.0" > /sys/bus/pci/drivers/xhci_hcd/unbind
  echo -n > $DEV_LIST 2>/dev/null
  for driver in $DRIVERS; do
    DDIR=$DRIVERS_DIR/${driver}_hcd
    for dev in `ls $DDIR 2>/dev/null | egrep "^$HEX+:$HEX+:$HEX"`; do
      echo -n "$dev" > $DDIR/unbind
      echo "$driver $dev" >> $DEV_LIST
    done
  done
}
 
bindDev() {
  # bind
  echo "Binding xhci device"
  ehco -n "0000:04:00.0" > /sys/bus/pci/drivers/xhci_hcd/bind
  if [ -s $DEV_LIST ]; then
    while read driver dev; do
      DDIR=$DRIVERS_DIR/${driver}_hcd
      while [ $((MAX_BIND_ATTEMPTS)) -gt 0 ]; do
          echo -n "$dev" > $DDIR/bind
          if [ ! -L "$DDIR/$dev" ]; then
            sleep $BIND_WAIT
          else
            break
          fi
          MAX_BIND_ATTEMPTS=$((MAX_BIND_ATTEMPTS-1))
      done  
    done < $DEV_LIST
  fi
  rm $DEV_LIST 2>/dev/null
}
 
case "$1" in
  hibernate|suspend) unbindDev;;
  resume|thaw)       bindDev;;
esac
'
	action :create
	mode '0744'
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
	content 'deb http://www.ubnt.com/downloads/unifi/distros/deb/ubuntu ubuntu ubiquiti
'
	action :create
	mode '0644'
	group 'root'
	owner 'root'
end
# set JAVA_HOME variable in /etc/init.d/unifi to "JAVA_HOME=/usr/lib/jvm/java-6-openjdk"
execute "install ubiquiti key" do
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
