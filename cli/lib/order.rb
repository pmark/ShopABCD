# 
# ABCD Shop
# Copyright 2012 P. Mark Anderson
#
# mark@martianrover.com
# http://linkedin.com/in/pmark
# http://twitter.com/pmark
#
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
    self.products.inject(0) { |sum, p| sum + p.price }
  end
  
  def discount_savings
    self.discounts.inject(0) { |sum, d| sum + d.savings }    
  end
  
  def total
    (self.product_total - self.discount_savings)
  end
  
  def add_product(product)
    self.products << product
    puts("[ORDER] Added product: #{product.name}")
  end

  def product_count(product)
    self.products.find_all {|tmp| tmp == product}.size
  end
  
  def reset_discounts
    self.discounts = []
  end
  
  def add_discount(discount)
    self.discounts << discount
    # puts("[ORDER] Applied discount: #{discount}")
  end
  
  def discounts_applied_for_product?(product)
    self.discounts.collect(&:product).include?(product)
  end
end