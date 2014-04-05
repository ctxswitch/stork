require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Password" do
  it "should generate a new password every time value is accessed" do
    password = Midwife::DSL::Password.new
    pass1 = password.value
    pass2 = password.value
    pass1.wont_equal pass2
  end
end
