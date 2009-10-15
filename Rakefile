# Whenever re-loads this Rakefile and uses RAILS_ROOT as its default path.
require 'rake'
RAILS_ROOT = File.expand_path(File.dirname(__FILE__))

desc 'Remove ignored files'
task :clean do
  sh 'git clean -fdX'
end

desc 'Fetch feeds'
task :default do
  sh 'env PYTHONPATH=lib/shell python vendor/venus/planet.py config/planet.ini'
end

desc 'Schedule feed fetching in crontab'
task :crontab do
  sh 'bin/whenever --update-crontab planet'
end
