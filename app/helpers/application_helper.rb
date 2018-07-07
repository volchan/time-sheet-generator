module ApplicationHelper
  def build_row_array(date, sheet)
    date.saturday? || date.sunday? ? weekend_array(date) : week_array(date, sheet)
  end

  def weekend_array(date)
    [
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
      ], %I[
        date
        string
        string
        string
        string
        string
        string
        string
        string
        string
      ]
    ]
  end

  def week_array(date, sheet)
    index = sheet.rows.last.row_index + 2
    [
      [
        date,
        '00:00:00',
        '00:00:00',
        '00:00:00',
        '00:00:00',
        "=TEXT((E#{index}-B#{index}-D#{index}+C#{index}),\"HH:MM:SS\")",
        '07:30:00',
        '00:00:00',
        '00:00:00',
        "=F#{index}-(H#{index}+I#{index})"
      ], %I[
        date
        time
        time
        time
        time
        string
        time
        time
        time
        string
      ]
    ]
  end

  def overtime_row(dates, date_index, sheet)
    week_days = count_weekdays(dates, date_index - 1)
    cell_array = build_cell_array(week_days, sheet)
    [
      "Total H Supp semain #{dates[date_index - 1].cweek}",
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      "=SUM(#{cell_array.join(',')})*24-35",
      "=IF(J16 > 8, (((J16 - 8)  * 1,5) +  (8  * 1,25)), IF( J16 >= 0,  (J16  * 1,25), J16 ))"
    ]
  end

  def count_weekdays(dates, index)
    dates.select do |date|
      date.cweek == dates[index].cweek
    end.length
  end

  def build_cell_array(week_days, sheet)
    index = sheet.rows.last.row_index
    array = []
    week_days.times do |i|
      array << "J#{index - i + 1}"
    end
    array.reverse
  end
end
