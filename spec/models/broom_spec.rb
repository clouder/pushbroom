require 'spec_helper'

describe Broom do
	before :each do
		@broom = Broom.new
	end

  it 'has a number attribute' do
    @broom.should respond_to :number
  end

  it 'has a unit attribute' do
    @broom.should respond_to :unit
  end

  it 'has a user' do
    @broom.should respond_to :user
  end

  context 'when missing number, unit, or labels, user' do
    before :each do
      @broom.valid?
    end

    it 'is invalid' do
      @broom.should_not be_valid
    end

    it 'has an error on number' do
      @broom.errors.get(:number).should be
    end

    it 'has an error on unit' do
      @broom.errors.get(:unit).should be
    end

    it 'has an error about picking labels' do
      @broom.errors.get(:base).should include 'You forgot to pick some labels'
    end

    it 'has an error on user' do
      @broom.errors.get(:user).should be
    end
  end

  context 'when number is not a natural number' do
    [0, 1.1, -2, 'three'].each do |value|
      it 'it not valid' do
        @broom.number = value
        @broom.should_not be_valid
      end

      it 'has an error about format' do
        @broom.number = value
        @broom.valid?
        @broom.errors.get(:number).should include 'is invalid'
      end
    end
  end

  context 'when unit is not in [days, weeks, months, years]' do
    [0, [], 'hours', 'eval()'].each do |value|
      it 'is not valid' do
        @broom.unit = value
        @broom.should_not be_valid
      end

      it 'has an error about unit not being supported' do
        @broom.unit = value
        @broom.valid?
        @broom.errors.get(:unit).should include "#{value} is not a supported duration"
      end
    end
  end

  context 'when label is not an array' do
    [0, 1.1, 'two', {}].each do |value|
      it 'is not valid' do
        @broom.labels = value
        @broom.should_not be_valid
      end

      it 'has an about picking labels' do
        @broom.labels = value
        @broom.valid?
        @broom.errors.get(:base).should include 'You forgot to pick some labels'
      end
    end
  end

  context 'given proper values' do
    before :each do
      @broom.user = mock_model User
      @broom.attributes = { :number => 5, :unit => 'days', :labels => %w( work play ) }
      @broom.valid?
    end

    it 'is valid' do
      @broom.should be_valid
    end

    it 'sets the period attribute' do
      @broom.period.should eq('5.days'), 'Broom.period was not "5.days"'
    end

    it 'cleans up duplicate and blank labels' do
      @broom.labels += ['work', 'play', '', '  ']
      @broom.valid?
      @broom.labels.should =~ (%w{ work play })
    end
  end

  context 'when massively setting a protected attribute' do
    it 'does not set that attribute' do
      @broom.attributes = { :period => 'eval()' }
      @broom.period.should_not be
    end
  end
end
