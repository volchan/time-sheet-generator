class TimeSheetsController < ApplicationController
  before_action :set_time_sheet, :build_month_array

  def home; end

  def create
    @time_sheet = TimeSheet.new(sheet_params)
    return render(:error_form, layout: false) unless @time_sheet.valid?
    @date = Date.parse("1/#{@time_sheet.month}/#{@time_sheet.year}")
    @dates = build_dates_array
    @overtime_cells = []
    @majored_overtime_cells = []
    @last_month_overtime_cell= []
    filename = "#{@time_sheet.complete_name.split(' ').join('_')}_#{l @date, format: :month}_#{@time_sheet.year}"
    binary = ApplicationController.render(
      xlsx: filename,
      template: 'time_sheets/time_sheet.xlsx.axlsx',
      locals: {
        date: @date,
        dates: @dates,
        overtime_cells: @overtime_cells,
        majored_overtime_cells: @majored_overtime_cells,
        last_month_overtime_cell: @last_month_overtime_cell,
        time_sheet: @time_sheet
      },
      layout: false
    )
    @url = Utils::Files.download_link("#{filename}.xlsx", binary)
    respond_to do |format|
      format.js { render :download_file, layout: false }
    end
  end

  def download
    file_path = Dir.glob(Rails.root.join("tmp/#{params[:folder]}/*")).first
    file_name = file_path.split('/').last
    mime_type = MIME::Types.type_for(file_path).first.content_type
    send_data File.read(file_path), type: mime_type, filename: file_name
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
    (@date..@date.at_end_of_month).to_a
  end

  def sheet_params
    params.require(:time_sheet).permit(:first_name, :last_name, :month, :year)
  end
end
