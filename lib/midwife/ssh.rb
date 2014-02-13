require 'net/ssh'
require 'net/ssh/multi'
require 'highline/import'

module Midwife
  class SSH
    def initialize(host)
      @password = "my super cool midwife password"
      @user = "root"
      @host = host
      session.use "#{@user}@#{@host}", :password => @password
    end

    def get_password
      ask("Enter your password: ") {|q| q.echo = "*"}
    end

    def session
      ssh_error_handler = Proc.new do |server|
        puts "Failed to connect to #{@host} -- #{$!.class.name}: #{$!.message}"
        throw :go, :raise
      end
      @password = get_password if @password =~ /my super cool midwife password/
      @session ||= Net::SSH::Multi.start( :on_error => ssh_error_handler )
    end

    def print_data(host, data)
      if data =~ /\n/
        data.split(/\n/).each { |d| print_data(host, d) }
      else
        padding = 24 - host.length
        puts data
      end
    end

    def run(command)
      exit_status = 127
      subsession ||= session
      subsession.open_channel do |ch|
        puts "channel"
        ch.request_pty
        ch.exec(command) do |ch,success|
          raise ArgumentError unless success
          ch.on_data do |ichannel, data|
            print_data(ichannel[:host], data)
            if data =~ /^my super cool midwife password/
              ichannel.send_data("#{get_password}\n")
            end
          end
          ch.on_request("exit-status") do |ch,data|
            exit_status = data.read_long
          end
        end
      end
      session.loop
      exit_status
    end
  end
end