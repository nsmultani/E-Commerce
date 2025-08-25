# app/admin/categories.rb - Replace the filters section:

ActiveAdmin.register Category do
  menu priority: 3
  
  permit_params :name, :description, :slug, :position, :parent_id

  # Index page
  index do
    selectable_column
    id_column
    column :name do |category|
      category.full_name
    end
    column :slug
    column :position
    column "Products Count" do |category|
      category.products.count
    end
    column "Subcategories" do |category|
      category.subcategories.count
    end
    column :created_at
    actions
  end

  # Filters - Fixed for Ransack compatibility
  filter :name
  filter :slug
  filter :parent_id, as: :select, collection: -> { Category.root_categories.ordered.map { |c| [c.name, c.id] } }
  filter :position
  filter :created_at

  # Form
  form do |f|
    f.inputs "Category Details" do
      f.input :name, hint: "Category name (e.g., 'Camping Equipment')"
      f.input :description, as: :text, rows: 3, hint: "Brief description of this category"
      f.input :slug, hint: "URL-friendly version (auto-generated if left blank)"
      f.input :parent_id, as: :select, 
              collection: Category.root_categories.ordered.map { |c| [c.name, c.id] },
              include_blank: "None (Root Category)",
              hint: "Select parent category to create a subcategory"
      f.input :position, hint: "Display order (lower numbers appear first)"
    end
    f.actions
  end

  # Show page
  show do
    attributes_table do
      row :name
      row :full_name
      row :description
      row :slug
      row :parent_category do |category|
        category.parent_category&.name || "Root Category"
      end
      row :position
      row :products_count do |category|
        category.products.count
      end
      row :subcategories_count do |category|
        category.subcategories.count
      end
      row :created_at
      row :updated_at
    end

    if resource.products.any?
      panel "Products in this Category" do
        table_for resource.products.limit(10) do
          column :name do |product|
            link_to product.name, admin_product_path(product)
          end
          column :sku
          column :price do |product|
            number_to_currency(product.price)
          end
          column :stock_quantity
        end
        if resource.products.count > 10
          div style: "margin-top: 10px;" do
            "... and #{resource.products.count - 10} more products"
          end
        end
      end
    end

    if resource.subcategories.any?
      panel "Subcategories" do
        table_for resource.subcategories.ordered do
          column :name do |subcategory|
            link_to subcategory.name, admin_category_path(subcategory)
          end
          column :slug
          column :products_count do |subcategory|
            subcategory.products.count
          end
        end
      end
    end
  end
end