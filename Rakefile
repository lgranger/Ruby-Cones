#!/usr/bin/env ruby
# -*- ruby -*-

require 'rake/clean'

SRC_DIR      = 'src'
PROB_DIR     = 'cones'
DOWNLOAD_DIR = 'download'

SRC_FILES = FileList["#{SRC_DIR}/*"]
CONE_FILES = SRC_FILES.pathmap("#{PROB_DIR}/%f")

ZIP_FILE = "#{DOWNLOAD_DIR}/rubycones.zip"

CLEAN.include("**/*.rbc")

module Cones
  extend Rake::DSL if defined?(Rake::DSL)

  # Remove solution info from source
  #   __(a,b)     => __
  #   _n_(number) => __
  #   # __        =>
  def Cones.remove_solution(line)
    line = line.gsub(/\b____\([^\)]+\)/, "____")
    line = line.gsub(/\b___\([^\)]+\)/, "___")
    line = line.gsub(/\b__\([^\)]+\)/, "__")
    line = line.gsub(/\b_n_\([^\)]+\)/, "_n_")
    line = line.gsub(%r(/\#\{__\}/), "/__/")
    line = line.gsub(/\s*#\s*__\s*$/, '')
    line
  end

  def Cones.make_cone_file(infile, outfile)
    if infile =~ /neo/
      cp infile, outfile
    else
      open(infile) do |ins|
        open(outfile, "w") do |outs|
          state = :copy
          ins.each do |line|
            state = :skip if line =~ /^ *#--/
            case state
            when :copy
              outs.puts remove_solution(line)
            else
              # do nothing
            end
            state = :copy if line =~ /^ *#\+\+/
          end
        end
      end
    end
  end
end

module RubyImpls
  # Calculate the list of relevant Ruby implementations.
  def self.find_ruby_impls
    rubys = `rvm list`.gsub(/=>/,'').split(/\n/).map { |x| x.strip }.reject { |x| x.empty? || x =~ /^rvm/ }.sort
    expected.map { |impl|
      last = rubys.grep(Regexp.new(Regexp.quote(impl))).last
      last ? last.split.first : nil
    }.compact
  end

  # Return a (cached) list of relevant Ruby implementations.
  def self.list
    @list ||= find_ruby_impls
  end

  # List of expected ruby implementations.
  def self.expected
    %w(ruby-1.8.7 ruby-1.9.2 jruby ree)
  end
end

task :default => :travel_the_road

task :travel_the_road do
  cd PROB_DIR
  ruby 'road_to_victory.rb'
end

directory DOWNLOAD_DIR
directory PROB_DIR

desc "(re)Build zip file"
task :zip => [:clobber_zip, :package]

task :clobber_zip do
  rm ZIP_FILE
end

file ZIP_FILE => CONE_FILES + [DOWNLOAD_DIR] do
  sh "zip #{ZIP_FILE} #{PROB_DIR}/*"
end

desc "Create packaged files for distribution"
task :package => [ZIP_FILE]

desc "Upload the package files to the web server"
task :upload => [ZIP_FILE] do
  sh "scp #{ZIP_FILE} linode:sites/onestepback.org/download"
end

desc "Generate the Cones from the source files from scratch."
task :regen => [:clobber_cones, :gen]

desc "Generate the Cones from the changed source files."
task :gen => CONE_FILES + [PROB_DIR + "/README.rdoc"]
task :clobber_cones do
  rm_r PROB_DIR
end

file PROB_DIR + "/README.rdoc" => "README.rdoc" do |t|
  cp "README.rdoc", t.name
end

SRC_FILES.each do |cone_src|
  file cone_src.pathmap("#{PROB_DIR}/%f") => [PROB_DIR, cone_src] do |t|
    Cones.make_cone_file cone_src, t.name
  end
end

task :run do
  puts 'cones'
  Dir.chdir("#{SRC_DIR}") do
    puts "in #{Dir.pwd}"
    sh "ruby road_to_victory.rb"
  end
end


desc "Pre-checkin tests (=> run_all)"
task :cruise => :run_all

desc "Run the completed cones againts a list of relevant Ruby Implementations"
task :run_all do
  results = []
  RubyImpls.list.each do |impl|
    puts "=" * 40
    puts "On Ruby #{impl}"
    sh ". rvm #{impl}; rake run"
    results << [impl, "RAN"]
    puts
  end
  puts "=" * 40
  puts "Summary:"
  puts
  results.each do |impl, res|
    puts "#{impl} => RAN"
  end
  puts
  RubyImpls.expected.each do |requested_impl|
    impl_pattern = Regexp.new(Regexp.quote(requested_impl))
    puts "No Results for #{requested_impl}" unless results.detect { |x| x.first =~ impl_pattern }
  end
end
