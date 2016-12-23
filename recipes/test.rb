#
# Cookbook Name:: inifile
# Recipe:: default
#
# Copyright 2016 The Authors
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

chef_gem 'inifile' do
  compile_time true
  action :install
end

testfile='/tmp/test_ini_file_cookbook.ini'

file testfile do
  content <<EOF
[hello]
world = yes
delete = me
EOF
end

actions = [
  { action: :create, stanza: 'test', entry: 'one', value: '1' },
  { action: :create, stanza: 'test', entry: 'two', value: '2' },
  { action: :create_if_missing, stanza: 'hello', entry: 'world', value: 'nononono' },  # test that the previous one do not get overwritten
  { action: :create_if_missing, stanza: 'test', entry: 'three', value: '3' }

]

actions.each { |e|

  ini_entry "#{testfile}:#{e[:stanza]}:#{e[:entry]}" do
    action   e[:action]
    filename testfile
    stanza   e[:stanza]
    entry    e[:entry]
    value    e[:value]
  end

}
    
ini_entry 'delete-me' do
  action   :delete
  filename testfile
  stanza   'hello'
  entry    'delete' 
  notifies :create, 'ini_entry[notify-me]'
end

ini_entry 'notify-me' do
  action   :nothing
  filename testfile
  stanza   'hello'
  entry    'notify'
  value    'I was notified'
end
  
