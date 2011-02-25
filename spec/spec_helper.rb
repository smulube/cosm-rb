require 'rubygems'
require 'bundler/setup'

require 'rspec'
require 'ruby-debug'

require 'time'
require 'activerecord'

Dir['./spec/support/**/*.rb'].map {|f| require f}

$:.push File.expand_path("../lib", __FILE__)
require 'pachube_data_formats'

def load_schema
  config = YAML::load(IO.read(File.dirname(__FILE__) + '/fixtures/database.yml'))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/../debug.log")

  db_adapter = ENV['DB']

  # no db passed, try one of these fine config-free DBs before bombing.
  db_adapter ||=
    begin
      require 'rubygems'
      require 'sqlite'
      'sqlite'
    rescue MissingSourceFile
      begin
        require 'sqlite3'
        'sqlite3'
      rescue MissingSourceFile
      end
    end

  if db_adapter.nil?
    raise "No DB Adapter selected. Pass the DB= option to pick one, or install Sqlite or Sqlite3."
  end

  ActiveRecord::Base.establish_connection(config[db_adapter])
  load(File.dirname(__FILE__) + "/fixtures/schema.rb")
  require File.dirname(__FILE__) + '/../init.rb'
end

require File.dirname(__FILE__) + '/fixtures/models.rb'

