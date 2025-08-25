class CreateStaticPages < ActiveRecord::Migration[8.0]
  def change
    create_table :static_pages do |t|
      t.string :page_name, null: false, index: { unique: true }
      t.string :title, null: false
      t.text :content
      t.string :meta_description

      t.timestamps
    end
  end
end