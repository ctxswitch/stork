require File.dirname(__FILE__) + '/spec_helper'

require 'sinatra'
require 'rack/test'

include Rack::Test::Methods

def app
  b = Midwife::Builder.load(configuration)
  a = Midwife::Server::Application
  a.set :collection, b.collection
  a.set :midwife, configuration
  a
end

describe "Midwife::Server::Application" do
  it "should respond to the root" do
    get '/'
    message = "{ \"status\":\"200\", \"message\": \"Midwife Version #{Midwife::VERSION} - #{Midwife::CODENAME}\" }"
    last_response.body.must_equal message
  end

  it "should output the kickstart file for a valid host" do
    get '/ks/example.org'
    message = "foo"
    last_response.body.wont_equal "{ \"status\":\"404\", \"message\": \"not found\" }"
  end

  it "should error for invalid host" do
    get '/ks/invalid.org'
    message = "{ \"status\":\"404\", \"message\": \"not found\" }"
    last_response.body.must_equal message
  end

  it "should notify of a completed install" do
    get '/notify/example.org/installed'
    last_response.body.must_equal "{ \"status\":\"200\", \"message\": \"OK\" }"
    File.read("./specs/tmp/pxeboot/00-11-22-33-44-55").must_equal File.read("./specs/files/results/pxe.localboot")
  end

  it "should error on completed install for invalid host" do
    get '/notify/invalid.org/installed'
    last_response.body.must_equal "{ \"status\":\"404\", \"message\": \"not found\" }"
  end

  it "should notify of an install request" do
    get '/notify/example.org/install'
    last_response.body.must_equal "{ \"status\":\"200\", \"message\": \"OK\" }"
    File.read("./specs/tmp/pxeboot/00-11-22-33-44-55").must_equal File.read("./specs/files/results/pxe.install")
  end

  it "should error for invalid host" do
    get '/notify/invalid.org/install'
    last_response.body.must_equal "{ \"status\":\"404\", \"message\": \"not found\" }"
  end
end
