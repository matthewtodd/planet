#!/usr/bin/env ruby

require 'rexml/document'

# HACK: feedparser is removing xlink namespace from Sam Ruby's SVGs
class REXML::Parsers::BaseParser
  def stream=( source )
    @source = REXML::SourceFactory.create_from( source )
    @closed = nil
    @document_status = nil
    @tags = []
    @stack = []
    @entities = []
    @nsstack = []

    xlink_set = Set.new
    xlink_set << 'xlink'
    @nsstack.unshift(xlink_set)
  end
end

doc = REXML::Document.new($stdin)

entry         = doc.root
author        = entry.get_elements('author').first || entry.add_element('author')
source_author = entry.get_elements('source/author').first

if source_author
  %w(name email uri).each do |name|
    if author.get_elements(name).empty?
      source_author.get_elements(name).each { |source_element| author.add_element(source_element.deep_clone) }
    end
  end
end

# HACK: feedparser is removing xlink namespace from Sam Ruby's SVGs
entry.get_elements('//svg').each { |svg| svg.add_namespace('xlink', 'http://www.w3.org/1999/xlink') }

doc.write
