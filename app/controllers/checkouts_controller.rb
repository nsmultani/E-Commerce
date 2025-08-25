
class CheckoutsController < ApplicationController
  before_action :initialize_cart
  before_action :ensure_cart_not_empty

  def new
    @checkout = CheckoutForm.new
    @provinces = Province.ordered
    @cart_items = @cart.products
    @subtotal = @cart.subtotal
    calculate_taxes
  end

  def create
    @checkout = CheckoutForm.new(checkout_params)
    @provinces = Province.ordered
    @cart_items = @cart.products
    @subtotal = @cart.subtotal
    calculate_taxes
    
    if @checkout.valid?
      begin
        # Create the order
        @order = create_order
        
        # Clear the cart
        @cart.clear
        
        redirect_to checkout_success_path(@order.id), 
                   notice: "Order placed successfully! Order ##{@order.id}"
      rescue => e
        Rails.logger.error "Order creation failed: #{e.message}"
        flash.now[:alert] = "There was an error processing your order. Please try again."
        render :new
      end
    else
      flash.now[:alert] = "Please correct the errors below."
      render :new
    end
  end

  def success
    @order = Order.find(params[:id])
  end

  private

  def checkout_params
    params.require(:checkout).permit(:customer_name, :email, :address_line_1, 
                                   :address_line_2, :city, :province_id, 
                                   :postal_code, :country)
  end

  def calculate_taxes
    if params[:province_id].present?
      province = Province.find(params[:province_id])
      @tax_rate = province.total_tax_rate
      @tax_amount = (@subtotal * @tax_rate).round(2)
    else
      @tax_rate = 0.13 # Default HST for demo
      @tax_amount = (@subtotal * @tax_rate).round(2)
    end
    @total = @subtotal + @tax_amount
  end

  def create_order
    province = Province.find(@checkout.province_id)
    tax_rate = province.total_tax_rate
    tax_amount = (@subtotal * tax_rate).round(2)
    total = @subtotal + tax_amount

    order = Order.create!(
      customer_name: @checkout.customer_name,
      email: @checkout.email,
      address_line_1: @checkout.address_line_1,
      address_line_2: @checkout.address_line_2,
      city: @checkout.city,
      province: province.name,
      postal_code: @checkout.postal_code,
      country: @checkout.country || 'Canada',
      subtotal: @subtotal,
      taxes: tax_amount,
      total: total,
      status: 'pending'
    )

    # Create order items with historical pricing
    @cart_items.each do |cart_item|
      product = cart_item[:product]
      OrderItem.create!(
        order: order,
        product: product,
        product_name: product.name,
        quantity: cart_item[:quantity],
        price: product.display_price
      )
    end

    order
  end

  def initialize_cart
    @cart = ShoppingCart.new(session)
  end

  def ensure_cart_not_empty
    if @cart.empty?
      redirect_to products_path, alert: "Your cart is empty. Add some products before checking out."
    end
  end
end