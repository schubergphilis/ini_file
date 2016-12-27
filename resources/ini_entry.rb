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

resource_name 'ini_entry'
default_action :create

property :filename, String, name_property: true
property :stanza,   String, required: true, desired_state: false
property :entry,    String, required: true, desired_state: false
property :value,    String, desired_state: false

load_current_value do
  begin
    require 'inifile'
    cur = IniFile.load(@filename)
    @value = cur[@stanza][@entry]
  rescue NameError
  end
end

action :create do
  converge_if_changed :value do
    ini_write_entry(@new_resource.filename, @new_resource.stanza, @new_resource.entry, @new_resource.value)
    @new_resource.updated = true
  end
end

action :create_if_missing do
  if not @current_resource.value
    ini_write_entry(@new_resource.filename, @new_resource.stanza, @new_resource.entry, @new_resource.value)
    @new_resource.updated = true
  end
end

action :delete do
  if @current_resource.value
    ini_delete_entry(@new_resource.filename, @new_resource.stanza, @new_resource.entry)
    @new_resource.updated = true
  end
end
