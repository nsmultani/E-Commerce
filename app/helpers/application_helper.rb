# app/helpers/application_helper.rb
module ApplicationHelper
  def current_cart
    @current_cart ||= ShoppingCart.new(session)
  end
  
  def cart_item_count
    current_cart.total_items
  end
  
  def cart_subtotal
    current_cart.subtotal
  end

  # Breadcrumb helper method (4.1.3)
  def breadcrumbs(*crumbs)
    return '' if crumbs.empty?
    
    content_tag :nav, class: 'custom-breadcrumb' do
      content_tag :ol, class: 'breadcrumb' do
        crumb_items = []
        
        # Always start with Home
        crumb_items << content_tag(:li, class: 'breadcrumb-item') do
          link_to 'Home', root_path
        end
        
        # Add provided crumbs
        crumbs[0..-2].each do |crumb|
          crumb_items << content_tag(:li, class: 'breadcrumb-item') do
            if crumb.is_a?(Hash)
              link_to crumb[:name], crumb[:path]
            elsif crumb.is_a?(Array)
              link_to crumb[0], crumb[1]
            else
              crumb
            end
          end
        end
        
        # Last crumb is always active (current page)
        last_crumb = crumbs.last
        crumb_items << content_tag(:li, class: 'breadcrumb-item active') do
          if last_crumb.is_a?(Hash)
            last_crumb[:name]
          elsif last_crumb.is_a?(Array)
            last_crumb[0]
          else
            last_crumb
          end
        end
        
        safe_join(crumb_items)
      end
    end
  end

  # Product status badges helper
  def product_badges(product)
    badges = []
    
    if product.featured?
      badges << content_tag(:span, 'FEATURED', class: 'badge bg-warning')
    end
    
    if product.on_sale?
      badges << content_tag(:span, 'SALE', class: 'badge bg-danger')
    end
    
    if product.is_new?
      badges << content_tag(:span, 'NEW', class: 'badge bg-success')
    end
    
    if product.recently_updated?
      badges << content_tag(:span, 'UPDATED', class: 'badge bg-info')
    end
    
    safe_join(badges, ' ')
  end

  # Page title helper
  def page_title(title = nil)
    if title.present?
      content_for(:title, "#{title} - Northern Lights Outdoor Gear")
    else
      content_for(:title, "Northern Lights Outdoor Gear - Premium Outdoor Equipment")
    end
  end

  # Meta description helper
  def meta_description(description)
    content_for(:meta_description, description)
  end
end