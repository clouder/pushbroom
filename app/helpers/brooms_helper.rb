module BroomsHelper
  def stale_email_count(broom)
    count = 0
    broom.labels.each do |l|
      count += @gmail.label(l).find(:before => broom.date).count
    end
    count
  end

  def period_number(broom)
    if broom.new_record?
      broom.number
    else
      broom.period.split('.').first
    end
  end

  def period_unit(broom)
    if broom.new_record?
      broom.unit
    else
      broom.period.split('.').last
    end
  end
end
