# app/models/order.rb - Updated version
class Order < ApplicationRecord
  # Associations
  belongs_to :user, optional: true # Allow guest checkout
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  # Validations
  validates :customer_name, :email, :address_line_1, :city, :province, :postal_code, :country, presence: true
  validates :subtotal, :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :taxes, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Enum for status
  enum status: {
    pending: 'pending',
    paid: 'paid',
    shipped: 'shipped',
    delivered: 'delivered',
    cancelled: 'cancelled'
  }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }

  # Callbacks
  before_create :generate_order_number

  def total_items
    order_items.sum(:quantity)
  end

  def can_be_cancelled?
    pending? || paid?
  end

  def can_be_shipped?
    paid?
  end

  def can_be_delivered?
    shipped?
  end

  # For ActiveAdmin ransack
  def self.ransackable_attributes(auth_object = nil)
    ["id", "customer_name", "email", "status", "total", "subtotal", "taxes", "created_at", "updated_at", "shipped_at", "delivered_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "order_items", "products"]
  end

  private

  def generate_order_number
    self.order_number = "NL#{Date.current.strftime('%Y%m%d')}#{format('%04d', (Order.where('created_at >= ?', Date.current.beginning_of_day).count + 1))}"
  end
end

