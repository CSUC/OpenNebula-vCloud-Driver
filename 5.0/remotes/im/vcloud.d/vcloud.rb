#!/usr/bin/env ruby

# ---------------------------------------------------------------------------- #
# Licensed under the Apache License, Version 2.0 (the "License"); you may      #
# not use this file except in compliance with the License. You may obtain      #
# a copy of the License at                                                     #
#                                                                              #
# http://www.apache.org/licenses/LICENSE-2.0                                   #
#                                                                              #
# Unless required by applicable law or agreed to in writing, software          #
# distributed under the License is distributed on an "AS IS" BASIS,            #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.     #
# See the License for the specific language governing permissions and          #
# limitations under the License.                                               #
# ---------------------------------------------------------------------------- #

ONE_LOCATION=ENV["ONE_LOCATION"] if !defined?(ONE_LOCATION)

if !ONE_LOCATION
    RUBY_LIB_LOCATION="/usr/lib/one/ruby" if !defined?(RUBY_LIB_LOCATION)
else
    RUBY_LIB_LOCATION=ONE_LOCATION+"/lib/ruby" if !defined?(RUBY_LIB_LOCATION)
end

$: << RUBY_LIB_LOCATION

require 'vcloud_driver'

host_id = ARGV[4]

if !host_id
    exit -1
end

vcd_connection = VCloudDriver::VCDConnection.new host_id

vcloud_host    = VCloudDriver::VCloudHost.new vcd_connection

cluster_info   = vcloud_host.monitor_cluster

vm_monitor_info = vcloud_host.monitor_vms
cluster_info << "\nVM_POLL=YES"
cluster_info << "#{vm_monitor_info}" if !vm_monitor_info.empty?
cluster_info << "\n"

puts cluster_info