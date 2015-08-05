# The following repositories should be automatically installed:


# -----------------------------------------------------------------------------
# sudar's Arduino-Makefile
# -----------------------------------------------------------------------------
git '#{home}/src/Arduino-Makefile' do
  repository 'git@github.com:sudar/Arduino-Makefile'
  revision 'master'
  action :sync
end


# -----------------------------------------------------------------------------
# ADAFRUIT
# -----------------------------------------------------------------------------
# Adafruit repo's for Arduino
git '#{home}/Arduino/libraries/Adafruit_LED_Backpack_Library' do
  repository 'git@github.com:Adafruit/Adafruit-LED-Backpack-Library'
  revision 'master'
  action :sync
end
git '#{home}/Arduino/libraries/Adafruit_GPS_Library' do
  repository 'git@github.com:Adafruit/Adafruit-GPS-Library'
  revision 'master'
  action :sync
end
git '#{home}/src/Adafruit/Adafruit_Arduino_Boards' do
  repository 'git@github.com:adafruit/Adafruit_Arduino_Boards.git'
  revision 'master'
  action :sync
end
execute 'install adafruit arduino hardware' do
	command 'cp -R #{home}/src/Adafruit/Adafruit_Arduino_Boards/hardware/ #{home}/Arduino/'
end


# -----------------------------------------------------------------------------
# SPARKFUN
# -----------------------------------------------------------------------------
git '#{home}/src/SparkFun_Eagle_Libraries' do
  repository 'git@github.com:sparkfun/SparkFun-Eagle-Libraries.git'
  revision 'master'
  action :sync
end
git '#{home}/src/SparkFun_Eagle_Settings' do
  repository 'git@github.com:sparkfun/SparkFun_Eagle_Settings.git'
  revision 'master'
  action :sync
end


# -----------------------------------------------------------------------------
# MATTAIRTECH
# -----------------------------------------------------------------------------
execute 'download mattairtech arduino support' do
	command 'curl http://www.mattairtech.com/software/arduino/MattairTech_Arduino_1.0.5.1.zip > /tmp/MattairTech_Arduino_1.0.5.1.zip'
end
execute 'extract mattairtech arduino support' do
	command 'unzip /tmp/MattairTech_Arduino_1.0.5.1.zip -d /home/#{huser}/src/MattairTech_Arduino_1.0.5.1/'
end
execute 'install mattairtech arduino support' do
	command 'cp -R #{home}/src/MattairTech_Arduino_1.0.5.1/hardware/ #{home}/Arduino/'
end
execute 'install mattairtech arduino libraries' do
  command 'cp -R #{home}/src/MattairTech_Arduino_1.0.5.1/libraries/ #{home}/Arduino/'
end


# -----------------------------------------------------------------------------
# GREIMAN
# -----------------------------------------------------------------------------
git '#{home}/src/greiman/sdfat' do
	repository 'git@github.com:greiman/SdFat.git'
	revision 'master'
	action :sync
end
execute 'install greiman sdfat' do
	command 'cp -R #{home}/src/greiman/sdfat/SdFat/ #{home}/Arduino/libraries/'
end

git '#{home}/src/greiman/SdFat_20131225' do
  repository 'git@github.com:synapseware/SdFatLib.git'
  revision 'master'
  action :sync
end
execute 'checkout correct sdfatlib tag' do
  command 'git checkout tags/v20131225'
end
execute 'install greiman sdfatlib' do
  command 'cp -R #{home}/src/greiman/SdFat_20131225/ #{home}/Arduino/libraries/'
end


# -----------------------------------------------------------------------------
# SYNAPSEWARE
# -----------------------------------------------------------------------------
%w[ libs avra enterprise ].each do |repo|
  git '#{home}/src/synapseware/#{repo}' do
    repository 'git@github.com:Synapseware/#{repo}.git'
    revision 'master'
    action :sync
  end
end

