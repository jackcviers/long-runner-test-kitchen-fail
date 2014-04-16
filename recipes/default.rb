include_recipe 'apt::default'

apt_repository "ros" do
  uri "http://packages.ros.org/ros/ubuntu"
  distribution node[:ros][:ubuntu][:release]
  components ["main"]
  key "http://packages.ros.org/ros.key"
  action :add
  notifies :run, "execute[apt-get update]", :immediately
end

# workaround for interactive prompt while installing hddtemp in ros-hydro-desktop-full
package 'debconf-utils'

execute "echo 'hddtemp hddtemp/daemon boolean false' | debconf-set-selections" do
  action :run
  not_if do system "debconf-get-selections | grep 'hddtemp hddtemp/daemon boolean false'" end
end

# this also is in ros-hydro-desktop-full, but a known chef recipe is better than a failed apt package...
include_recipe 'build-essential::default'

# also ins ros-hydro-desktop-full, but a known chef recipe is better than a failed apt...
include_recipe 'python::package'

# workaround install to avoid interactive prompt in ros-hydro-desktop-full java installation for EULA Acceptance
include_recipe 'java::default'

# needed for python pip
package 'python-pycurl'

# ros runs on python, and this is much better than easy-install...
package 'python-pip'

# Install ros and configure vm for use. from here on is where the recipe will fail because of long-running apt-get install process
package 'ros-hydro-desktop-full'

group 'ros-users' do
  system true
  append true
  action :create
end

user node['ros']['ubuntu']['user'] do
  system true
  supports "manage_home" => true
  shell '/bin/bash'
  home "/home/#{node['ros']['ubuntu']['user']}"
  action :create
end

execute 'rosdep init'

execute 'rosdep update'

template "/home/#{node['ros']['ubuntu']['user']}/.bashrc" do
  source ".bashrc.erb"
  owner node['ros']['ubuntu']['user']
  group node['ros']['ubuntu']['user']
end

execute 'source /home/example_user/.bashrc'

package 'python-rosinstall'



