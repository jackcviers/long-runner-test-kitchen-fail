require_relative 'spec_helper'

describe 'long-runner-test-kitchen-fail::default' do

  before do
    stub_command("debconf-get-selections").and_return("hddtemp hddtemp/daemon boolean true")
    stub_command("debconf-set-selections").and_return(true)
  end

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
    end.converge(described_recipe)
  end

  it 'should include_recipe[apt::default] recipe' do
    expect(chef_run).to include_recipe 'apt::default'
  end
  
  it 'should add_apt_repository[ros] and notify["execute[apt-get update] to run immediately"]' do
    expect(chef_run.find_resource("apt_repository", "ros")).to_not be_nil
    expect(chef_run).to add_apt_repository("ros").with(
                                                       :uri => "http://packages.ros.org/ros/ubuntu",
                                                       :distribution => chef_run.node.ros.ubuntu.release,
                                                       :components => ["main"],
                                                       :key => "http://packages.ros.org/ros.key"
                                                       )
    expect(chef_run.find_resource("apt_repository", "ros")).to notify("execute[apt-get update]").immediately
  end
  
  it 'should install_package[debconf-utils]' do
    expect(chef_run).to install_package 'debconf-utils'
  end
  
  it "should run_execute[echo 'hddtemp hddtemp/daemon boolean false' | debconf-set-selections]" do
    expect(chef_run).to run_execute("echo 'hddtemp hddtemp/daemon boolean false' | debconf-set-selections")
  end
  
  it 'should include_recipe[build-essential::default]' do
    expect(chef_run).to include_recipe 'build-essential::default'
  end
  
  it 'should include_recipe[python::package]' do
    expect(chef_run).to include_recipe 'python::package'
  end
  
  it 'should include_recipe[java::default]' do
    expect(chef_run).to include_recipe 'java::default'
  end
  
  it 'should install_package[python-pycurl]' do
    expect(chef_run).to install_package 'python-pycurl'
  end
  
  it 'should install_package[python-pip]' do
    expect(chef_run).to install_package 'python-pip'
  end
  
  it 'should install_package[ros-hydro-desktop-full]' do
    expect(chef_run).to install_package 'ros-hydro-desktop-full'
  end
  
  it 'should create_group[ros-users] with system: true, append: true' do
    expect(chef_run).to create_group('ros-users').with :system => true, :append => true
  end
  
  it 'should create_user[example_user] with system: true, supports: {manage_home: true}, shell: "/bin/bash", home: "/home/example_user/"' do
    expect(chef_run).to create_user('example_user').with :system => true, "supports" => {"manage_home" => true}, :shell => "/bin/bash", :home => "/home/example_user"
  end
  
  it 'should run_execute[rosdep init]' do
    expect(chef_run).to run_execute 'rosdep init'
  end
  
  it 'should run_execute[rosdep update]' do
    expect(chef_run).to run_execute 'rosdep update'
  end
  
  it 'should export chef env by render_file[/home/example_user/.bashrc] with contents ../templates/default/.bashrc.erb' do
    data = open("templates/default/.bashrc.erb") do |file|
      file.read
    end

    expect(chef_run).to render_file('/home/example_user/.bashrc').with_content data
  end
  
  it 'should run_execute[source /home/example_user/.bashrc]' do
    expect(chef_run).to run_execute 'source /home/example_user/.bashrc'
  end
  
  it 'should install_package[python-rosinstall]' do
    expect(chef_run).to install_package 'python-rosinstall'
  end
end
