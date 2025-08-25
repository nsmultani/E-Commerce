# app/models/user.rb

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one :shipping_address, -> { where(address_type: 'shipping', is_default: true) }, class_name: 'Address'
  has_one :billing_address, -> { where(address_type: 'billing', is_default: true) }, class_name: 'Address'

  # Validations
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :phone_number, format: { with: /\A[\d\-\s\+\(\)]+\z/ }, allow_blank: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def has_address?
    addresses.any?
  end

  def default_shipping_address
    shipping_address || addresses.where(address_type: 'shipping').first
  end

  def default_billing_address
    billing_address || addresses.where(address_type: 'billing').first
  end

  # For ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["first_name", "last_name", "email", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["addresses", "orders"]
  end
end