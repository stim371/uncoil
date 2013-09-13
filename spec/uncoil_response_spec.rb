require 'spec_helper'

describe Uncoil::Response, :vcr => { :cassette_name => 'isgd_response' } do
  
  subject { Uncoil.expand('http://is.gd/gbKNRq') }
  
  it 'should return a response object' do
    subject.class.should eq Uncoil::Response
  end
  
  it 'should respond to getter methods' do
    lambda{subject.long_url}.should_not raise_error
    lambda{subject.short_url}.should_not raise_error
    lambda{subject.error}.should_not raise_error
  end

  describe 'response body' do
    it 'should assign variables correctly' do
      subject.long_url.should eq 'http://www.google.com'
      subject.short_url.should eq 'http://is.gd/gbKNRq'
      subject.error.should be_nil
    end
  end
end
