require 'utility'  

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
    puts("\n\nPOSTerminal.initialize\n\n")
    self.catalog_products = []
    self.catalog_discounts = []
    self.reset_order
  end
  
  def catalog_products
    DB_PRODUCTS.values
  end
  
  def catalog_discounts
    DB_DISCOUNTS.values
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
    
    if !product
      puts("ERROR: Can't find product named '#{product_name}'")
      return
    end
    
    self.order.add_product(product)
    self.apply_discounts
  end
  
  def remove_product_from_order_by_name(product_name)
    product = self.catalog_products.detect { |p| p.name == product_name }
    
    if !product
      puts("ERROR: Can't find product named '#{product_name}'")
      return
    end
    
    self.order.remove_product(product)
    self.apply_discounts  
  end
  
  def apply_discounts(print=true)
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
    
    savings = self.order.discount_savings
    
    if savings > 0
      puts("[POS] SUBTOTAL:  #{currencify(self.order.product_total)}")    
      puts("[POS] DISCOUNT: -#{currencify(savings)}")    
    end
    
    puts("[POS] TOTAL:  #{currencify(self.order_total)}\n\n")
  end
  
  def order_total(print=false)
    total = self.order.total    
    puts("Order total: #{total}") if print
    total
  end
  
  def discount_for_product(product)
    return nil unless product
    self.catalog_discounts.detect {|d| d.product.name == product.name }
  end
  
  def reset_order
    self.order = Order.new
    Utility.cache_set("shopabcd:order:discounts", [])
    Utility.cache_set("shopabcd:order:products", [])    
  end
  
end
