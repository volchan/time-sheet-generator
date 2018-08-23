module ApplicationHelper
  def build_row_array(date, sheet)
    date.saturday? || date.sunday? ? weekend_array(date, sheet) : week_array(date, sheet)
  end

  def weekend_array(date, sheet)
    index = get_index(sheet)
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
    sheet.add_style("A#{index}:J#{index}", b: true, bg_color: 'a8a8a8', fg_color: 'ffffff', alignment: { horizontal: :center, vertical: :center }, border: { color: '000000', name: %I[vertical horizontal], style: :thin })
    sheet.add_style("A#{index}", format_code: 'dd/mm/yyyy')
  end

  def week_array(date, sheet)
    index = get_index(sheet)
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
    sheet.add_style("A#{index}:J#{index}", alignment: { horizontal: :center, vertical: :center }, border: { color: '000000', name: %I[vertical horizontal], style: :thin })
    sheet.add_style("A#{index}", b: true)
    sheet.add_style("F#{index}", b: true)
    sheet.add_style("J#{index}", b: true)
    sheet.rows.last.height = 18
  end

  def overtime_row(dates, date_index, sheet)
    days = count_days(dates, date_index - 1)
    cell_array = build_cell_array(days, sheet)
    weekdays = count_weekdays(dates, date_index - 1)
    index = get_index(sheet)
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
    sheet.add_style("A#{index}:I#{index}", b: true, sz: 16, bg_color: '606060', fg_color: 'ffffff', alignment: { horizontal: :left, vertical: :center }, border: { color: '000000', name: %I[vertical horizontal], style: :thin })
    sheet.merge_cells("A#{index}:I#{index}")
    sheet.add_style("J#{index}", b: true, sz: 16, bg_color: '33adea', alignment: { horizontal: :center, vertical: :center }, border: { color: '000000', name: %I[vertical horizontal], style: :thin })
    sheet.add_style("K#{index}", b: true, sz: 16, bg_color: 'f98639', alignment: { horizontal: :center, vertical: :center }, border: { color: '000000', name: %I[vertical horizontal], style: :thin })
    sheet.rows.last.height = 25
    @overtime_cells << "J#{index}"
    @majored_overtime_cells << "K#{index}"
  end

  def last_month_overtime_row(sheet)
    index = get_index(sheet)
    cells = [
      '',
      'Heures supplémentaires restantes du mois précédent',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '0'
    ]
    sheet.add_row(cells)
    sheet.merge_cells("B#{index}:I#{index}")
    sheet.add_style("B#{index}", sz: 16, b: true, alignment: { horizontal: :right, vertical: :center })
    sheet.add_style("J#{index}", sz: 16, b: true, alignment: { horizontal: :center, vertical: :center }, border: { color: '000000', name: %I[vertical horizontal], style: :thin })
    sheet.rows.last.height = 25
    @last_month_overtime_cell = "J#{index}"
  end

  def this_month_overtime_row(sheet)
    index = get_index(sheet)
    cells = [
      '',
      'Heures supplémentaires',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      "=SUM(#{@overtime_cells.join(',')})"
    ]
    sheet.add_row(cells)
    sheet.merge_cells("B#{index}:I#{index}")
    sheet.add_style("B#{index}", sz: 16, b: true, alignment: { horizontal: :right, vertical: :center })
    sheet.add_style("J#{index}", sz: 16, b: true, bg_color: '33adea', alignment: { horizontal: :center, vertical: :center }, border: { color: '000000', name: %I[vertical horizontal], style: :thin })
    sheet.rows.last.height = 25
  end

  def this_month_majored_overtime_row(sheet)
    index = get_index(sheet)
    cells = [
      '',
      'Heures supplémentaires majorées ( 25% jusqu\'à 8h, 50% au dela de 8h)',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      "=SUM(#{@majored_overtime_cells.join(',')})"
    ]
    sheet.add_row(cells)
    sheet.merge_cells("B#{index}:I#{index}")
    sheet.add_style("B#{index}", sz: 16, b: true, alignment: { horizontal: :right, vertical: :center })
    sheet.add_style("J#{index}", sz: 16, b: true, bg_color: 'f98639', alignment: { horizontal: :center, vertical: :center }, border: { color: '000000', name: %I[vertical horizontal], style: :thin })
    sheet.rows.last.height = 25
  end

  def computed_overtime_row(sheet)
    index = get_index(sheet)
    cells = [
      '',
      'Total heures supplémentaires majorées',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      "=SUM(J#{index - 1},J#{index - 3})"
    ]
    sheet.add_row(cells)
    sheet.merge_cells("B#{index}:I#{index}")
    sheet.add_style("B#{index}", sz: 16, b: true, alignment: { horizontal: :right, vertical: :center })
    sheet.add_style("J#{index}", sz: 16, b: true, bg_color: '47e59b', alignment: { horizontal: :center, vertical: :center }, border: { color: '000000', name: %I[vertical horizontal], style: :thin })
    sheet.rows.last.height = 25
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

  def get_index(sheet)
    sheet.rows.last.row_index + 2
  end
end
