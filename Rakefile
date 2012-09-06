require 'bundler/setup'

#require 'rake/testtask'
require 'rake/clean'
require 'rake/rdoctask'
require "rspec/core/rake_task"

CLEAN.include('pkg')
CLEAN.include('coverage')
CLOBBER.include('html')

Bundler::GemHelper.install_tasks

task :default => :spec

# run tests before building
task :build => :spec

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new do |t|
end

if RUBY_VERSION.to_f < 1.9
  desc "Run all specs with rcov"
  RSpec::Core::RakeTask.new(:rcov => :clean) do |t|
    t.rcov = true
    t.rcov_opts = '--exclude .gem/*,spec/*,.bundle/*,config/*,.rvm/*,lib/cosm-rb.rb'
  end
end

namespace :spec do
  desc "Run all specs tagged with :focus => true"
  RSpec::Core::RakeTask.new(:focus) do |t|
    t.rspec_opts = "--tag focus"
    t.verbose = true
  end
end

namespace :benchmark do
  require 'cosm-rb'
  require 'benchmark'

  def build_feed
    datastreams = []
    10.times do
      datastreams << build_datastream
    end

    feed = Cosm::Feed.new(:title => "Profile Feed",
                          :datastreams => datastreams,
                          :tags => ["red", "blue", "green"])
    return feed
  end

  def build_datastream
    Cosm::Datastream.new({ :id => "ds#{rand(1000)}",
                           :current_value => rand(1024),
                           :updated => Time.now,
                           :tags => ["yellow", "purple"] })
  end

  namespace :feed do
    desc "Benchmark feed parsing"
    task :parsing, :runs do |t, args|
      puts "\nBenchmarking feed parsing"
      puts "-------------------------"

      runs = args[:runs].to_i || 10000
      puts "#{runs} runs\n\n"

      feed = build_feed

      json = feed.to_json
      xml = feed.to_xml
      csv = feed.to_csv

      Benchmark.bmbm do |x|
        x.report("feed#from_json") do
          runs.times do
            Cosm::Feed.new(json)
          end
        end

        x.report("feed#from_xml") do
          runs.times do
            Cosm::Feed.new(xml)
          end
        end

        x.report("feed#from_csv") do
          runs.times do
            Cosm::Feed.new(csv, :v2)
          end
        end
      end
    end

    desc "Benchmark feed writing"
    task :writing, :runs do |t, args|
      puts "\nBenchmarking feed writing"
      puts "-------------------------"

      runs = args[:runs].to_i || 10000
      puts "#{runs} runs\n\n"

      feed = build_feed

      Benchmark.bmbm do |x|
        x.report("feed#to_json") do
          runs.times do
            feed.to_json
          end
        end

        x.report("feed#to_xml") do
          runs.times do
            feed.to_xml
          end
        end

        x.report("feed#to_csv") do
          runs.times do
            feed.to_csv
          end
        end
      end
    end
  end

  namespace :datastream do
    desc "\nBenchmark datastream parsing"
    task :parsing, :runs do |t, args|
      puts "Benchmarking datastream parsing"
      puts "-------------------------------"

      runs = args[:runs].to_i || 10000
      puts "#{runs} runs\n\n"

      datastream = build_datastream

      json = datastream.to_json
      xml = datastream.to_xml

      Benchmark.bmbm do |x|
        x.report("datastream#from_json") do
          runs.times do
            Cosm::Datastream.new(json)
          end
        end

        x.report("datastream#from_xml") do
          runs.times do
            Cosm::Datastream.new(xml)
          end
        end
      end
    end

    desc "Benchmark datastream writing"
    task :writing, :runs do |t, args|
      puts "\nBenchmarking datastream writing"
      puts "--------------------------------"

      runs = args[:runs].to_i || 10000
      puts "#{runs} runs\n\n"

      datastream = build_datastream

      Benchmark.bmbm do |x|
        x.report("datastream#to_json") do
          runs.times do
            datastream.to_json
          end
        end

        x.report("datastream#to_xml") do
          runs.times do
            datastream.to_xml
          end
        end

        x.report("datastream#to_csv") do
          runs.times do
            datastream.to_csv
          end
        end
      end
    end

  end

  desc "Benchmark feed and datastream parsing"
  task :parsing, :runs, :needs => ["feed:parsing", "datastream:parsing"]

  desc "Benchmark feed and datastream writing"
  task :writing, :runs, :needs => ["feed:writing", "datastream:writing"]

  task :all, :runs, :needs => [:parsing, :writing]
end

desc "Benchmark all feed and datastream parsing and writing"
task :benchmark, :runs, :needs => "benchmark:all"
