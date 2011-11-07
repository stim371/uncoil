require_relative 'spec_helper'
require_relative '../lib/uncoil.rb'

describe Uncoil do
  
  context "when expanding any link" do
    
    it "should throw an error if any method can't resolve the address" do
      fail
    end
    
  end
  
  context "when cleaning up the url" do
    
    it "should add the prefix if none exists" do
      Uncoil.expand("cnn.com").should eq "http://cnn.com"
      Uncoil.expand("cnn.com/").should eq "http://cnn.com"
    end
    
    it "should not add the prefix if one exists" do
      Uncoil.expand("http://cnn.com").should eq "http://cnn.com"
      Uncoil.expand("http://cnn.com/").should eq "http://cnn.com"
    end
    
    it "should not add the prefix if a secure one exists" do
      Uncoil.expand("https://cnn.com").should eq "https://cnn.com"
      Uncoil.expand("https://cnn.com/").should eq "https://cnn.com"
    end
    
    it "should remove the trailing slash" do
      Uncoil.expand("http://cnn.com/").should eq "http://cnn.com"
      Uncoil.expand("cnn.com/").should eq "http://cnn.com"
    end
    
    it "should not remove characters on the end that aren't slashes" do
      Uncoil.expand("http://cnn.com").should eq "http://cnn.com"
      Uncoil.expand("cnn.com").should eq "http://cnn.com"
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
      fail
      #Uncoil.uncoil_bitly("").should eq ""
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
      Uncoil.uncoil_isgd("http://is.gd/5JJNDX").should eq "http://www.google.com"
    end
    
  end
  
  context "when trying to undo from other services" do
    
    # it "should encode the url" do
    #   fail
    # end
    
    it "should bring back the correct long link" do
      fail
    end
    
    it "should go until it gets a 200 response" do
      fail
    end
    
    it "should catch socket errors for non links" do
      fail
    end
    
  end
  
end