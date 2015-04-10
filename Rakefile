# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :app do
  namespace :ptor do
    desc 'Runs protractor tests'
    task :run, [:show_output, :webserver_port] => :environment do |t, args|
      output = true
      port = 5000
      App::Protractor.run_specs output, port
    end
  end
end

module App
  module Protractor
    def self.run_specs _show_ouput = false, _webserver_port = 3001
      require 'net/http'
      ActiveRecord::Base.establish_connection('test')
      @show_ouput = _show_ouput
      @webserver_port = _webserver_port

      begin
        prepare_test_db
        load_test_data
        install_protractor
        run_webserver
        run_tests
        kill_webserver

      rescue Exception => e
        kill_webserver
        show_error(e)
      end
    end

    private

    def self.show_error exc
      puts exc.message
      puts exc.backtrace.join("\n")
    end

    def self.msg _message
      puts _message
    end

    def self.run_cmd _cmd
      cmd = _cmd
      cmd = "#{_cmd} > /dev/null 2>&1" unless @show_ouput
      system(cmd)
    end

    def self.run_webserver
      msg "Starting webserver..."
      kill_webserver
      thread = Thread.new { run_cmd("bundle exec rails s -p #{@webserver_port} -e test") }
      wait_for_webserver
      thread
    end

    def self.install_protractor
      msg "Getting protractor"
      run_cmd "npm install protractor"
    end

    def self.run_selenium
      msg "Starting Selenium..."
      thread = Thread.new { run_cmd "webdriver-manager start --chrome" }
      wait_for_selenium
      thread
    end

    def self.prepare_test_db
      msg "Preparing test database..."
      run_cmd("bundle exec rake db:reset RAILS_ENV=test")
      run_cmd("bundle exec rake db:setup RAILS_ENV=test")
    end

    def self.load_test_data
      # msg "Loading test data..."
      # Not needed for now - but this would avoid having to have test endpoint in the angular routing
    end

    def self.run_tests
      msg "Running protractor tests..."
      system("node_modules/protractor/bin/protractor functionaltests/conf.js")
    end

    def self.wait_for_webserver
      msg "Waiting for Rails server..."
      wait_for_server "http://localhost:#{@webserver_port}/"
    end

    def self.wait_for_selenium
      msg "Waiting for ChromeDriver..."
      wait_for_server "http://localhost:4444/"
    end

    def self.wait_for_server _url
      sleep 1 until server_ready? _url
    end

    def self.kill_webserver
      kill_server @webserver_port
    end

    def self.kill_selenium
      kill_server 4444
    end

    def self.kill_server _port
      run_cmd("kill -9 $(lsof -i :#{_port} -t)")
    end

    #utilizo este metodo para preguntar si mi app y Selenium estan
    #levantados antes de comenzar a correr los test.
    def self.server_ready? _url
      begin
        url = URI.parse(_url)
        req = Net::HTTP.new(url.host, url.port)
        res = req.request_head(url.path)
        !res.code.blank?
      rescue
        false
      end
    end
  end
end