require 'spec_helper'

describe Broom do
	before :each do
		@broom = Broom.new
		@broom.user = mock_model(User)
		@attrs = { :number => 5, :unit => 'days', :labels => %w{ work play }}
	end

  it 'should respond to Broom#number' do
		@broom.should respond_to(:number), 'Broom has no number attribute'
  end

  it 'should respond to Broom#unit' do
		@broom.should respond_to(:unit), 'Broom has no unit attribute'
  end

  it 'should belong to a user' do
		@broom.should respond_to(:user), 'Broom is unable to belong to a user'
  end

  it 'should be invalid when missing everything' do
  	@broom.should_not be_valid
  end

  it 'should be invalid when only given a user' do
  	@broom.should_not be_valid
  end

  it 'should be invalid when only given a number' do
  	@broom.number = 5
  	@broom.should_not be_valid
  end

  it 'should be invalid when only given a unit' do
  	@broom.unit = 'days'
  	@broom.should_not be_valid
  end

  it 'should be invalid when missing user' do
  	@broom.attributes = @attrs
  	@broom.user = nil
  	@broom.should_not be_valid
  end

  it 'should be invalid when missing number' do
  	@broom.attributes = @attrs
  	@broom.number = nil
  	@broom.should_not be_valid
  end
  
  it 'should be invalid when missing unit' do
  	@broom.attributes = @attrs
  	@broom.unit = nil
  	@broom.should_not be_valid
  end

  it 'should be invalid if number a decimal' do
  	@broom.attributes = @attrs
  	@broom.number = 2.5
  	@broom.should_not be_valid
  end

  it 'should be invalid if number is negative' do
  	@broom.attributes = @attrs
  	@broom.number = -5
  	@broom.should_not be_valid
  end

  it 'should be invalid if number is 0' do
  	@broom.attributes = @attrs
  	@broom.number = 0
  	@broom.should_not be_valid
  end

  it 'should be invalid if unit is not [days, weeks, months, years]' do
  	@broom.attributes = @attrs
  	@broom.unit = 'eval()'
  	@broom.should_not be_valid, 'Broom.unit was valid with something funky'
  	@broom.unit = 'hours'
  	@broom.should_not be_valid, 'Broom.unit was valid with an unsupported unit'
  end

  it 'should be invalid if labels is missing' do
  	@broom.attributes = @attrs
  	@broom.labels = nil
  	@broom.should_not be_valid
  end

  it 'should be invalid if labels is not an array' do
  	@broom.attributes = @attrs
  	@broom.labels = 'wtf!?'
  	@broom.should_not be_valid, 'Broom.labels was valid with a string'
  	@broom.labels = 5
  	@broom.should_not be_valid, 'Broom.labels was valid with a number'
  	@broom.labels = { :mail => 'box' }
  	@broom.should_not be_valid, 'Broom.labels was valid with a hash'
  end

  it 'should be valid with sensible values' do
  	@broom.attributes = @attrs
  	@broom.should be_valid
  end

  it 'should set the period attribute when validation passes' do
  	@broom.attributes = @attrs
  	@broom.valid?
  	@broom.period.should eq('5.days'), 'Broom.period was not "5.days"'
  end

  it 'should tidy up :labels when validation passes' do
  	@broom.attributes = @attrs
  	@broom.labels.push('work').push('').push('play')
  	@broom.valid?
  	@broom.labels.should =~ (%w{ work play })
  end

  it 'should only allow :number, :unit, and :labels to be massively assigned' do
		whitelist = Broom.accessible_attributes
		whitelist.include?(:number).should be_true, 'Broom.number was not found in accessible whitelist'
		whitelist.include?(:unit).should be_true, 'Broom.unit was not found in accessible whitelist'
		whitelist.include?(:labels).should be_true, 'Broom.labels was not found in accessible whitelist'
		whitelist.include?(:period).should be_false, 'Broom.period was found in accessible whitelist'
  end
end
