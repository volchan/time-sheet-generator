class SheetGeneratorService
  def initialize(time_sheet)
    @time_sheet = time_sheet
  end

  def generate
    render(
      xlsx: "#{company}-#{configured_dates[:start]}-#{configured_dates[:finish]}",
      template: template,
      layout: false,
      locals: {
        company: @company,
        selection_dates: @selection_dates,
        header_array: @header_array,
        reporting_xls: @reporting_xls,
        count: @count
      }
    )
    raise
  end
end
