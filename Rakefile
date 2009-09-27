# Whenever re-loads this Rakefile and uses RAILS_ROOT as its default path.
require 'rake'
RAILS_ROOT = File.expand_path(File.dirname(__FILE__))

task :clean do
  sh 'git clean -fdX'
end

task :planet do
  sh 'python vendor/venus/planet.py config/planet.ini'
end

task :whenever do
  sh 'ruby -I vendor/gems/chronic-0.2.3/lib -I vendor/gems/javan-whenever-0.3.7/lib vendor/gems/javan-whenever-0.3.7/bin/whenever --update-crontab'
end
