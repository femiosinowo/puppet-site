require 'spec_helper'


###############################################
#
# Check the ports
#
###############################################

if ENV['CLOSED_PORTS'] != nil
not_listening_ports = ENV['CLOSED_PORTS'].split(",").map { |s| s.to_i }

not_listening_ports.each do |port|
  describe port(port) do
    it { should_not be_listening }
  end
end
end

if ENV['PORTS'] != nil
listening_ports = ENV['PORTS'].split(",").map { |s| s.to_i }

listening_ports.each do |port|
  describe port(port) do
    it { should be_listening }
  end
end
end

###############################################
#
# Check the packages
#
###############################################

if ENV['PACKAGES'] != nil
installed_packages = ENV['PACKAGES'].split(",")

installed_packages.each do |package|
  describe package(package) do
    it { should be_installed }
  end
end
end

############################################
#
# Check files
#
#########################################
if ENV['FILES'] != nil
file_exists = ENV['FILES'].split(",")

file_exists.each do |file|
  describe file(file) do
    it { should be_file }
  end
 end 
end

############################################
#
# Check directories
#
#########################################
if ENV['DIRECTORIES'] != nil
directories_exists = ENV['DIRECTORIES'].split(",")

directories_exists.each do |directory|
  describe file(directory) do
    it { should be_directory}
  end
 end 
end

#######################################
#
# Check running services
#
#######################################
if ENV['SERVICES'] != nil
service_running = ENV['SERVICES'].split(",")

service_running.each do |service|
  describe service(service) do
    it { should be_running }
  end
 end
end

#######################################
#
# Check running processes
#
#######################################
if ENV['PROCESSES'] != nil
process_running = ENV['PROCESSES'].split(",")

process_running.each do |process|
  describe process(process) do
    it { should be_running }
  end
 end
end