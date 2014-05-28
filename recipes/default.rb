#
# Cookbook Name:: pacemaker
# Recipe:: default
#
# Copyright (C) 2014 Amalio G
# 
# All rights reserved - Do Not Redistribute
#

# ================  installing necessary package   ======================

include_recipe "apt"
require 'base64'

package "corosync" do
  action :install
end

package "pacemaker" do
  action :install
end

chef_gem "ipaddress" do
  action :install
end

# ===================  creating config file for corosync  =======================
template "/etc/corosync/corosync.conf" do
  source "corosync.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

# ===================  creating file to enable corosync service  =======================
template "/etc/default/corosync" do
  source "corosync.erb"
  owner "root"
  group "root"
  mode "0644"
end

# ===================  creating authkey file  =======================
cookbook_file "cluster_authkey" do
  path "/etc/corosync/authkey"
  owner "root"
  group "root"
  mode "0644"
  action :create_if_missing
end


# ===================  startig corosync service  =======================
service "corosync" do
  supports :restart => true, :status => :true
  action [:enable, :start]
end


