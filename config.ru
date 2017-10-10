require 'sinatra/base'
require 'json'
require 'active_support/core_ext/hash/keys'
require 'pry'

$stdout.sync = true

class LogApp < Sinatra::Base
  set :bind, '0.0.0.0'

  get '/*' do
    log("request for #{request.path_info}")

    'ok'
  end

  def logger
    @logger ||= MyLogger.new
  end

  def log(message)
    logger.info(message)
  end
end

class MyLogger
  def info(message)
    json(message)
    plaintext(message)
  end

  def json(event = nil)
    puts({
      application: 'log_output',
      event: event
    }.stringify_keys.to_json)
  end

  def plaintext(event = nil)
    puts "application: log_output, event: #{event}"
  end

  def self.ticker
    Thread.new do
      @logger ||= self.new
      @i = 0
      while true do
        @i += 1
        sleep 10
        @logger.info("tick #{@i}")
      end
    end
  end

end

MyLogger.ticker
LogApp.run!
