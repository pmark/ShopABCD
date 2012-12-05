#
# The Order collects product and discount line items.
#
class Order
  attr_accessor :products
  attr_accessor :discounts
  
  def initialize
    self.products = []
    self.discounts = []
  end
  
  def product_total
    self.products.compact.inject(0) { |sum, p| sum + p.price }
  end
  
  def discount_savings
    self.discounts.compact.inject(0) { |sum, d| sum + d.savings }    
  end
  
  def total
    (self.product_total - self.discount_savings)
  end
  
  def products
    list = Utility.cache_get("shopabcd:order:products") || []
    Product.products_for_product_names(list) || []
  end
  
  def products=(product_objects)
    return unless product_objects    
    v = product_objects.collect(&:name)
    Utility.cache_set("shopabcd:order:products", v)
  end
  
  def add_product(product)
    list = self.products
    list << product    
    Utility.cache_set("shopabcd:order:products", list.collect(&:name))
    puts("[ORDER] Added product: #{product.name}")
  end

  def remove_product(product)
    list = self.products
    index_of_product = list.index(product)
    
    unless index_of_product.nil?
      list.delete_at(index_of_product)      
      Utility.cache_set("shopabcd:order:products", list.collect(&:name))
      puts("[ORDER] Removed product: #{product.name}")
    end
  end

  def product_count(product)
    self.products.find_all {|tmp| tmp == product}.size
  end
  
  def discounts
    list = Utility.cache_get("shopabcd:order:discounts") || []
    VolumeDiscount.discounts_for_product_names(list) || []
  end
  
  def reset_discounts
    Utility.cache_set("shopabcd:order:discounts", [])
  end
  
  def discounts=(discount_objects)
    return unless discount_objects    
    discount_objects.each do |discount|
      self.add_discount(discount)
    end
  end
  
  def add_discount(discount)
    list = self.discounts
    list << discount
    
    v = list.collect(&:product).collect(&:name)
    Utility.cache_set("shopabcd:order:discounts", v)
    puts("[ORDER] Applied discount: #{discount}")
  end
  
  def discounts_applied_for_product?(product)
    self.discounts.compact.collect(&:product).include?(product)
  end
end