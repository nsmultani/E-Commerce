# app/models/checkout_form.rb

class CheckoutForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :customer_name, :string
  attribute :email, :string
  attribute :address_line_1, :string
  attribute :address_line_2, :string
  attribute :city, :string
  attribute :province_id, :integer
  attribute :postal_code, :string
  attribute :country, :string

  validates :customer_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :province_id, presence: true
  validates :postal_code, presence: true, format: { with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/ }

  def province
    Province.find(province_id) if province_id.present?
  end
end