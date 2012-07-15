require 'spec_helper'
require 'uncoil'

describe Uncoil do
  
  subject { Uncoil.new(:bitlyuser => CREDENTIALS['bitlyuser'], :bitlykey => CREDENTIALS['bitlykey'])}
  
  describe "#expand class method", :vcr => { :cassette_name => "class_method" } do
    it "should successfully return a response object" do
      Uncoil.expand("http://tinyurl.com/736swvl").class.should eq Uncoil::Response
    end
    
    it "should bring back the correct link" do
      response = Uncoil.expand("http://tinyurl.com/736swvl")
      response.long_url.should eq "http://www.chinadaily.com.cn/usa/business/2011-11/08/content_14057648.htm"
    end
  end
  
  describe "when using the submethods", :vcr => { :cassette_name => "submethod_requests" } do
    
    context "when trying to undo a bit.ly and bit.ly pro link", :vcr => { :cassette_name => "bitly_and_pro_links" } do
      it "should bring back the correct long link" do
        {"http://bit.ly/2EEjBl" => "http://www.cnn.com/", "http://cs.pn/vsZpra" => "http://www.c-spanvideo.org/program/CainNew" }.each { |short_url, long_url| 
        subject.uncoil_bitly(short_url).should eq long_url
        }
      end
    end
  
    context "when trying to undo an is.gd link" do
      it "should bring back the correct long link" do
        subject.uncoil_isgd("http://is.gd/gbKNRq").should eq "http://www.google.com"
      end
    end
  
    context "when trying to undo from other services" do
      it "should bring back the correct long link" do
         subject.uncoil_other("http://tinyurl.com/736swvl").should eq "http://www.chinadaily.com.cn/usa/business/2011-11/08/content_14057648.htm"
      end
    end
  end
  
  describe "the main expand method" do
    
    it "should raise an error for non-urls" do
      subject.expand("a").error.should_not be_nil
    end
    
    def check_response(response, expected_result)
      response.long_url.should eq expected_result[:long_url]
      response.short_url.should eq expected_result[:short_url]
      response.error.should eq expected_result[:error]
    end
    
    context "when expanding a single link", :vcr => { :cassette_name => "main_instance_method" } do
      
      it "should expand bitly correctly" do
        expected_result = Hash[:long_url => "http://www.cnn.com/", :short_url => "http://bit.ly/2EEjBl", :error => nil]
        response = subject.expand("http://bit.ly/2EEjBl")
        check_response response, expected_result
      end
    
      it "should expand bitlypro domains correctly" do
        expected_result = Hash[:long_url => "http://www.c-spanvideo.org/program/CainNew", :short_url => "http://cs.pn/vsZpra", :error => nil]
        response = subject.expand("http://cs.pn/vsZpra")
        check_response response, expected_result
      end
    
      it "should expand isgd domains correctly" do
        expected_result = Hash[:long_url => "http://www.google.com", :short_url => "http://is.gd/gbKNRq", :error => nil]
        response = subject.expand("http://is.gd/gbKNRq")
        check_response response, expected_result
      end
    
      it "should expand other shortened urls correctly" do
        expected_result = Hash[:long_url => "http://www.chinadaily.com.cn/usa/business/2011-11/08/content_14057648.htm", :short_url => "http://tinyurl.com/736swvl", :error => nil]
        response = subject.expand("http://tinyurl.com/736swvl")
        check_response response, expected_result
      end
    end
    
    describe "with an array input", :vcr => { :cassette_name => "array_of_links" } do
        
        arr_of_links = ["http://bit.ly/2EEjBl","http://is.gd/gbKNRq","http://cs.pn/vsZpra"]
        
        subject { Uncoil.expand(arr_of_links) }
        
        it "should return an array" do
          subject.class.should eq Array
        end
        
        it "should return an array of response objects" do
          subject.each { |r| r.class.should eq Uncoil::Response }
        end
        
        it "should successfully expand all links" do
          @expected_result = [Hash[:long_url => "http://www.cnn.com/", :short_url => "http://bit.ly/2EEjBl", :error => nil], Hash[:long_url => "http://www.google.com", :short_url => "http://is.gd/gbKNRq", :error => nil],Hash[:long_url => "http://www.c-spanvideo.org/program/CainNew", :short_url => "http://cs.pn/vsZpra", :error => nil]]
          subject.each_with_index { |response, index|
            check_response(response, @expected_result[index])
            }
      end
    end
  end
end
