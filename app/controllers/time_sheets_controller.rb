class TimeSheetsController < ApplicationController
  before_action :set_time_sheet, :build_month_array

  def home; end

  def create
    @time_sheet = TimeSheet.new(sheet_params)
    return render :home unless @time_sheet.valid?
    @dates = build_dates_array
    @dates.pop
    @grouped_dates = @dates.group_by { |date| date.strftime("%W") }
    @date = Date.parse("1/#{@time_sheet.month}/#{@time_sheet.year}")
    render(
      xlsx: "#{@time_sheet.complete_name}_#{l Date.today, format: :month}_#{@time_sheet.year}",
      template: 'time_sheets/time_sheet.xlsx.axlsx',
      layout: false
    )
  end

  private

  def set_time_sheet
    @time_sheet = TimeSheet.new
  end

  def build_month_array
    @months = [
      [1, 'Janvier'],
      [2, 'Février'],
      [3, 'Mars'],
      [4, 'Avril'],
      [5, 'Mai'],
      [6, 'Juin'],
      [7, 'Juillet'],
      [8, 'Août'],
      [9, 'Septembre'],
      [10, 'Octobre'],
      [11, 'Novembre'],
      [12, 'Décembre']
    ]
  end

  def build_dates_array
    (
      Date.parse(
        "1/#{@time_sheet.month}/#{@time_sheet.year}"
      )..(
        Date.parse(
          "1/#{@time_sheet.month + 1}/#{@time_sheet.year}"
        )
      )
    ).to_a
  end

  def sheet_params
    params.require(:time_sheet).permit(:first_name, :last_name, :month, :year)
  end
end
