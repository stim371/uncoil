require 'spec_helper'
require 'uncoil'

describe "the response object" do
  
  subject { Uncoil.new(:bitlyuser => "stim371", :bitlykey => "R_7a6f6d845668a8a7bb3e0c80ee3c28d6")}
  
  before(:all) {
    @subject = subject.expand("http://is.gd/gbKNRq")
  }
  
  it "should return a response object" do
    @subject.class.should eq Uncoil::Response
  end
  
  it "should respond to getter methods" do
    @subject.long_url.should_not eq nil
    @subject.short_url.should_not eq nil
  end
  
end