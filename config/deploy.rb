# woodward has rubygems 1.3.5, but bundler proper needs 1.3.6.
# I don't want to keep managing my own copy of rubygems up there.
depend :remote, :gem, 'bundler08', '~> 0.8.5'

set :application, 'planet'
set :repository,  'git://github.com/matthewtodd/planet.git'
set :deploy_to,   '/users/home/matthew/domains/planet.matthewtodd.org/var/www'
set :deploy_via,  :remote_cache
set :scm,         :git
set :use_sudo,    false

# Capistrano defaults to creating system, log, and pids under the shared_path,
# but I need cache (for venus to cache its downloaded feeds) and log.
set :shared_children, %w(cache log)

server 'woodward.joyent.us', :web, :app, :db, :primary => true, :user => 'matthew'

namespace :deploy do
  task(:start)   { }
  task(:stop)    { }
  task(:restart) { }

  # I've overridden finalize_update rather than hook into it because I need
  # more directories created, and one command is significantly faster than 2
  # on my slow connection.
  desc '[internal] Touches up the released code.'
  task :finalize_update, :except => { :no_release => true } do
    run <<-CMD
      rm -rf #{latest_release}/log #{latest_release}/tmp/cache &&
      mkdir -p #{latest_release}/tmp &&
      ln -s #{shared_path}/cache #{latest_release}/tmp/cache &&
      ln -s #{shared_path}/log #{latest_release}/log &&
      cd #{latest_release} && gem bundle --cached
    CMD
  end
end

after 'deploy:symlink' do
  run "cd #{release_path} && rake crontab"
  deploy.cleanup
end

desc 'Download latest logfiles for local inspection.'
task :logs do
  get "#{shared_path}/log/venus.log", 'venus.production.log'
end

# Note that we don't automatically refresh feeds on deploy -- it just takes
# too long! I'm generally happy to let cron take care of it in due time, but
# this refresh task is here just in case.
desc 'Manually refresh feeds.'
task :refresh do
  run "cd #{current_path} && rake"
end
