require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Resource::Password" do
  it "should generate a new password every time value is accessed" do
    password = Stork::Resource::Password.new
    pass1 = password.value
    pass2 = password.value
    pass1.wont_equal pass2
  end
end
