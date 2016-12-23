# # encoding: utf-8

# Inspec test for recipe inifile::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

testfile = '/tmp/test_ini_file_cookbook.ini'

describe file(testfile) do
  it { should exist }                                          # output file was created
  its('content') { should match /^\[test\]$/ }                 # stanza [test] was created
  its('content') { should match /^world = yes$/ }              # create_if_missing did not overwrite existing entry
  its('content') { should match /^one = 1$/ }                  # create works
  its('content') { should match /^three = 3$/ }	               # create_if_missing added missing entry
  its('content') { should_not match /^delete = me$/ }          # Verify delete action works
  its('content') { should match /^notify = I was notified$/ }  # notifications of ini_entry works
end
