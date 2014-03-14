require File.dirname(__FILE__) + '/spec_helper'

include Rack::Test::Methods

def app
  Midwife::Server::Application
end

describe "Midwife::Server::Application" do
  it "should respond to the root" do
    get '/'
    message = "{ \"status\":\"200\", \"message\": \"Midwife Version #{Midwife::VERSION} - #{Midwife::CODENAME}\" }"
    last_response.body.must_equal message
  end

  it "should output the kickstart file for a valid host" do
    get '/ks/other1.private'
    message = File.read("specs/files/results/other1.private.ks")
    last_response.body.must_equal message
  end

  it "should output the kickstart file for a valid host" do
    get '/ks/default1.local'
    message = File.read("specs/files/results/default1.local.ks")
    # last_response.body.must_equal message
    actual = last_response.body.gsub(/^rootpw.*$/, '')
    expected = File.read("specs/files/results/default1.local.ks").gsub(/^rootpw.*$/, '')
    actual.must_equal expected
  end

  it "should error for invalid host" do
    get '/ks/other2.private'
    message = "{ \"status\":\"404\", \"message\": \"not found\" }"
    last_response.body.must_equal message
  end

  it "should notify of a completed install" do
    get '/notify/other1.private/installed'
    message = "{ \"status\":\"200\", \"message\": \"OK\" }"
    last_response.body.must_equal message
    File.exists?("#{Midwife.configuration.pxe_path}/00-11-22-33-44-56").must_equal true
    File.read("#{Midwife.configuration.pxe_path}/00-11-22-33-44-56").must_equal File.read("specs/files/results/pxe.localboot")
  end

  it "should error for invalid host" do
    get '/notify/other2.private/installed'
    message = "{ \"status\":\"404\", \"message\": \"not found\" }"
    last_response.body.must_equal message
  end

  it "should notify of an install request" do
    get '/notify/other1.private/install'
    message = "{ \"status\":\"200\", \"message\": \"OK\" }"
    last_response.body.must_equal message
    File.exists?("#{Midwife.configuration.pxe_path}/00-11-22-33-44-56").must_equal true
    File.read("#{Midwife.configuration.pxe_path}/00-11-22-33-44-56").must_equal File.read("specs/files/results/pxe.install")
  end

  it "should error for invalid host" do
    get '/notify/other2.private/install'
    message = "{ \"status\":\"404\", \"message\": \"not found\" }"
    last_response.body.must_equal message
  end
end