# DO NOT MODIFY THIS FILE
module Bundler
 file = File.expand_path(__FILE__)
 dir = File.dirname(file)

  ENV["PATH"]     = "#{dir}/../../bin:#{ENV["PATH"]}"
  ENV["RUBYOPT"]  = "-r#{file} #{ENV["RUBYOPT"]}"

  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rake-0.8.7/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rake-0.8.7/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rubyforge-2.0.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rubyforge-2.0.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/whenever-0.3.7/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/whenever-0.3.7/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json_pure-1.1.9/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json_pure-1.1.9/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/hoe-2.3.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/hoe-2.3.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/chronic-0.2.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/chronic-0.2.3/lib")

  @gemfile = "#{dir}/../../Gemfile"

  require "rubygems"

  @bundled_specs = {}
  @bundled_specs["rake"] = eval(File.read("#{dir}/specifications/rake-0.8.7.gemspec"))
  @bundled_specs["rake"].loaded_from = "#{dir}/specifications/rake-0.8.7.gemspec"
  @bundled_specs["whenever"] = eval(File.read("#{dir}/specifications/whenever-0.3.7.gemspec"))
  @bundled_specs["whenever"].loaded_from = "#{dir}/specifications/whenever-0.3.7.gemspec"
  @bundled_specs["rubyforge"] = eval(File.read("#{dir}/specifications/rubyforge-2.0.3.gemspec"))
  @bundled_specs["rubyforge"].loaded_from = "#{dir}/specifications/rubyforge-2.0.3.gemspec"
  @bundled_specs["chronic"] = eval(File.read("#{dir}/specifications/chronic-0.2.3.gemspec"))
  @bundled_specs["chronic"].loaded_from = "#{dir}/specifications/chronic-0.2.3.gemspec"
  @bundled_specs["hoe"] = eval(File.read("#{dir}/specifications/hoe-2.3.3.gemspec"))
  @bundled_specs["hoe"].loaded_from = "#{dir}/specifications/hoe-2.3.3.gemspec"
  @bundled_specs["json_pure"] = eval(File.read("#{dir}/specifications/json_pure-1.1.9.gemspec"))
  @bundled_specs["json_pure"].loaded_from = "#{dir}/specifications/json_pure-1.1.9.gemspec"

  def self.add_specs_to_loaded_specs
    Gem.loaded_specs.merge! @bundled_specs
  end

  def self.add_specs_to_index
    @bundled_specs.each do |name, spec|
      Gem.source_index.add_spec spec
    end
  end

  add_specs_to_loaded_specs
  add_specs_to_index

  def self.require_env(env = nil)
    context = Class.new do
      def initialize(env) @env = env && env.to_s ; end
      def method_missing(*) ; end
      def only(env)
        old, @only = @only, _combine_onlys(env)
        yield
        @only = old
      end
      def except(env)
        old, @except = @except, _combine_excepts(env)
        yield
        @except = old
      end
      def gem(name, *args)
        opt = args.last || {}
        only = _combine_onlys(opt[:only] || opt["only"])
        except = _combine_excepts(opt[:except] || opt["except"])
        files = opt[:require_as] || opt["require_as"] || name
        files = [files] unless files.respond_to?(:each)

        return unless !only || only.any? {|e| e == @env }
        return if except && except.any? {|e| e == @env }

        files.each { |f| require f }
        yield if block_given?
        true
      end
      private
      def _combine_onlys(only)
        return @only unless only
        only = [only].flatten.compact.uniq.map { |o| o.to_s }
        only &= @only if @only
        only
      end
      def _combine_excepts(except)
        return @except unless except
        except = [except].flatten.compact.uniq.map { |o| o.to_s }
        except |= @except if @except
        except
      end
    end
    context.new(env && env.to_s).instance_eval(File.read(@gemfile))
  end
end

module Gem
  def source_index.refresh!
    super
    Bundler.add_specs_to_index
  end
end
