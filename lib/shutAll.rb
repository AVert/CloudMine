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
            require 'ACL'
            require 'initVM'
             
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

gateKeeper = ACL.new()
check = gateKeeper.check(ARGV[0],ARGV[1])
if check == 1
then
 client = Client.new(CREDENTIALS, ENDPOINT)                
       vm_pool = VirtualMachinePool.new(client, -1)
                 
                rc = vm_pool.info
                if OpenNebula.is_error?(rc)
                     puts rc.message
                     exit -1
                end
                           
                  vm_pool.each do |vm|
                     rc = vm.shutdown
                     if OpenNebula.is_error?(rc)
                        puts "Virtual Machine #{vm.id}: #{rc.message}"
                      else
                        puts "Virtual Machine #{vm.id}: Shutting down"
                     end
                  end
                                                                    
else
puts "Credentials please..."
end       
exit 0
