# # encoding: utf-8

# Inspec test for recipe inifile::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

testfile1 = '/tmp/test1_ini_file_cookbook.ini'
testfile2 = '/tmp/test2_ini_file_cookbook.ini'


describe file(testfile1) do
  it { should exist }                                          # output file was created
  its('content') { should match /^\[test\]$/ }                 # stanza [test] was created
  its('content') { should match /^world = yes$/ }              # create_if_missing did not overwrite existing entry
  its('content') { should match /^one = 1$/ }                  # create works
  its('content') { should match /^three = 3$/ }	               # create_if_missing added missing entry
  its('content') { should_not match /^delete = me$/ }          # Verify delete action works
  its('content') { should match /^notify = I was notified$/ }  # notifications of ini_entry works
  its('content') { should_not match /^dontnotify = I should not have been notified$/ } # existing numeric entries should not be updated
  its('content') { should match /^semicolons = this;is;a;test$/ } # entries with semi-colons in the value
end


describe file(testfile2) do
  it { should exist }                                          # output file was created
  its('content') { should match /^test2 = test2-value$/ }  # notifications of ini_entry works
end
