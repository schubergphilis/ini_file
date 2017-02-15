#
# Cookbook Name:: inifile
# Library:: helper
#
# Helper functions to manipulate entries in ini files
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

def ini_write_entry(filename,stanza,entry,value)
  require 'inifile'
  if not ::File.exist? filename
     ::File.open(filename,'w').close
  end
  f = IniFile.load(filename, :comment => '#')
  f[stanza][entry]=value
  f.write
end


def ini_delete_entry(filename,stanza,entry)
  require 'inifile'
  f = IniFile.load(filename, :comment => '#')
  f[stanza].delete(entry)
  f.write
end
