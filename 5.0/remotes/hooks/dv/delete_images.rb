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

image_id		= ARGV[0]
drv_action_enc 	= ARGV[-1]

drv_action =OpenNebula::XMLElement.new

drv_action.initialize_xml(Base64.decode64(drv_action_enc), 'IMAGE')

ds_name       = drv_action["/IMAGE/DATASTORE"]
ds_id         = drv_action["/IMAGE/DATASTORE_ID"]
img_name      = drv_action["/IMAGE/NAME"]

ds_one        = OpenNebula::Datastore.new_with_id(ds_id,::OpenNebula::Client.new())
ds_one.info

hostname 	  = ds_one.retrieve_elements("TEMPLATE/VCLOUD_HOST").first
ds_mad 		  = ds_one.retrieve_elements("TEMPLATE/DS_MAD").first

if ds_mad == "vcloud"

	begin
    	host_id      = VCloudDriver::VCDConnection::translate_hostname(hostname.to_s)
    	connection   = VCloudDriver::VCDConnection.new host_id

    	connection.delete_virtual_disk(img_name,
                                  ds_name)
	rescue Exception => e
    	STDERR.puts "Error delete virtual disk #{img_name} in #{ds_name}."\
                " Reason: #{e.message}"
    	exit -1
	end
end
