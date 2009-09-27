require 'rake'
require 'pathname'

Root = Pathname.new(File.dirname(__FILE__)).expand_path

task :whenever do
  load_paths = Root.join('vendor', 'gems').children.map { |child| child.join('lib') }
  executable = Root.join('vendor', 'gems', 'javan-whenever-0.3.7', 'bin', 'whenever')

  sh "ruby #{load_paths.map { |path| '-I ' + path }.join(' ')} #{executable} --update-crontab planet"
end
