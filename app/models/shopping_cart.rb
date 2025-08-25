class ShoppingCart
  attr_accessor :items

  def initialize(session)
    @session = session
    @items = session[:cart] ||= {}
  end

  def add_product(product_id, quantity = 1)
    product_id = product_id.to_s
    @items[product_id] = (@items[product_id] || 0) + quantity.to_i
    @session[:cart] = @items
  end

  def update_quantity(product_id, quantity)
    product_id = product_id.to_s
    if quantity.to_i <= 0
      remove_product(product_id)
    else
      @items[product_id] = quantity.to_i
      @session[:cart] = @items
    end
  end

  def remove_product(product_id)
    @items.delete(product_id.to_s)
    @session[:cart] = @items
  end

  def clear
    @items.clear
    @session[:cart] = @items
  end

  def products
    return [] if @items.empty?
    
    Product.where(id: @items.keys).includes(:categories, images_attachments: :blob).map do |product|
      {
        product: product,
        quantity: @items[product.id.to_s],
        total_price: product.display_price * @items[product.id.to_s]
      }
    end
  end

  def total_items
    @items.values.sum
  end

  def subtotal
    products.sum { |item| item[:total_price] }
  end

  def empty?
    @items.empty?
  end

  def has_product?(product_id)
    @items.key?(product_id.to_s)
  end

  def quantity_for(product_id)
    @items[product_id.to_s] || 0
  end
end