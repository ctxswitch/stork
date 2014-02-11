require File.dirname(__FILE__) + '/spec_helper'

include Rack::Test::Methods

def app
  Midwife::Server::Application
end

describe "Midwife::Server::Application" do
  it "should respond to the root" do
    get '/'
    message = "{ \"status\":\"200\", \"message\": \"Midwife Version #{Midwife::VERSION} - #{Midwife::CODENAME}\" }"
    assert_equal message, last_response.body
  end

  it "should output the kickstart file for a valid host" do
    get '/ks/other1.private'
    message = File.read("specs/files/results/other1.private.ks")
    assert_equal message, last_response.body
  end

  it "should error for invalid host" do
    get '/ks/other2.private'
    message = "{ \"status\":\"404\", \"message\": \"not found\" }"
    assert_equal message, last_response.body
  end
end