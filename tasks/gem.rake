require 'yaml'

require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.name                  = GitRemoteTag::NAME
  s.version               = GitRemoteTag::VERSION::STRING
  s.summary               = "git_remote_branch eases the interaction with remote branches"
  s.description           = "git_remote_branch is a learning tool to ease the interaction with " +
                            "remote branches in simple situations."

  s.authors               = ['Ken Barker']
  s.email                 = "ken@edgecase.com"
  s.homepage              = "http://github.com/kEND/git_remote_tag"
  s.rubyforge_project     = ''

  s.has_rdoc              = true
  s.extra_rdoc_files     << 'README.rdoc'
  s.rdoc_options         << '--main' << 'README.rdoc' << '--exclude' << 'lib'
  
  s.test_files            = Dir['test/**/*'].reject{|f| f =~ /test_runs/}
  s.files                 = Dir['**/*'].reject{|f| f =~ /\Apkg|\Acoverage|\Ardoc|test_runs|\.gemspec\Z/}
  
  s.executable            = 'grt'
  s.bindir                = "bin"
  s.require_path          = "lib"
  
  s.add_dependency( 'colored', '>= 1.1' )
end

#Creates clobber_package, gem, package and repackage tasks
#Note on clobber_package: fortunately, this will clobber the CODE package
Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
end

TAG_COMMAND = "git tag -m 'Tagging version #{GitRemoteTag::VERSION::STRING}' -a v#{GitRemoteTag::VERSION::STRING}"
task :tag_warn do
  puts  "*" * 40,
        "Don't forget to tag the release:",
        '',
        "  " + TAG_COMMAND,
        '',
        "or run rake tag",
        "*" * 40
end
task :tag do
  sh TAG_COMMAND
  puts "Upload tags to repo with 'git push --tags'"
end
task :gem => :tag_warn

namespace :gem do
  desc "Update the gemspec for GitHub's gem server"
  task :github do
    File.open("#{GitRemoteTag::NAME}.gemspec", 'w'){|f| f.puts YAML::dump(spec) }
    puts "gemspec generated here: #{GitRemoteTag::NAME}.gemspec"
  end
  
  desc 'Upload gem to rubyforge.org'
  task :rubyforge => :gem do
    sh 'rubyforge login'
    sh "rubyforge add_release grt grt '#{GitRemoteTag::VERSION::STRING}' pkg/#{spec.full_name}.gem"
    sh "rubyforge add_file grt grt #{GitRemoteTag::VERSION::STRING} pkg/#{spec.full_name}.gem"
  end
  
  desc 'Install the gem built locally'
  task :install => [:clean, :gem] do
    sh "#{SUDO} gem install pkg/#{spec.full_name}.gem"
  end
  
  desc "Uninstall version #{GitRemoteTag::VERSION::STRING} of the gem"
  task :uninstall do
    sh "#{SUDO} gem uninstall -v #{GitRemoteTag::VERSION::STRING} -x #{GitRemoteTag::NAME}"
  end
  
  if WINDOWS
    win_spec = spec.dup
    win_spec.platform = Gem::Platform::CURRENT
    win_spec.add_dependency( 'win32console', '~> 1.1' ) # Missing dependency in the 'colored' gem
    
    desc "Generate the Windows version of the gem"
    namespace :windows do
      Rake::GemPackageTask.new(win_spec) do |p|
        p.gem_spec = win_spec
      end
    end
  end
end
