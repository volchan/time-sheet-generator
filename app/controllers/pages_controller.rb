class PagesController < ApplicationController
  before_action :build_month_array

  def home; end

  private

  def build_month_array
    @months = Date::MONTHNAMES.compact.each_with_index.map do |month, index|
      [index + 1, month]
    end
  end
end
