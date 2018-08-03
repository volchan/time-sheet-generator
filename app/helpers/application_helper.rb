module ApplicationHelper
  def build_row_array(date, sheet)
    date.saturday? || date.sunday? ? weekend_array(date, sheet) : week_array(date, sheet)
  end

  def weekend_array(date, sheet)
    cells = [
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
    sheet.add_row(cells)
  end

  def week_array(date, sheet)
    index = sheet.rows.last.row_index + 2
    cells = [
      date.strftime('%d/%m/%Y'),
      '00:00',
      '00:00',
      '00:00',
      '00:00',
      "=IF(A#{index}<>\"\",E#{index}-B#{index}-D#{index}+C#{index},\"\")",
      '07:30',
      '00:00',
      '00:00',
      "=F#{index}-(H#{index}+I#{index})"
    ]
    hrs = sheet.styles.add_style(format_code: 'h:mm')
    sheet.add_row(cells, style: hrs)
  end

  def overtime_row(dates, date_index, sheet)
    days = count_days(dates, date_index - 1)
    cell_array = build_cell_array(days, sheet)
    weekdays = count_weekdays(dates, date_index - 1)
    index = sheet.rows.last.row_index + 2
    cells = [
      "Total H Supp semaine #{dates[date_index - 1].cweek}",
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      "=SUM(#{cell_array.join(',')})*24-#{weekdays * 7}",
      "=IF(J#{index} > 8, (((J#{index} - 8)  * 1.5) + (8  * 1.25)), IF( J#{index} >= 0, (J#{index}  * 1.25), J#{index}))"
    ]
    sheet.add_row(cells)
  end

  def count_days(dates, index)
    dates.select do |date|
      date.cweek == dates[index].cweek
    end.length
  end

  def count_weekdays(dates, index)
    dates.select do |date|
      next if date.saturday? || date.sunday?
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
