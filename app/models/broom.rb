class Broom < ActiveRecord::Base
  belongs_to :user

  attr_accessor :number, :unit
  attr_accessible :number, :unit, :labels
  serialize :labels

  validates :user, :number, :unit, :presence => true
  validates :number, :format => { :with => /^[1-9]+\d*$/ }
  validates :unit, :inclusion => { :in => %w{ days weeks months years } }
  validate do
  	errors.add(:base, 'Wtf yo!?') unless self.labels.is_a?(Array)
    errors.add(:base, 'You forgot to pick some labels') if self.labels.empty?
  end

  before_validation :tidy_up_labels
  after_validation :set_period, :if => lambda { |b| b.errors.empty? }

  def hperiod
    self.period.gsub('.', ' ')
  end

  def date
    eval(period).ago.strftime('%Y/%m/%d')
  end

  private

  def set_period
  	self.period = "#{self.number}.#{self.unit}"
  end

  def tidy_up_labels
    self.labels = [] unless self.labels.is_a?(Array)
  	self.labels.uniq!
  	self.labels.delete_if { |l| l.blank? }
  end
end
