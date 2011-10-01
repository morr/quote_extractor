#!/usr/bin/env ruby
require 'rubygems'
require 'ap'

#$LOCAL_DEBUG = true
module QuoteExtractor
  def self.extract(text, pos=0)
    start_pos = pos
    tags = []
    iteration = 0

    while tag_start = text[pos, text.size] =~ /(\[(?:quote(?:=.*?)?|\/quote)\])/
      iteration += 1
      break if iteration > 10
      ap "extract('#{text}', #{pos}) -> #{text[pos, text.size]}, start: #{tag_start}" if $LOCAL_DEBUG
      ap "checked: "+text[pos, text.size] if $LOCAL_DEBUG
      tag_size = $1.length

      next if $1 =='[/quote]' && pos == 0
      return [tags, pos+tag_start+tag_size] if $1 =='[/quote]'

      tag = { :start => pos+tag_start }
      ap tag if $LOCAL_DEBUG
      ap tag_size if $LOCAL_DEBUG
      ap '--->'+text[0, tag[:start]+tag_size] if $LOCAL_DEBUG
      tag[:tags], tag[:end] = extract(text, tag[:start]+tag_size)
      ap tag if $LOCAL_DEBUG
      ap '<---'+text[tag[:start], tag[:end]] if $LOCAL_DEBUG

      if tag[:end] != -1
        tags << tag
        pos = tag[:end]
      else
        pos = tag[:start]+tag_size
      end
    end
    start_pos == 0 ? tags : [tags, -1]
  end
end
