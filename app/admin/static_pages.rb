ActiveAdmin.register StaticPage do
  menu label: "Website Pages", priority: 2
  
  permit_params :title, :content, :meta_description

  # Only show About and Contact pages
  controller do
    def scoped_collection
      end_of_association_chain.where(page_name: ['about', 'contact'])
    end
  end

  index do
    selectable_column
    column :page_name do |page|
      link_to page.page_name.titleize, admin_static_page_path(page)
    end
    column :title
    column "Content Preview" do |page|
      truncate(strip_tags(page.content), length: 100)
    end
    column :updated_at
    actions
  end

  filter :page_name, as: :select, collection: [['About', 'about'], ['Contact', 'contact']]
  filter :title
  filter :updated_at

  form do |f|
    f.inputs "Edit #{f.object.page_name&.titleize || 'Page'}" do
      if f.object.new_record?
        f.input :page_name, as: :select, collection: [['About', 'about'], ['Contact', 'contact']], include_blank: false
      else
        f.input :page_name, as: :select, collection: [['About', 'about'], ['Contact', 'contact']], include_blank: false, input_html: { disabled: true }
        f.input :page_name, as: :hidden
      end
      f.input :title, hint: "Page title that appears in browser tab and page header"
      f.input :content, as: :text, input_html: { rows: 15 }, 
              hint: "Page content - you can use basic HTML tags like <p>, <br>, <strong>, <em>, <ul>, <li>, etc."
      f.input :meta_description, hint: "Brief description for search engines (optional)"
    end
    f.actions
  end

  show do
    attributes_table do
      row :page_name do |p|
        span p.page_name.titleize, style: "font-weight: bold; text-transform: uppercase;"
      end
      row :title
      row :content do |p|
        div simple_format(p.content), style: "max-height: 400px; overflow-y: auto; border: 1px solid #ddd; padding: 15px; background-color: #f9f9f9;"
      end
      row :meta_description
      row :updated_at
    end
    
    div style: "margin-top: 20px;" do
      h3 "Preview on Website"
      div do
        if resource.page_name == 'about'
          link_to "View About Page", about_path, target: '_blank', 
                  style: "background: #3498db; color: white; padding: 10px 15px; text-decoration: none; border-radius: 3px; margin-right: 10px;"
        elsif resource.page_name == 'contact'
          link_to "View Contact Page", contact_path, target: '_blank', 
                  style: "background: #3498db; color: white; padding: 10px 15px; text-decoration: none; border-radius: 3px; margin-right: 10px;"
        end
      end
    end
  end

  # Custom sidebar for easy navigation
  sidebar "Quick Navigation", only: [:show, :edit] do
    ul do
      StaticPage.where(page_name: ['about', 'contact']).each do |page|
        li link_to "#{page.page_name.titleize} Page", admin_static_page_path(page)
      end
    end
    
    hr style: "margin: 15px 0;"
    
    h4 "Website Preview"
    ul do
      li link_to "View About Page", about_path, target: '_blank'
      li link_to "View Contact Page", contact_path, target: '_blank'
    end
  end
end