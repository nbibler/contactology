# encoding: UTF-8

require 'spec_helper'

describe Contactology::SendResult do
  let(:result) { new_result }
  subject { result }

  context '#successful?' do
    context 'when success is true' do
      subject { result.successful? }

      it { should be_true }
    end

    context 'when success is false' do
      let(:result) { new_result default_options.merge('success' => false) }
      subject { result.successful? }

      it { should be_false }
    end
  end

  context '#issues' do
    context 'with no issues given' do
      let(:result) { new_result 'success' => true }
      subject { result.issues }

      it { should be_kind_of Contactology::Issues }
      it { should be_empty }
      its(:score) { should == 0 }
    end

    context 'with issues given' do
      let(:result) { new_result default_options.merge('issues' => {'issues' => [{'text' => 'Test Issue'}]}) }
      subject { result.issues }

      it 'contains the issues' do
        subject.any? { |i| i.text == 'Test Issue' }.should be_true
      end
    end
  end

  context '#score' do
    it 'returns the issues score' do
      subject.score.should == default_options['issues']['score']
    end
  end


  private


  def default_options
    {
      'success' => true,
      'issues' => {
        'score' => 100,
        'issues' => []
      }
    }
  end

  def new_result(options = default_options)
    Contactology::SendResult.new options
  end
end
