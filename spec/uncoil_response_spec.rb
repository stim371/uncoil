require 'spec_helper'
require 'uncoil'

describe "the response object", :vcr => { :cassette_name => "isgd_response" } do
  
  subject { Uncoil.expand("http://is.gd/gbKNRq") }
  
  it "should return a response object" do
    subject.class.should eq Uncoil::Response
  end
  
  it "should respond to getter methods" do
    lambda{subject.long_url}.should_not raise_error
    lambda{subject.short_url}.should_not raise_error
    lambda{subject.error}.should_not raise_error
  end
  
  it "should throw errors for unrecognized methods" do
    # not sure if I really need this
    lambda{subject.not_a_method}.should raise_error
  end
  
end