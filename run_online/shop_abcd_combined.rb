# 
# ABCD Shop
# Copyright 2012 P. Mark Anderson
#
# mark@martianrover.com
# http://linkedin.com/in/pmark
# http://twitter.com/pmark
#

module Utility

  # Takes a number and options hash and outputs a string in any currency format.
  # CREDIT:  http://codesnippets.joyent.com/posts/show/1812
  def currencify(number, options={})

    # default format: $12,345,678.90
    options = {
      :currency_symbol => "$", 
      :delimiter => ",", 
      :decimal_symbol => ".", 
      :currency_before => true
      }.merge(options)

      # split integer and fractional parts 
      int, frac = ("%.2f" % number).split('.')
      # insert the delimiters
      int.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")

      if options[:currency_before]
        options[:currency_symbol] + int + options[:decimal_symbol] + frac
      else
        int + options[:decimal_symbol] + frac + options[:currency_symbol]
      end
    end
end


class Product
  attr_accessor :name
  attr_accessor :price
  
  def initialize(name, price)
    self.name = name
    self.price = price
  end
  
  def ==(other)
    self.name == other.name
  end
end


class VolumeDiscount
  include Utility
  
  attr_accessor :product
  attr_accessor :threshold
  attr_accessor :price
  
  def initialize(product, threshold, price)
    self.product = product
    self.threshold = threshold
    self.price = price
  end
  
  def savings
    ((self.product.price * self.threshold) - self.price)
  end
  
  def to_s
    "#{self.threshold} product #{self.product.name} for #{currencify(self.price)}"
  end  
end


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
    self.discounts.collect {|d| d.product}.include?(product)
  end
end


# 
# The POSTerminal is responsible for setting up the product catalog and discounts.
# It also manages an order by adding products and applying discounts.
#
class POSTerminal
  include Utility
  
  attr_accessor :order
  attr_accessor :catalog_products
  attr_accessor :catalog_discounts
  
  def initialize()  
    self.catalog_products = []
    self.catalog_discounts = []
    self.reset_order
  end
  
  def add_product_to_catalog(product)    
    self.catalog_products << product
    puts("[CATALOG] New product: #{product.name} #{currencify(product.price)}")
  end
  
  def add_discount_to_catalog(discount)
    self.catalog_discounts << discount
    puts("[CATALOG] New discount: #{discount}")
  end
  
  def add_product_to_order_by_name(product_name)
    product = self.catalog_products.detect { |p| p.name == product_name }
    self.order.add_product(product)
    self.apply_discounts
    
    savings = self.order.discount_savings
    
    if savings > 0
      puts("[POS] SUBTOTAL:  #{currencify(self.order.product_total)}")    
      puts("[POS] DISCOUNT: -#{currencify(savings)}")    
    end
    
    puts("[POS] TOTAL:  #{currencify(self.order_total)}\n\n")    
  end
  
  def apply_discounts
    self.order.reset_discounts

    self.order.products.each do |line_item|
      
      discount = self.discount_for_product(line_item)

      if discount
        next if self.order.discounts_applied_for_product?(line_item)        
        
        product_count = self.order.product_count(line_item)        
        discount_count = (product_count / discount.threshold)
        discount_count.times { self.order.add_discount(discount) }
      end
    end
  end
  
  def order_total(print=false)
    total = self.order.total    
    puts("Order total: #{total}") if print
    total
  end
  
  def discount_for_product(product)
    self.catalog_discounts.detect {|d| d.product.name == product.name }
  end
  
  def reset_order
    self.order = Order.new
  end  
end


#
# TESTS
#

@shop = POSTerminal.new
puts("\n\n[SHOP] Welcome to Shop ABCD")

# Add products to the catalog.

puts("[SHOP] Initializing catalog\n\n")
product_a = Product.new('A', 1.25)
product_b = Product.new('B', 4.25)
product_c = Product.new('C', 1.00)
product_d = Product.new('D', 0.75)

@shop.add_product_to_catalog(product_a)
@shop.add_product_to_catalog(product_b)
@shop.add_product_to_catalog(product_c)
@shop.add_product_to_catalog(product_d)


# Add volume discounts.
# Product A: $1.25 each or 3 for $3.00
# Product C: $1.00 or 6 for $5.00

volume_discount_a = VolumeDiscount.new(product_a, 3, 3.00)
volume_discount_c = VolumeDiscount.new(product_c, 6, 5.00)

@shop.add_discount_to_catalog(volume_discount_a)
@shop.add_discount_to_catalog(volume_discount_c)

#
# ABCDABA should be $13.25
#
def order1  
  puts("\n\n- - - - - - - - - - - - - - - -\n[SHOP] Executing order 1: ABCDABA should be $13.25\n\n")  
  @shop.reset_order
  @shop.add_product_to_order_by_name('A')
  @shop.add_product_to_order_by_name('B')
  @shop.add_product_to_order_by_name('C')
  @shop.add_product_to_order_by_name('D')
  @shop.add_product_to_order_by_name('A')
  @shop.add_product_to_order_by_name('B')
  @shop.add_product_to_order_by_name('A')
end

#
# CCCCCCC should be $6.00
#
def order2
  puts("\n\n- - - - - - - - - - - - - - - -\n[SHOP] Executing order 2: CCCCCCC should be $6.00\n\n")  
  @shop.reset_order
  7.times { @shop.add_product_to_order_by_name('C') }
end

#
# ABCD should be $7.25
#
def order3
  puts("\n\n- - - - - - - - - - - - - - - -\n[SHOP] Executing order 3: ABCD should be $7.25\n\n")  
  @shop.reset_order
  @shop.add_product_to_order_by_name('A')
  @shop.add_product_to_order_by_name('B')
  @shop.add_product_to_order_by_name('C')
  @shop.add_product_to_order_by_name('D')
end

order1
order2
order3

