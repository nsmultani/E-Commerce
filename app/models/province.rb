# app/models/province.rb

class Province < ApplicationRecord
  validates :name, presence: true
  validates :abbreviation, presence: true, uniqueness: true
  validates :gst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :pst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :hst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:name) }

  def total_tax_rate
    hst_rate > 0 ? hst_rate : (gst_rate + pst_rate)
  end

  def tax_breakdown
    if hst_rate > 0
      { hst: hst_rate }
    else
      { gst: gst_rate, pst: pst_rate }.reject { |k, v| v == 0 }
    end
  end

  def display_name_with_tax
    "#{name} (#{(total_tax_rate * 100).round(1)}%)"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name", "abbreviation", "gst_rate", "pst_rate", "hst_rate"]
  end
end