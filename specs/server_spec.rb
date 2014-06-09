require File.dirname(__FILE__) + '/spec_helper'

require 'sinatra'
require 'rack/test'

include Rack::Test::Methods

def app
  b = Stork::Builder.load
  a = Stork::Server::Application
  a.set :collection, b.collection
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
    get '/host/server.example.org'
    message = "foo"
    last_response.body.wont_equal "{ \"status\":\"404\", \"message\": \"not found\" }"
  end

  it "should error for invalid host" do
    get '/host/invalid.org'
    message = "{ \"status\":\"404\", \"message\": \"not found\" }"
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
              LOCALBOOT -1
      EOS
    File.read("./specs/tmp/pxeboot/01-00-11-22-33-44-55").must_equal expected_content
  end

  it "should error on completed install for invalid host" do
    get '/host/invalid.org/installed'
    last_response.body.must_equal "{ \"status\":\"404\", \"message\": \"not found\" }"
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
    last_response.body.must_equal "{ \"status\":\"404\", \"message\": \"not found\" }"
  end
end
