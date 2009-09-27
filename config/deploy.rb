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
      ln -s #{shared_path}/log #{latest_release}/log
    CMD
  end
end

after 'deploy:update_code' do
  run "cd #{release_path} && rake planet"
end

after 'deploy:symlink' do
  run "cd #{release_path} && rake whenever"
end
