# encoding: UTF-8

require 'spec_helper'

describe Contactology::Issues do
  let(:issues) { Contactology::Issues.new }
  subject { issues }

  it 'is empty by default' do
    issues.should be_empty
  end

  it 'holds Contactology::Issue objects' do
    issues = Contactology::Issues.new('issues' => [attributes_for(:issue)])
    issues.should_not be_empty
    issues.all? { |i| i.kind_of?(Contactology::Issue) }.should be_true
  end

  it 'converts pushed objects to Issue instances' do
    expect {
      issues << attributes_for(:issue)
    }.to change(issues, :size).by(1)

    issues.all? { |i| i.kind_of? Contactology::Issue }.should be_true
  end

  context '#score' do
    it 'defaults to 0' do
      Contactology::Issues.new.score.should == 0
    end

    it 'may be set during initialization' do
      Contactology::Issues.new('score' => 95).score.should == 95
    end
  end
end
