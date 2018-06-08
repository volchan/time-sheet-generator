class PagesController < ApplicationController
  before_action :build_month_array

  def home; end

  private

  def build_month_array
    @months = Date::MONTHNAMES.compact
  end
end
