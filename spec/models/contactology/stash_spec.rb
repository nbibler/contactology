require 'spec_helper'

describe Contactology::Stash do
  class Stashie < Contactology::Stash
    property :id
    property :name, :from => :stashName
    property :value, :required => true
  end

  context 'given defined properties' do
    subject { new_stashie }

    it { should be_instance_of Stashie }
    its(:id) { should == 1 }
    its(:name) { should == 'stashie' }
    its(:value) { should == 2 }
  end

  context 'missing a required property' do
    subject { new_stashie :id => 1 }

    it 'raises an ArgumentError for the missing property' do
      expect { subject }.to raise_error(ArgumentError, "The property 'value' is required for this Dash.")
    end
  end

  context 'given fewer than the defined attributes' do
    subject { new_stashie :value => 3.00 }

    it { should be_instance_of Stashie }
    its(:id) { should be_nil }
    its(:name) { should be_nil }
    its(:value) { should == 3 }
  end

  context 'given more than the defined attributes' do
    subject { Stashie.new :value => 1, :unknown => true }

    it { should be_instance_of Stashie }

    it 'raises NoMethodError for undefined property' do
      expect { subject.unknown }.to raise_error(NoMethodError)
    end

    its(:id) { should be_nil }
    its(:name) { should be_nil }
    its(:value) { should == 1 }
  end


  private


  def default_attributes
    {
      :id => 1,
      :name => 'stashie',
      :value => 2.00
    }
  end

  def new_stashie(attributes = default_attributes)
    Stashie.new(attributes)
  end
end
