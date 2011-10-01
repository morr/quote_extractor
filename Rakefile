require "rubygems"
require "rubygems/package_task"
require 'rspec/core/rake_task'
require "rdoc/task"

task :default => :test

require "rake/testtask"
#Rake::TestTask.new do |t|
  #t.libs = [File.expand_path("lib"), "test"]
  #t.test_files = FileList["test/**/*_test.rb"]
  #t.verbose = true
#end

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|

  # Change these as appropriate
  s.name              = "quote-extractor"
  s.version           = "0.0.1"
  s.summary           = "Extractor for quotes in text"
  s.author            = "Andrey Sidorov"
  s.email             = "takandar@gmail.com"
  s.homepage          = "https://github.com/morr/QuoteExtractor"

  s.has_rdoc          = true
  # s.extra_rdoc_files  = %w(Readme.markdown)
  # s.rdoc_options      = %w(--main Readme.markdown)

  # Add any extra files to include in the gem
  s.files             = %w(Rakefile Guardfile) + Dir.glob("{bin,lib,test}/**/*")
  #s.executables       = FileList["bin/**"].map { |f| File.basename(f) }
  s.require_paths     = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  # s.add_dependency("some_other_gem", "~> 0.1.0")

  # If your tests use any gems, include them here
  #s.add_development_dependency("shoulda")
  s.add_development_dependency("rspec")
  #s.add_development_dependency("cucumber")

  # If you want to publish automatically to rubyforge, you'll may need
  # to tweak this, and the publishing task below too.
  #s.rubyforge_project = "gem-this"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3")
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

task :package => :gemspec

# Generate documentation
RDoc::Task.new do |rd|
  #rd.main = "Readme.markdown"
  #rd.rdoc_files.include("Readme.markdown", "lib/**/*.rb")
  #rd.rdoc_dir = "rdoc"
end

#desc 'Clear out RDoc and generated packages'
#task :clean => [:clobber_rdoc, :clobber_package] do
  #rm "#{spec.name}.gemspec"
#end

desc 'Tag the repository in git with gem version number'
task :tag do
  changed_files = `git diff --cached --name-only`.split("\n") + `git diff --name-only`.split("\n")
  if changed_files.empty? || changed_files == ['Rakefile']
    Rake::Task["package"].invoke
  
    if `git tag`.split("\n").include?("v#{spec.version}")
      raise "Version #{spec.version} has already been released"
    end
    `git add #{File.expand_path("../#{spec.name}.gemspec", __FILE__)} Rakefile`
    `git commit -m "Released version #{spec.version}"`
    `git tag v#{spec.version}`
    `git push --tags`
    `git push`
  else
    raise "Repository contains uncommitted changes; either commit or stash."
  end
end

desc "Tag and publish the gem to rubygems.org"
task :publish => :tag do
  `gem push pkg/#{spec.name}-#{spec.version}.gem`
end
## Get your spec rake tasks working in RSpec 2.0
#require 'rubygems'
#require 'rubygems/package_task'
##require 'rake/gempackagetask'
##require 'spec/rake/spectask'
#require 'rubygems/specification'
#require 'date'

#GEM = "quote extractor"
#GEM_VERSION = "0.0.1"
#AUTHOR = "Andrey Sidorov"
#EMAIL = "takandar@gmail.com"
#HOMEPAGE = "https://github.com/morr/QuoteExtractor"
#SUMMARY = "Extractor for quotes in text"

#spec = Gem::Specification.new do |s|
  #s.name = GEM
  #s.version = GEM_VERSION
  #s.platform = Gem::Platform::RUBY
  #s.has_rdoc = true
  ##s.extra_rdoc_files = ["README", "LICENSE", "CHANGELOG", "TODO"]
  #s.summary = SUMMARY
  #s.description = s.summary
  #s.author = AUTHOR
  #s.email = EMAIL
  #s.homepage = HOMEPAGE

  ## Uncomment this to add a dependency
  ## s.add_dependency "foo"

  #s.require_path = 'lib'
  #s.autorequire = GEM
  #s.files = Dir.glob("{lib,spec}/**/*")#%w(LICENSE README CHANGELOG TODO Rakefile)
#end

#Rake::GemPackageTask.new(spec) do |pkg|
  #pkg.gem_spec = spec
#end

#require 'rspec/core/rake_task'

#desc 'Default: run specs.'
task :default => :spec

#task 'test:units' => :spec

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  # Put spec opts in a file named .rspec in root
end

#desc "Generate code coverage"
#RSpec::Core::RakeTask.new(:coverage) do |t|
  #t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  #t.rcov = true
  #t.rcov_opts = ['--exclude', 'spec']
#end

#desc "install the gem locally"
#task :install => [:package] do
  #sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
#end

#desc "create a gemspec file"
#task :make_spec do
  #File.open("#{GEM}.gemspec", "w") do |file|
    #file.puts spec.to_ruby
  #end
#end
