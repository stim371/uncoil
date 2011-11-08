#require_relative 'spec_helper'
require_relative '../lib/uncoil.rb'

describe Uncoil do
  
  context "when expanding any link" do
    
    it "should throw an error if any method can't resolve the address" do
      fail
    end
    
    it "should not allow access to the bitly-focused methods without an api key" do
      fail
    end
    
  end
  
  context "when cleaning up the url" do
    
    it "should add the prefix if none exists" do
      Uncoil.clean_url("cnn.com").should eq "http://cnn.com"
      Uncoil.clean_url("cnn.com/").should eq "http://cnn.com"
    end
    
    it "should not add the prefix if one exists" do
      Uncoil.clean_url("http://cnn.com").should eq "http://cnn.com"
      Uncoil.clean_url("http://cnn.com/").should eq "http://cnn.com"
    end
    
    it "should not add the prefix if a secure one exists" do
      Uncoil.clean_url("https://cnn.com").should eq "https://cnn.com"
      Uncoil.clean_url("https://cnn.com/").should eq "https://cnn.com"
    end
    
    it "should remove the trailing slash" do
      Uncoil.clean_url("http://cnn.com/").should eq "http://cnn.com"
      Uncoil.clean_url("cnn.com/").should eq "http://cnn.com"
    end
    
    it "should not remove characters on the end that aren't slashes" do
      Uncoil.clean_url("http://cnn.com").should eq "http://cnn.com"
      Uncoil.clean_url("cnn.com").should eq "http://cnn.com"
    end
    
  end
  
  context "when extracting the domain" do
  
    it "should correctly extract the domain from a normal url" do
      Uncoil.identify_domain("http://bit.ly/2EEjBl").should eq "bit.ly"
    end
    
    it "should throw an error if the url is too short" do
      Uncoil.identify_domain("bit.ly").should raise_error
    end
  
  end
  
  context "when checking a domain" do
    
    it "should identify pro domains" do
      Uncoil.check_bitly_pro("cs.pn").should be_true
      Uncoil.check_bitly_pro("nyti.ms").should be_true
    end
    
    it "should identify non-pro domains" do
      Uncoil.check_bitly_pro("bit.ly").should be_false #the bit.ly domain comes back false since its not a "pro" domain
      Uncoil.check_bitly_pro("tinyurl.com").should be_false
    end
    
  end
  
  describe "when using the submethods" do
    
    context "when trying to undo a bit.ly link" do
    
      # it "should encode the url" do
      #   fail
      # end
    
      it "should bring back the correct long link" do
        Uncoil.uncoil_bitly("http://bit.ly/2EEjBl").should eq "http://www.cnn.com/"
      end
    
      it "should catch errors for broken links" do
        fail
      end
    
    end
  
    context "when trying to undo a bit.ly pro link" do
    
      it "should bring back the correct long link" do
        Uncoil.uncoil_bitly("http://cs.pn/vsZpra").should eq "http://www.c-spanvideo.org/program/CainNew"
      end
    
      it "should catch errors for broken links" do
        fail
      end
    
    end
  
    context "when trying to undo an is.gd link" do
    
      # it "should encode the url" do
      #   fail
      # end
    
      it "should bring back the correct long link" do
        Uncoil.uncoil_isgd("http://is.gd/gbKNRq").should eq "http://www.google.com"
      end
    
    end
  
    context "when trying to undo from other services" do
    
      # it "should encode the url" do
      #   fail
      # end
    
      it "should bring back the correct long link" do
         Uncoil.uncoil_other("http://tinyurl.com/736swvl").should eq "http://www.chinadaily.com.cn/usa/business/2011-11/08/content_14057648.htm"
      end
    
      it "should catch socket errors for non links" do
        fail
      end
    
    end
  end
  
  context "when using the main expand method" do
    
    it "should expand bitly correctly" do
      Uncoil.expand("http://bit.ly/2EEjBl").should eq "http://www.cnn.com/"
    end
    
    it "should expand bitlypro domains correctly" do
      Uncoil.expand("http://cs.pn/vsZpra").should eq "http://www.c-spanvideo.org/program/CainNew"
    end
    
    it "should expand isgd domains correctly" do
      Uncoil.expand("http://is.gd/gbKNRq").should eq "http://www.google.com"
    end
    
    it "should expand other shortened urls correctly" do
      Uncoil.expand("http://tinyurl.com/736swvl").should eq "http://www.chinadaily.com.cn/usa/business/2011-11/08/content_14057648.htm"
    end
    
  end
  
end