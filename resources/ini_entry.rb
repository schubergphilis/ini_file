#
# Cookbook Name:: inifile
#
# Copyright 2016 Schuberg Philis
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'pry'

resource_name 'ini_entry'
default_action :create

begin
  require 'inifile'
rescue LoadError
  chef_gem 'inifile' do
    compile_time true
    action :install
  end
end

property :filename, String, name_property: true
property :stanza, String, required: true
property :entry, String, required: true
property :value, String

load_current_value do
  begin
    cur = IniFile.load(@filename)

    # UGLY HACK ALERT: we need to get stanze and entry from @run_context.resource_collection.find 'ini_entry[/tmp/bla.ini:test:two]', as they are not to be found in the current scope
    my_def = @run_context.resource_collection.find "#{@declared_type}[#{@name}]"

    #binding.pry

    @value = cur[my_def.stanza][my_def.entry]
  rescue NameError
  end
end

action :create do
  converge_if_changed :value do
    ini_write_entry(@new_resource.filename, @new_resource.stanza, @new_resource.entry, @new_resource.value)
  end
end

action :create_if_missing do
  binding.pry
  if not @current_resource.value
    ini_write_entry(@new_resource.filename, @new_resource.stanza, @new_resource.entry, @new_resource.value)
  end
end

action :delete do
  if @current_resource
    ini_delete_entry(@new_resource.filename, @new_resource.stanza, @new_resource.entry)
  end
end
