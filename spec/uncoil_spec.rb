require 'spec_helper'

describe Uncoil do
  
  subject { Uncoil.new(:bitlyuser => CREDENTIALS['bitlyuser'], :bitlykey => CREDENTIALS['bitlykey'])}
  
  describe '#expand class method', :vcr => { :cassette_name => 'isgd_response' } do
    it 'should successfully return a response object' do
      Uncoil.expand('http://is.gd/gbKNRq').class.should eq Uncoil::Response
    end
    
    it "should bring back the correct link" do
      response = Uncoil.expand('http://is.gd/gbKNRq')
      response.long_url.should eq "http://www.google.com"
    end
  end
  
  describe "#expand instance method" do
    
    it "should raise an error for non-urls" do
      subject.expand("a").error.should_not be_nil
    end
    
    def check_response(response, expected_result)
      response.long_url.should eq expected_result[:long_url]
      response.short_url.should eq expected_result[:short_url]
      response.error.should eq expected_result[:error]
    end
    
    context 'for bitly api', :vcr => { :cassette_name => 'bitly_api' } do
      
      it 'should expand bitly correctly' do
        expected_result = Hash[:long_url => 'http://www.cnn.com/', :short_url => 'http://bit.ly/2EEjBl', :error => nil]
        response = subject.expand('http://bit.ly/2EEjBl')
        check_response response, expected_result
      end
    
      it 'should expand bitlypro domains correctly' do
        expected_result = Hash[:long_url => 'http://www.c-spanvideo.org/program/CainNew', :short_url => 'http://cs.pn/vsZpra', :error => nil]
        response = subject.expand('http://cs.pn/vsZpra')
        check_response response, expected_result
      end
    end

    context 'for isgd api', :vcr => { :cassette_name => 'isgd_api' } do
      it 'should expand isgd domains correctly' do
        expected_result = Hash[:long_url => 'http://www.google.com', :short_url => 'http://is.gd/gbKNRq', :error => nil]
        response = subject.expand('http://is.gd/gbKNRq')
        check_response response, expected_result
      end
    end

    context 'for other requests' do
      it 'should expand other shortened urls correctly' do
        expected_result = Hash[:long_url => 'http://paulgraham.com/', :short_url => 'http://tinyurl.com/p8o2', :error => nil]
        response = subject.expand('http://tinyurl.com/p8o2')
        check_response response, expected_result
      end

      it 'should expand https urls correctly' do
        expected_result = Hash[:long_url => 'https://www.facebook.com/photo.php?fbid=436380063146407&l=7554e08219', :short_url => 'http://fb.me/6txI6APS5', :error => nil]
        response = subject.expand('http://fb.me/6txI6APS5')
        check_response response, expected_result
      end
    end
    
    describe 'with an array input', :vcr => { :cassette_name => 'array_of_links' } do
        
        arr_of_links = %w[http://bit.ly/2EEjBl http://is.gd/gbKNRq http://cs.pn/vsZpra]
        
        let(:resp) {subject.expand(arr_of_links) }
        
        it 'should return an array' do
          resp.class.should eq Array
        end
        
        it 'should return an array of response objects' do
          resp.each { |r| r.class.should eq Uncoil::Response }
        end
        
        it 'should successfully expand all links' do
          @expected_result = [Hash[:long_url => 'http://www.cnn.com/', :short_url => 'http://bit.ly/2EEjBl', :error => nil],
                              Hash[:long_url => 'http://www.google.com', :short_url => 'http://is.gd/gbKNRq', :error => nil],
                              Hash[:long_url => 'http://www.c-spanvideo.org/program/CainNew', :short_url => 'http://cs.pn/vsZpra', :error => nil]]
          resp.each_with_index { |response, index|
            check_response(response, @expected_result[index])
            }
      end
    end
  end
end
