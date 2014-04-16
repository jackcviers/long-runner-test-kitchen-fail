long-runner-test-kitchen-fail
=============================

CB to help diagnosis of test-kitchen/#380


Requirements
------------
Ruby
ruby-gems
vagrant
bundler

Development
-----------

```bash
vagrant plugin install bundler
vagrant plugin install kitchen-vagrant
bundle install --path vendor/bundle
bundle exec berks install
```

Running in test-kitchen to see failure
----------------------

```bash
bundle exec kitchen verify -l debug
```

Running commands from cli to verify recipe should work without timeout
----------------------------------------------------------------------

This installs ros-hydro-desktop-full from the command line. It is a long run, so kick it off and get a cup of coffee *ala* old-school `./configure; make; make install;`

```bash
kitchen create
kitchen login
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu quantal main" > /etc/apt/sources.list.d/ros-latest.list'
wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install -y debconf-utils
echo 'hddtemp hddtemp/daemon boolean false' | sudo debconf-set-selections
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install -y build-essential
sudo apt-get install -y doxygen
sudo apt-get install -y oracle-java7-installer
sudo apt-get install -y python
sudo apt-get install -y python-pycurl
sudo apt-get install -y python-pip
sudo apt-get install -y ros-hydro-desktop-full
sudo apt-get install -y python-rosinstall
sudo rosdep init
sudo rosdep update
echo "source /opt/ros/hydro/setup.bash" >> ~/.bashrc
source ~/.bashrc
export | grep ROS
# should be exit status 0
$? 
```

