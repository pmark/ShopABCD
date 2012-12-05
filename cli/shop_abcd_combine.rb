#!/usr/bin/env ruby
# 
# ABCD Shop
# Copyright 2012 P. Mark Anderson
#
# mark@martianrover.com
# http://linkedin.com/in/pmark
# http://twitter.com/pmark
#

$: << File.dirname(__FILE__) + "/lib"
require 'pos_terminal'
require 'product'
require 'order'
require 'volume_discount'


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


#
# Tests
#

order1
order2
order3

