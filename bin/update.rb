#!/usr/bin/env ruby

# by ensuring our working directory, we can use relative paths in config.ini
root_path = File.expand_path(File.dirname(__FILE__) + '/..')
Dir.chdir(root_path) do
  exec 'python vendor/venus/planet.py config/planet.ini'  
end

# 0 0,4,8,12,16,20 * * * /usr/local/bin/bash -c 'PATH=/users/home/matthew/.gem/rub
# y/1.8/bin:/usr/local/libexec/git-core:/usr/local/bin:/usr/local/sbin:/usr/xpg4/b
# in:/usr/sbin:/usr/bin:/usr/sfw/bin:/usr/ccs/bin:/usr/openwin/bin:/opt/mysql/curr
# ent/bin /usr/local/bin/python2.5 /users/home/matthew/domains/planet.matthewtodd.
# org/lib/venus/planet.py /users/home/matthew/domains/planet.matthewtodd.org/etc/p
# lanet.ini &> /users/home/matthew/domains/planet.matthewtodd.org/var/log/venus.lo
# g' #Update planet feeds.
