#!/usr/bin/env ruby

require 'pathname'
require 'rexml/document'
require 'uri'

module Enclosure
  def has_mime_type?(mime_types)
    mime_types.include?(mime_type) || mime_types.include?(mime_type_star)
  end

  def download_to(path)
    output = path.join(uri.basename)

    unless output.exist? && output.size == length
      system 'curl', '--location', '--output', output, uri.to_s
    end
  end

  private

  def length
    attributes['length'].to_i
  end

  def mime_type
    attributes['type']
  end

  def mime_type_star
    mime_type.to_s.sub(%r{/.*$}, '/*')
  end

  def uri
    URI.parse(attributes['href']).extend(Basename)
  end

  module Basename
    def basename
      File.basename(path)
    end
  end
end

module HasEnclosures
  def enclosures
    get_elements('link').
      select  { |element| element.attributes['rel'] == 'enclosure' }.
      collect { |element| element.extend(Enclosure) }
  end
end

class Options
  attr_reader :mime_types
  attr_reader :output_path

  def initialize(args)
    @mime_types  = []
    @output_path = Pathname.pwd

    parse(*args)

    freeze
  end

  private

  def parse(*args)
    Hash[*args].each do |key, value|
      case key
      when '--mime-types'
        @mime_types = value.split(',')
      when '--output-path'
        @output_path = Pathname.new(value)
      end
    end
  end
end

doc     = REXML::Document.new($stdin)
entry   = doc.root.extend(HasEnclosures)
options = Options.new(ARGV)

entry.enclosures.
  select { |enclosure| enclosure.has_mime_type?(options.mime_types) }.
  each   { |enclosure| enclosure.download_to(options.output_path) }

doc.write
