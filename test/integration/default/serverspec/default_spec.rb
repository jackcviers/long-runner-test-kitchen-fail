require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "chef-ros::default" do

  it "should have chef-ros-environment installed" do
    expect(command('su example_user; export | grep ROS')).to return_exit_status 0
  end

end
