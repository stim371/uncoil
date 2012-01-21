require 'uncoil'

describe Uncoil do
  
  subject { Uncoil.new(:bitlyuser => "stim371", :bitlykey => "R_7a6f6d845668a8a7bb3e0c80ee3c28d6")}
  
  context "when cleaning up the url" do
    
    it "should add the prefix if none exists" do
      subject.clean_url("cnn.com").should eq "http://cnn.com"
      subject.clean_url("cnn.com/").should eq "http://cnn.com"
    end
    
    it "should not add the prefix if one exists" do
      subject.clean_url("http://cnn.com").should eq "http://cnn.com"
      subject.clean_url("http://cnn.com/").should eq "http://cnn.com"
    end
    
    it "should not add the prefix if a secure one exists" do
      subject.clean_url("https://cnn.com").should eq "https://cnn.com"
      subject.clean_url("https://cnn.com/").should eq "https://cnn.com"
    end
    
    it "should remove the trailing slash" do
      subject.clean_url("http://cnn.com/").should eq "http://cnn.com"
      subject.clean_url("cnn.com/").should eq "http://cnn.com"
    end
    
    it "should not remove characters on the end that aren't slashes" do
      subject.clean_url("http://cnn.com").should eq "http://cnn.com"
      subject.clean_url("cnn.com").should eq "http://cnn.com"
    end
    
  end
  
  context "when extracting the domain" do
  
    it "should correctly extract the domain from a normal url" do
      subject.identify_domain("http://bit.ly/2EEjBl").should eq "bit.ly"
    end
  
  end
  
  context "when checking a domain" do
    
    it "should identify pro domains" do
      subject.check_bitly_pro("cs.pn").should be_true
      subject.check_bitly_pro("nyti.ms").should be_true
    end
    
    it "should identify non-pro domains" do
      subject.check_bitly_pro("bit.ly").should be_false #the bit.ly domain comes back false since its not a "pro" domain
      subject.check_bitly_pro("tinyurl.com").should be_false
    end
    
  end
  
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
  
  context "the main expand method" do
    
    it "should return a response object" do
      subject.expand("http://is.gd/gbKNRq").class.should eq Uncoil::Response
    end
    
    it "should raise an error for non-urls" do
      subject.expand("a").error.should_not be_nil
    end
    
    context "and when expanding a link" do
      
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