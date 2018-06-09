class TimeSheet < ApplicationRecord
  validates :first_name, :last_name, presence: true
  validates :month, presence: true
  validates :year, numericality: true, presence: true

  def complete_name
    "#{first_name.capitalize} #{last_name.upcase}"
  end
end
