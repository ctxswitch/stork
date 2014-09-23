require File.dirname(__FILE__) + '/spec_helper'

require 'sinatra'
require 'rack/test'

include Rack::Test::Methods

def app
  b = Stork::Builder.load
  a = Stork::Server::Application

  d = Stork::Database.load('./specs/tmp')
  d.sync_hosts(b.collection.hosts)

  a.set :collection, b.collection
  a.set :database, d
  a
end

describe "Stork::Server::Application" do
  before(:each) do
    load_config
    FileUtils.mkdir('./specs/tmp/pxeboot')
  end

  after(:each) do
    FileUtils.rm_rf(Dir.glob('./specs/tmp/*'))
  end

  it "should respond to the root" do
    get '/'
    message = "{ \"status\":\"200\", \"message\": \"Stork Version #{Stork::VERSION} - #{Stork::CODENAME}\" }"
    last_response.body.must_equal message
  end

  it "should output the kickstart file for a valid host" do
    get '/host/server.example.org/install'
    get '/host/server.example.org'
    message = "foo"
    last_response.body.wont_equal "{ \"status\":\"404\", \"message\": \"Not found\" }"
  end

  it "should not output the kickstart file when host action is not set to install" do
    get '/host/server.example.org'
    message = "foo"
    last_response.body.must_equal "{ \"status\":\"404\", \"message\": \"Not found\" }"
  end

  it "should error for invalid host" do
    get '/host/invalid.org'
    message = "{ \"status\":\"404\", \"message\": \"Not found\" }"
    last_response.body.must_equal message
  end

  it "should notify of a completed install" do
    get '/host/server.example.org/installed'
    last_response.body.must_equal "{ \"status\":\"200\", \"message\": \"OK\" }"

    expected_content = <<-EOS.gsub(/^ {6}/, '')
      DEFAULT local
      PROMPT 0
      TIMEOUT 0
      TOTALTIMEOUT 0
      ONTIMEOUT local
      LABEL local
              LOCALBOOT 0
      EOS
    File.read("./specs/tmp/pxeboot/01-00-11-22-33-44-55").must_equal expected_content
  end

  it "should error on completed install for invalid host" do
    get '/host/invalid.org/installed'
    last_response.body.must_equal "{ \"status\":\"404\", \"message\": \"Not found\" }"
  end

  it "should send a public file" do
    get '/public/file.txt'
    last_response.status.must_equal 200
  end

  it "should give a 404 on a non existant file" do
    get '/public/error.txt'
    last_response.status.must_equal 404
  end

  it "should notify of an install request" do
    get '/host/server.example.org/install'
    last_response.body.must_equal "{ \"status\":\"200\", \"message\": \"OK\" }"

    expected_content = <<-EOS.gsub(/^ {6}/, '')
      default install
      prompt 0
      timeout 1
      label install
              kernel vmlinuz
              ipappend 2
              append initrd=initrd.img ksdevice=bootif priority=critical kssendmac ks=http://localhost:5000/host/server.example.org
      EOS
    File.read("./specs/tmp/pxeboot/01-00-11-22-33-44-55").must_equal expected_content
  end

  it "should error for invalid host" do
    get '/host/invalid.org/install'
    last_response.body.must_equal "{ \"status\":\"404\", \"message\": \"Not found\" }"
  end
end
