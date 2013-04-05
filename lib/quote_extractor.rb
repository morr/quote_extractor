##!/usr/bin/env ruby
require 'rubygems'
require 'ap'

#$LOCAL_DEBUG = true
module QuoteExtractor
  class << self
    # вытаскивает из текста информацию о цитатах в нём
    def extract(text, pos=0, root=true)
      start_pos = pos
      tags = []
      iteration = 0

      while tag_start = text[pos, text.size] =~ /(\[(?:quote(?:=.*?)?|\/quote)\])/
        iteration += 1
        break if iteration > 10
        #ap "extract('#{text}', #{pos}) -> #{text[pos, text.size]}, start: #{tag_start}" if $LOCAL_DEBUG
        #ap "checked: "+text[pos, text.size] if $LOCAL_DEBUG
        tag_size = $1.length

        next if $1 =='[/quote]' && pos == 0
        if $1 =='[/quote]'
          if root
            return tags
          else
            return [tags, pos+tag_start+tag_size]
          end
        end

        tag = { :start => pos+tag_start }
        #ap tag if $LOCAL_DEBUG
        #ap tag_size if $LOCAL_DEBUG
        #ap '--->'+text[0, tag[:start]+tag_size] if $LOCAL_DEBUG
        tag[:tags], tag[:end] = extract(text, tag[:start]+tag_size, false)
        #ap tag if $LOCAL_DEBUG
        #ap '<---'+text[tag[:start], tag[:end]] if $LOCAL_DEBUG

        if tag[:end] != -1
          tags << tag
          pos = tag[:end]
        else
          pos = tag[:start]+tag_size
        end
      end
      start_pos == 0 ? tags : [tags, -1]
    end

    # фильтрует из текста все цитаты с уровнем вложенности более допустимого
    def filter(text, nesting, quotes=nil)
      return filter(text, nesting, extract(text)) unless quotes

      if nesting == 0
        quotes.reverse.each do |quote|
          text = text[0, quote[:start]] + text[quote[:end], text.size]
        end
      else
        quotes.reverse.each do |quote|
          text = filter(text, nesting-1, quote[:tags])
        end
      end
      text
    end
  end
end
