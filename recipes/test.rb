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

testfile1='/tmp/test1_ini_file_cookbook.ini'
testfile2='/tmp/test2_ini_file_cookbook.ini'

file testfile1 do
  content <<EOF
[hello]
world = yes
delete = me
number = 1
semicolons2 = existing;semi;colon;separated
EOF
end

actions = [
  { action: :create, stanza: 'test', entry: 'one', value: '1' },
  { action: :create, stanza: 'test', entry: 'two', value: '2' },
  { action: :create_if_missing, stanza: 'hello', entry: 'world', value: 'nononono' },  # test that the previous one do not get overwritten
  { action: :create_if_missing, stanza: 'test', entry: 'three', value: '3' }

]

actions.each { |e|

  ini_entry "#{testfile1}:#{e[:stanza]}:#{e[:entry]}" do
    action   e[:action]
    filename testfile1
    stanza   e[:stanza]
    entry    e[:entry]
    value    e[:value]
  end

}
    
ini_entry 'delete-me' do
  action   :delete
  filename testfile1
  stanza   'hello'
  entry    'delete' 
  notifies :create, 'ini_entry[notify-me]'
end

ini_entry 'notify-me' do
  action   :nothing
  filename testfile1
  stanza   'hello'
  entry    'notify'
  value    'I was notified'
end

ini_entry 'semicolons1' do
  action   :create
  filename testfile1
  stanza   'hello'
  entry    'semicolons1'
  value    'this;is;a;test'
end

ini_entry 'semicolons2' do
  action   :create
  filename testfile1
  stanza   'hello'
  entry    'semicolons2'
  value    'existing;semi;colon;separated'
  notifies :create, 'ini_entry[notify-semicolons2]'
end

ini_entry 'notify-semicolons2' do
  action   :nothing
  filename testfile1
  stanza   'hello'
  entry    'semicolons2failed'
  value    'true'
end

ini_entry 'update-number' do
  action   :create
  filename testfile1
  stanza   'hello'
  entry    'number'
  value    '1'
  notifies :create, 'ini_entry[dont-notify-me]'
end

ini_entry 'dont-notify-me' do
  action   :nothing
  filename testfile1
  stanza   'hello'
  entry    'dontnotify'
  value    'I should not have been notified'
end

# Test to create an entry an a file which doesn't exist yet 
file testfile2 do
  action   :delete
end

ini_entry 'create-in-non-existing-file' do
  filename testfile2
  action   :create
  stanza   'test'
  entry    'test2'
  value    'test2-value'
end 
