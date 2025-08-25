ActiveAdmin.register Product do
  # Permitted parameters
  permit_params :name, :description, :sku, :price, :stock_quantity, :weight, 
                :dimensions, :is_active, :featured, :on_sale, :sale_price

  # Index page configuration
  index do
    selectable_column
    id_column
    column :name
    column :sku
    column :price do |product|
      number_to_currency(product.price)
    end
    column :stock_quantity
    column :is_active
    column :featured
    column :on_sale
    column :created_at
    actions
  end

  # Filters for the sidebar
  filter :name
  filter :sku
  filter :price
  filter :stock_quantity
  filter :is_active
  filter :featured
  filter :on_sale
  filter :created_at

  # Form configuration - Updated with explicit min values
  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description, as: :text, rows: 4
      f.input :sku, hint: "Unique product identifier (letters, numbers, hyphens, underscores)"
    end
    
    f.inputs "Pricing" do
      f.input :price, min: 0.01, step: 0.01, hint: "Regular price in dollars (minimum $0.01)"
      f.input :on_sale
      f.input :sale_price, min: 0.01, step: 0.01, hint: "Sale price (if on sale, minimum $0.01)"
    end
    
    f.inputs "Inventory & Shipping" do
      f.input :stock_quantity, min: 0, hint: "Number of items in stock"
      f.input :weight, min: 0.01, step: 0.01, hint: "Weight in pounds (minimum 0.01)"
      f.input :dimensions, hint: "e.g., 12 x 8 x 4 inches"
    end
    
    f.inputs "Status" do
      f.input :is_active, hint: "Uncheck to hide from customers"
      f.input :featured, hint: "Show on featured products list"
    end
    
    f.actions
  end

  # Show page configuration
  show do
    attributes_table do
      row :name
      row :description
      row :sku
      row :price do |product|
        number_to_currency(product.price)
      end
      row :sale_price do |product|
        product.sale_price ? number_to_currency(product.sale_price) : "N/A"
      end
      row :display_price do |product|
        number_to_currency(product.display_price)
      end
      row :stock_quantity
      row :weight
      row :dimensions
      row :is_active
      row :featured
      row :on_sale
      row :in_stock do |product|
        product.in_stock? ? "Yes" : "No"
      end
      row :created_at
      row :updated_at
    end
  end
end