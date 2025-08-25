class StaticPage < ApplicationRecord
  validates :page_name, presence: true, uniqueness: true, inclusion: { in: %w[about contact] }
  validates :title, presence: true
  validates :content, presence: true
  
  # Define which attributes can be searched/filtered in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["page_name", "title", "content", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Helper methods to get specific pages
  def self.about_page
    find_or_create_by(page_name: 'about') do |page|
      page.title = 'About Northern Lights Outdoor Gear'
      page.content = 'Learn about our company and mission.'
    end
  end

  def self.contact_page
    find_or_create_by(page_name: 'contact') do |page|
      page.title = 'Contact Us'
      page.content = 'Get in touch with Northern Lights Outdoor Gear.'
    end
  end
end