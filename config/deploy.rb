set :application, 'planet'
set :repository,  'git://github.com/matthewtodd/planet.git'
set :deploy_to,   '/users/home/matthew/domains/planet.matthewtodd.org/var/www'
set :deploy_via,  :remote_cache
set :scm,         :git
set :use_sudo,    false

server 'woodward.joyent.us', :web, :app, :db, :primary => true, :user => 'matthew'

namespace :deploy do
  task(:start)   { }
  task(:stop)    { }
  task(:restart) { }
end
