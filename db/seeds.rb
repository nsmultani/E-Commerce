# db/seeds.rb - Replace the entire content with:

# Create default admin user (only if it doesn't exist)
unless AdminUser.exists?(email: 'admin@northernlights.com')
  AdminUser.create!(
    email: 'admin@northernlights.com', 
    password: 'password123', 
    password_confirmation: 'password123'
  )
  puts "Created admin user: admin@northernlights.com"
else
  puts "Admin user already exists"
end

# Create sample products (requirement: minimum 10 products with real names and descriptions)
products_data = [
  {
    name: "Alpine Summit 2-Person Tent",
    description: "Lightweight and durable 2-person tent perfect for backpacking and alpine adventures. Features waterproof coating, easy setup, and excellent ventilation. Ideal for 3-season camping.",
    sku: "TENT-ALPINE-2P",
    price: 299.99,
    stock_quantity: 15,
    weight: 4.5,
    dimensions: "84 x 54 x 42 inches",
    featured: true
  },
  {
    name: "TrailBlazer Hiking Backpack 65L",
    description: "Professional-grade 65-liter hiking backpack with adjustable torso, multiple compartments, and hydration system compatibility. Built for extended backcountry trips.",
    sku: "PACK-TRAIL-65L",
    price: 189.99,
    stock_quantity: 8,
    weight: 3.2,
    dimensions: "32 x 14 x 12 inches",
    featured: true
  },
  {
    name: "Wilderness Down Sleeping Bag -10°F",
    description: "Premium down sleeping bag rated for -10°F. Ultra-lightweight with 800-fill power down insulation. Comes with compression sack and lifetime warranty.",
    sku: "SLEEP-DOWN-10F",
    price: 449.99,
    stock_quantity: 12,
    weight: 2.8,
    dimensions: "20 x 8 x 8 inches (packed)"
  },
  {
    name: "Adventure LED Headlamp",
    description: "Powerful 400-lumen LED headlamp with red light mode, adjustable beam, and waterproof design. Perfect for camping, hiking, and emergency situations.",
    sku: "LIGHT-HEAD-400L",
    price: 34.99,
    stock_quantity: 25,
    weight: 0.3,
    dimensions: "4 x 2 x 1.5 inches",
    on_sale: true,
    sale_price: 24.99
  },
  {
    name: "Mountain Peak Hiking Boots",
    description: "Waterproof leather hiking boots with superior ankle support and vibram soles. Designed for rugged terrain and long-distance hiking.",
    sku: "BOOT-PEAK-HIKE",
    price: 159.99,
    stock_quantity: 20,
    weight: 2.1,
    dimensions: "Various sizes available"
  },
  {
    name: "Compact Camp Stove",
    description: "Lightweight portable camp stove with piezo ignition and adjustable flame control. Folds compact for easy packing. Includes carrying case.",
    sku: "STOVE-CAMP-COMP",
    price: 79.99,
    stock_quantity: 18,
    weight: 1.2,
    dimensions: "6 x 6 x 3 inches"
  },
  {
    name: "Insulated Water Bottle 32oz",
    description: "Double-wall vacuum insulated stainless steel water bottle. Keeps drinks cold for 24 hours or hot for 12 hours. BPA-free with leak-proof cap.",
    sku: "BOTTLE-INSUL-32",
    price: 29.99,
    stock_quantity: 35,
    weight: 0.8,
    dimensions: "10 x 3.5 x 3.5 inches",
    featured: true
  },
  {
    name: "Emergency Survival Kit",
    description: "Complete survival kit including fire starter, emergency blanket, whistle, compass, first aid supplies, and waterproof matches. Essential for any outdoor adventure.",
    sku: "KIT-SURVIVAL-EM",
    price: 49.99,
    stock_quantity: 22,
    weight: 1.5,
    dimensions: "8 x 6 x 4 inches"
  },
  {
    name: "Multi-Tool Outdoor Utility",
    description: "Premium 15-in-1 multi-tool with pliers, knife, screwdrivers, scissors, and more. Stainless steel construction with leather holster included.",
    sku: "TOOL-MULTI-15",
    price: 64.99,
    stock_quantity: 14,
    weight: 0.7,
    dimensions: "4.5 x 1.5 x 1 inches"
  },
  {
    name: "Waterproof Camping Tarp 10x12",
    description: "Heavy-duty waterproof tarp with reinforced grommets and guy-out points. Perfect for ground cover, shelter, or gear protection. Includes setup rope.",
    sku: "TARP-CAMP-10X12",
    price: 39.99,
    stock_quantity: 16,
    weight: 2.0,
    dimensions: "12 x 10 feet"
  }
]

products_data.each do |product_attrs|
  Product.find_or_create_by(sku: product_attrs[:sku]) do |product|
    product.assign_attributes(product_attrs)
  end
end

puts "Created #{Product.count} products"