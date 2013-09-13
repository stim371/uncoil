require 'spec_helper'

describe DomainFinder do
  it 'should return the host from a url' do
    subject.domain_for('http://bit.ly/abcde13').should eq :bitly
    subject.domain_for('http://tinyurl.com/abcde13').should eq 'tinyurl.com'
  end

  it 'should raise error if url empty' do
    lambda{ subject.domain_for(nil) }.should raise_error
  end
end
