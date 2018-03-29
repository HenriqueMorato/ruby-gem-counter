require 'rails_helper'

RSpec.describe GemfileReader do
  describe '#execute' do
    let(:gemfile) { File.read(Rails.root.join('spec', 'fixtures', 'gemfile')) }

    subject { described_class.new(gemfile).execute }

    context 'when all gems are included by the first time' do
      it 'should return jewels(gems)' do
        expect(subject.class).to be Array
        expect(subject.count).to eq 19
      end

      it 'should create the jewels' do
        subject
        jewels = Jewel.all
        expect(jewels.count).to eq 19
      end
    end

    context 'when a gem already have a count' do
      before do
        FactoryBot.create(:jewel, name: 'rails', count: 1)
        subject
      end

      it 'rails count should be 2' do
        rails_gem = Jewel.find_by(name: 'rails')
        expect(rails_gem.count).to eq 2
      end
    end
  end
end
