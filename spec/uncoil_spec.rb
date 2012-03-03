require 'spec_helper'
require 'uncoil'

describe Uncoil do
  
  subject { Uncoil.new(:bitlyuser => CREDENTIALS['user'], :bitlykey => CREDENTIALS['bitlykey'])}
  
  describe "when using the submethods" do
    
    context "when trying to undo a bit.ly link" do
      it "should bring back the correct long link" do
        expected_result = "http://www.cnn.com/"
        subject.uncoil_bitly("http://bit.ly/2EEjBl").should eq expected_result
      end
    end
  
    context "when trying to undo a bit.ly pro link" do
      it "should bring back the correct long link" do
        expected_result = "http://www.c-spanvideo.org/program/CainNew"
        subject.uncoil_bitly("http://cs.pn/vsZpra").should eq expected_result
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
    
    context "when expanding a link" do
      
      def check_response response, expected_result
        response.long_url.should eq expected_result[:long_url]
        response.short_url.should eq expected_result[:short_url]
        response.error.should eq expected_result[:error]
      end
      
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
    
      context "with an array input" do
        
        before(:all) {
          arr_of_links = ["http://bit.ly/2EEjBl","http://is.gd/gbKNRq","http://cs.pn/vsZpra"]
          @response = subject.expand(arr_of_links)
          }
        
        it "should return an array" do
          @response.class.should eq Array
        end
        
        it "should return an array of response objects" do
          @response.each { |r| r.class.should eq Uncoil::Response }
        end
        
        it "should successfully expand all links" do
          @expected_result = [Hash[:long_url => "http://www.cnn.com/", :short_url => "http://bit.ly/2EEjBl", :error => nil], Hash[:long_url => "http://www.google.com", :short_url => "http://is.gd/gbKNRq", :error => nil],Hash[:long_url => "http://www.c-spanvideo.org/program/CainNew", :short_url => "http://cs.pn/vsZpra", :error => nil]]
          @response.each_with_index { |response_array, index| check_response response_array, @expected_result[index] }
        end
      end
    end
  end
end
