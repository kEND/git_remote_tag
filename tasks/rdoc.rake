require 'rake/rdoctask'

desc 'Generate rdoc documentation'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = GitRemoteTag::NAME
  rdoc.rdoc_files.include('README.rdoc')
end

namespace :rdoc do
  desc 'Upload documentation to rubyforge'
  task :upload => :rdoc do
    sh "scp -r #{GRB_ROOT}/rdoc/* nothing@rubyforge.org:/var/www/gforge-projects/grt/"
  end
end
