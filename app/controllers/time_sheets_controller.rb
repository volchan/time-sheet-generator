class TimeSheetsController < ApplicationController
  before_action :build_month_array

  def home; end

  def create
    @time_sheet = TimeSheet.new(sheet_params)
    return render :home unless @time_sheet.valid?
    @dates = build_dates_array
    @dates.pop
    render xlsx: @time_sheet.complete_name, template: 'time_sheets/time_sheet'
  end

  private

  def build_month_array
    @time_sheet = TimeSheet.new
    @months = Date::MONTHNAMES.compact.each_with_index.map do |month, index|
      [index + 1, month]
    end
  end

  def build_dates_array
    (
      Date.parse(
        "1/#{@time_sheet.month}/#{@time_sheet.year}"
      )..(
        Date.parse(
          "1/#{@time_sheet.month}/#{@time_sheet.year}"
        ) + 1.month
      )
    ).to_a
  end

  def sheet_params
    params.require(:time_sheet).permit(:first_name, :last_name, :month, :year)
  end
end
