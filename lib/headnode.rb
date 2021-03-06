#!/usr/bin/env ruby
## Copyright 2012, Debarshi Basak D.Basak@student.tudelft.nl
##
##   Licensed under the Apache License, Version 2.0 (the "License");
##   you may not use this file except in compliance with the License.
##   You may obtain a copy of the License at
##
##       http://www.apache.org/licenses/LICENSE-2.0
##
##   Unless required by applicable law or agreed to in writing, software
##   distributed under the License is distributed on an "AS IS" BASIS,
##   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##   See the License for the specific language governing permissions and
##   limitations under the License.
##
 ONE_LOCATION=ENV["ONE_LOCATION"]
  
  if !ONE_LOCATION
      RUBY_LIB_LOCATION="/usr/lib/one/ruby"
      else
          RUBY_LIB_LOCATION=ONE_LOCATION+"/lib/ruby"
  end
           
           $: << RUBY_LIB_LOCATION
            require 'OpenNebula'
            require 'nokogiri'

             include OpenNebula

             
$path = ENV['PROJECT_CLOUD']
$credentials
$endpoint
File.open($path+'/conf/cloud_env', 'r') do |f1|
  while line = f1.gets
        if(line.split("=").first == "CLOUD_PASS")
        then
$credentials = line.split("=").last.split("\n").to_s
        end
if(line.split("=").first == "END_POINT")
        then
$endpoint = line.split("=").last.split("\n").to_s
        end

end
end
       # OpenNebula credentials
            CREDENTIALS = $credentials
    # XML_RPC endpoint where OpenNebula is listening
            ENDPOINT    = $endpoint

     LOAD_TEMP_PATH = $path+"/lib"
     $: << LOAD_TEMP_PATH

       client = Client.new(CREDENTIALS, ENDPOINT)                
       vm_pool = VirtualMachinePool.new(client, -1)
                 
                rc = vm_pool.info
                if OpenNebula.is_error?(rc)
                     puts rc.message
                     exit -1
                end
                           
                  vm_pool.each do |vm|
                    if vm.id == ARGV[0].to_i
                    if OpenNebula.is_error?(rc)
                    puts "Virtual Machine #{vm}"
                    else
                       doc = Nokogiri.XML(vm.template_xml)
                       doc.xpath('TEMPLATE/NIC/IP').each { |node| puts node.to_str }
                    end
               end
                                                  
end                  
