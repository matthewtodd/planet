# I'm deploying to a Solaris machine, where setting environment variables in
# crontabs isn't allowed.
set :set_path_automatically, false

# So I can't use whenever's "rake" command; I need to unroll it and inject my
# current PATH, like so:
every 4.hours do
  command "cd #{Whenever.path} && /usr/bin/env PATH='#{ENV['PATH']}' rake planet > log/venus.log 2>&1"
end
