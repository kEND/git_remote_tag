require 'rubygems'

require 'rake'

HERE = File.dirname(__FILE__)
windows = (RUBY_PLATFORM =~ /win32|cygwin/) rescue nil
SUDO = windows ? "" : "sudo"

#So we can use GitRemoteBranch::NAME, VERSION and so on.
require "#{HERE}/lib/git_remote_branch"

Dir['tasks/**/*.rake'].each { |rake| load rake }

desc 'Default: run all tests.'
task :default => :test
