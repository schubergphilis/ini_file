# Inifile Cookbook

This cookcook manages individual entries in INI style configuration files,
such as described here: https://en.wikipedia.org/wiki/INI_file

The primary (initial) use case which triggered the creation of this cookbook
is to allow use to more precisely manipulate entries within Splunk configuration
files. Templates have been used for this in the past, but that is know to cause
conflicts when both Chef as well as Splunk want to write to these files.

This cookbook was inspired on xml_edit, which provides similar functionality
for managing nodes in XML files.


## Requirements

RubyGem: inifile (is installed via the ini__file::default recipe)

Chef version 12.5 or higher (required due to the use of new style custom resources)

## Attributes
This cookbook defines not attributes, it solely provides a resource to manipulate
entries in INI files

## Recipes

### default.rb

When using the ini_entry provided by this cookbook, you need to ensure this recipe
in include on your node's run_list. The default.rb recipe installs the inifile rubygem
at compile time.

### test.rb

This recipe's purpose is 2-fold. It primary exists as a recipe to run from test
kitchen to run a set of actions against a sample INI file. After this recipe has been run
it's output is verified using InSpec.

The second use of this recipe is to service as a example on how to use the ini_entry chef
resource.

## Resources

### ini_entry

This cookbook provides a single resource called 'ini_entry'. This resource is defined as:
   resource_name 'ini_entry'
   default_action :create
   
   property :filename, String, name_property: true
   property :stanza, String, required: true
   property :entry, String, required: true
   property :value, String

It supports the following actions:
   :nothing		Do nothing, unless another action is notified by another resource
   :create		Set <entry> in [<stanza>] section to <value> in INI file <filename>
   :create_if_missing   Set <entry> in [<stanza>] section to <value> only if the <entry> currently does not exist
   :delete		Remove [<stanza>] <entry> from the INI file <filename>

You can use the ini_entry resource in your own recipes like:
  ini_entry 'create-me' do
    action   :create
    filename 'test.ini'
    stanza   'test'
    entry    'hello'
    value    'world
  end


## Usage

To use this cookbook:
- make sure it is uploaded in to your chef server
- declare a dependency on this cookbook in one of your own cookbooks
- include_recipe 'ini_file::default' in your runlist to install the inifile rubygem
- add the required ini_entry resources in your own recipes to manage ini_file entries

# LICENSE and AUTHOR:

Author:: Gert Kremer <gkremer@schubergphilis.com>

Copyright:: 2016, Schuberg Philis BV

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
