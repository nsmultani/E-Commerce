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

# db/seeds.rb - Add this at the end:

# Create static pages with initial content
StaticPage.find_or_create_by(page_name: 'about') do |page|
  page.title = 'About Northern Lights Outdoor Gear'
  page.content = %Q{
<p>Welcome to Northern Lights Outdoor Gear, your premier destination for high-quality outdoor equipment and adventure gear.</p>

<p>Founded in 2015 in the heart of Winnipeg, Manitoba, we've been serving outdoor enthusiasts across Canada for over 9 years. What started as a small family-owned business has grown into a thriving enterprise with 12 dedicated team members who share a passion for the great outdoors.</p>

<h3>Our Mission</h3>
<p>At Northern Lights Outdoor Gear, we believe that everyone deserves access to reliable, high-quality equipment that enhances their outdoor adventures. Whether you're planning a weekend camping trip, embarking on a multi-day hiking expedition, or gearing up for winter sports, we have the expertise and equipment to help you succeed.</p>

<h3>What We Offer</h3>
<p>Our extensive inventory includes:</p>
<ul>
<li>Premium camping equipment and tents</li>
<li>Professional-grade hiking and backpacking gear</li>
<li>Winter sports equipment and apparel</li>
<li>Survival and emergency equipment</li>
<li>Outdoor clothing and accessories</li>
</ul>

<h3>Our Commitment</h3>
<p>We are committed to providing not just products, but expertise. Our knowledgeable staff are experienced outdoor enthusiasts who can help you choose the right equipment for your adventures. We stand behind every product we sell with our satisfaction guarantee.</p>

<p>Join thousands of satisfied customers who trust Northern Lights Outdoor Gear for their outdoor adventures. Let us help you explore the great outdoors with confidence!</p>
  }
  page.meta_description = 'Learn about Northern Lights Outdoor Gear - your trusted outdoor equipment provider in Winnipeg, Manitoba since 2015.'
end

StaticPage.find_or_create_by(page_name: 'contact') do |page|
  page.title = 'Contact Northern Lights Outdoor Gear'
  page.content = %Q{
<p>We'd love to hear from you! Get in touch with Northern Lights Outdoor Gear for product questions, order support, or just to chat about your next outdoor adventure.</p>

<h3>Store Information</h3>
<p><strong>Northern Lights Outdoor Gear</strong><br>
123 Adventure Way<br>
Winnipeg, MB R3C 1A1<br>
Canada</p>

<p><strong>Phone:</strong> (204) 555-GEAR (4327)<br>
<strong>Email:</strong> info@northernlights.com<br>
<strong>Website:</strong> www.northernlightsoutdoor.com</p>

<h3>Store Hours</h3>
<p><strong>Monday - Friday:</strong> 9:00 AM - 8:00 PM<br>
<strong>Saturday:</strong> 8:00 AM - 6:00 PM<br>
<strong>Sunday:</strong> 10:00 AM - 5:00 PM</p>

<h3>Get Directions</h3>
<p>Located in the heart of downtown Winnipeg, we're easily accessible by car or public transit. Parking is available in front of the store and in the adjacent lot.</p>

<h3>Expert Advice</h3>
<p>Our experienced team is here to help you choose the right gear for your adventures. Whether you're a beginner or a seasoned outdoor enthusiast, we provide personalized recommendations based on your specific needs and budget.</p>

<p>Visit us in-store or reach out online - we're here to help make your outdoor adventures unforgettable!</p>
  }
  page.meta_description = 'Contact Northern Lights Outdoor Gear in Winnipeg, MB. Get expert advice on outdoor equipment, store hours, and location information.'
end

puts "Created static pages: About and Contact"

if Product.count > 0
  # Make first 2 products "new"
  Product.limit(2).update_all(created_at: 10.days.ago)
  
  # Make next 2 products "recently updated"
  products_to_update = Product.offset(2).limit(2)
  products_to_update.each do |product|
    product.update(created_at: 60.days.ago, updated_at: 3.days.ago)
  end
  
  puts "Updated products for filtering demonstration"
end

# db/seeds.rb - Add more products at the end to demonstrate pagination:

# Add more products to demonstrate pagination (if we have less than 20)
additional_products = [
  {
    name: "Portable Camp Chair",
    description: "Lightweight folding camp chair with cup holder and carry bag. Perfect for camping, festivals, and outdoor events.",
    sku: "CHAIR-CAMP-PORT",
    price: 34.99,
    stock_quantity: 20,
    weight: 2.3,
    dimensions: "20 x 20 x 32 inches"
  },
  {
    name: "Solar Power Bank 20000mAh",
    description: "High-capacity solar power bank with wireless charging and LED flashlight. Perfect for extended outdoor adventures.",
    sku: "POWER-SOLAR-20K",
    price: 89.99,
    stock_quantity: 12,
    weight: 1.1,
    dimensions: "6 x 3 x 1 inches",
    featured: true
  },
  {
    name: "Insect Repellent Spray",
    description: "DEET-free natural insect repellent effective against mosquitoes, ticks, and flies. Safe for the whole family.",
    sku: "REPEL-NATURAL-SP",
    price: 12.99,
    stock_quantity: 45,
    weight: 0.4,
    dimensions: "7 x 2 x 2 inches"
  },
  {
    name: "Waterproof Dry Bag 30L",
    description: "Completely waterproof dry bag with roll-top closure. Keep your gear dry during water activities and wet weather.",
    sku: "BAG-DRY-30L",
    price: 24.99,
    stock_quantity: 18,
    weight: 0.6,
    dimensions: "22 x 12 inches"
  },
  {
    name: "Portable Camping Hammock",
    description: "Ultra-light parachute nylon hammock with tree straps included. Sets up in minutes for the perfect outdoor rest spot.",
    sku: "HAMMOCK-CAMP-UL",
    price: 54.99,
    stock_quantity: 15,
    weight: 1.8,
    dimensions: "10 x 6 x 6 inches (packed)"
  },
  {
    name: "First Aid Kit Complete",
    description: "Comprehensive first aid kit with 200+ pieces including bandages, antiseptic, pain relievers, and emergency supplies.",
    sku: "KIT-FIRST-AID",
    price: 39.99,
    stock_quantity: 25,
    weight: 1.2,
    dimensions: "9 x 6 x 3 inches"
  }
]

additional_products.each do |product_attrs|
  Product.find_or_create_by(sku: product_attrs[:sku]) do |product|
    product.assign_attributes(product_attrs)
  end
end

puts "Total products: #{Product.count}"

# db/seeds.rb - Add category assignments for new products:

# Assign categories to new products
new_product_assignments = {
  "CHAIR-CAMP-PORT" => ["Camping Equipment"],
  "POWER-SOLAR-20K" => ["Survival & Emergency", "Camping Equipment"],
  "REPEL-NATURAL-SP" => ["Camping Equipment", "Survival & Emergency"],
  "BAG-DRY-30L" => ["Hiking & Backpacking"],
  "HAMMOCK-CAMP-UL" => ["Camping Equipment"],
  "KIT-FIRST-AID" => ["Survival & Emergency"]
}

new_product_assignments.each do |sku, category_names|
  product = Product.find_by(sku: sku)
  next unless product
  
  category_names.each do |category_name|
    category = Category.find_by(name: category_name)
    next unless category
    
    ProductCategory.find_or_create_by(product: product, category: category)
  end
end

puts "Assigned categories to new products"