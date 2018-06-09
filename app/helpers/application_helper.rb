module ApplicationHelper
  def build_row_array(dates)
    dates.map do |date|
      date.saturday? || date.sunday? ? weekend_array(date) : week_array(date)
    end
  end

  def weekend_array(date)
    [
      date,
      'Week-end',
      'Week-end',
      'Week-end',
      'Week-end',
      'Week-end',
      'Week-end',
      'Week-end',
      'Week-end',
      'Week-end'
    ]
  end

  def week_array(date)
    [
      date,
      '00:00:00',
      '00:00:00',
      '00:00:00',
      '00:00:00'
    ]
  end
end
