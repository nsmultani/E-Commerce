# app/models/address.rb

class Address < ApplicationRecord
  belongs_to :user
  belongs_to :province

  validates :street_address, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true, format: { with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/ }
  validates :address_type, inclusion: { in: %w[shipping billing] }

  scope :shipping, -> { where(address_type: 'shipping') }
  scope :billing, -> { where(address_type: 'billing') }
  scope :default_addresses, -> { where(is_default: true) }

  before_save :ensure_only_one_default_per_type

  def full_address
    parts = [street_address]
    parts << address_line_2 if address_line_2.present?
    parts << "#{city}, #{province.abbreviation}"
    parts << postal_code
    parts.join(', ')
  end

  def self.ransackable_attributes(auth_object = nil)
    ["street_address", "city", "postal_code", "address_type", "is_default"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "province"]
  end

  private

  def ensure_only_one_default_per_type
    if is_default?
      # Remove default flag from other addresses of the same type for this user
      user.addresses.where(address_type: address_type, is_default: true)
          .where.not(id: id).update_all(is_default: false)
    end
  end
end