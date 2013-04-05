require 'rspec'
require "#{Dir.pwd}/lib/quote_extractor.rb"

RSpec.configure do |c|
  c.filter_run :focus => true
  c.run_all_when_everything_filtered = true
end
