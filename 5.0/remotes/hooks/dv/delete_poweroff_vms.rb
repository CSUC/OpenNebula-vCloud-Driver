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
$: << File.dirname(__FILE__)

require 'vcloud_driver'
require 'opennebula'

drv_action_enc 	= ARGV[0]

drv_action 	 	= OpenNebula::XMLElement.new
drv_action.initialize_xml(Base64.decode64(drv_action_enc), 'VM')

deploy_id 		= drv_action["/VM/DEPLOY_ID"]
host  			= drv_action["/VM/HISTORY_RECORDS/HISTORY/HOSTNAME"]
lcm_state_num 	= drv_action["/VM/LCM_STATE"].to_i
lcm_state 		= OpenNebula::VirtualMachine::LCM_STATE[lcm_state_num]

keep_disks 		= nil #NOT IMPLEMENTED YET

begin
    VCloudDriver::VCloudVm.cancel(deploy_id, host, lcm_state, keep_disks)
rescue Exception => e
    STDERR.puts "Cancel of VM #{deploy_id} on host #{host} failed " +
                "due to \"#{e.message}\""
    exit -1
end