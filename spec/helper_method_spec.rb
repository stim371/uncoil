require 'spec_helper'
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
end
