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
        "=IF(A#{index}<>\"\",E#{index}-B#{index}-D#{index}+C#{index},\"\")"
      ], %I[
        date
        time
        time
        time
        time
        time
      ]
    ]
  end
end
