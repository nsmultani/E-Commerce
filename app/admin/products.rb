# app/admin/products.rb - Make sure this is updated with category support:

ActiveAdmin.register Product do
  # Permitted parameters - Include category_ids
  permit_params :name, :description, :sku, :price, :stock_quantity, :weight, 
                :dimensions, :is_active, :featured, :on_sale, :sale_price, 
                images: [], category_ids: []

  # Index page configuration - Add categories column
  index do
    selectable_column
    id_column
    column :image do |product|
      if product.primary_image.present?
        image_tag url_for(product.primary_image), size: "50x50", style: "object-fit: cover;"
      else
        "No Image"
      end
    end
    column :name
    column :sku
    column "Categories" do |product|
      product.category_names
    end
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

  # Filters for the sidebar - Add category filter
  filter :name
  filter :sku
  filter :categories, as: :select, collection: -> { Category.ordered }
  filter :price
  filter :stock_quantity
  filter :is_active
  filter :featured
  filter :on_sale
  filter :created_at

  # Form configuration - Add categories section
  form do |f|
    f.inputs "Product Images" do
      f.input :images, as: :file, input_html: { multiple: true, accept: 'image/*' }, 
              hint: "Upload one or more product images (JPEG, PNG, GIF, WebP - max 5MB each)"
      
      if f.object.images.attached?
        f.inputs "Current Images" do
          f.object.images.each_with_index do |image, index|
            li do
              image_tag url_for(image), size: "150x150", style: "object-fit: cover; margin: 5px;"
            end
          end
        end
      end
    end
    
    f.inputs "Product Details" do
      f.input :name
      f.input :description, as: :text, rows: 4
      f.input :sku, hint: "Unique product identifier (letters, numbers, hyphens, underscores)"
    end

    f.inputs "Categories" do
      f.input :category_ids, as: :check_boxes, 
              collection: Category.ordered.map { |c| [c.full_name, c.id] },
              hint: "Select one or more categories for this product"
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

  # Show page configuration - Add categories display
  show do
    attributes_table do
      row :images do |product|
        if product.images.attached?
          div do
            product.images.each do |image|
              image_tag url_for(image), size: "200x200", style: "object-fit: cover; margin: 5px; border: 1px solid #ddd;"
            end
          end
        else
          "No images uploaded"
        end
      end
      row :name
      row :description
      row :sku
      row :categories do |product|
        if product.categories.any?
          ul do
            product.categories.each do |category|
              li link_to(category.full_name, admin_category_path(category))
            end
          end
        else
          "No categories assigned"
        end
      end
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