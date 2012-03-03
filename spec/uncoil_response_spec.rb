require 'spec_helper'
require 'uncoil'

describe "the response object" do
  
  subject { Uncoil.new(:bitlyuser => CREDENTIALS['bitlyuser'], :bitlykey => CREDENTIALS['bitlykey'])}
  
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