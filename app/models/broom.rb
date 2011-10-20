class Broom < ActiveRecord::Base
  belongs_to :user

  attr_accessor :number, :unit
  attr_accessible :number, :unit, :labels

  validates :user, :number, :unit, :labels, :presence => true
  validates :number, :format => { :with => /^[1-9]+\d*$/ }
  validates :unit, :inclusion => { :in => %w{ days weeks months years } }
  validate do
  	errors.add(:base, 'Wtf yo!?') unless self.labels.is_a?(Array)
  end

  after_validation :set_period, :tidy_up_labels, :if => lambda { |b| b.errors.empty? }

  private

  def set_period
  	self.period = "#{self.number}.#{self.unit}"
  end

  def tidy_up_labels
  	self.labels.uniq!
  	self.labels.delete_if { |l| l.blank? }
  end
end
