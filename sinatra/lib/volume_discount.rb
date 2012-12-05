require 'utility'

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
  
  # names: CSV of vd product names e.g.  A,A,C,A,C
  def self.discounts_for_product_names(names)
    return nil if names.empty?

    names.collect do |name|
      DB_DISCOUNTS[name]
    end    
  end
  
  def savings
    return 0 if self.product.nil?
    ((self.product.price * self.threshold) - self.price)
  end
  
  def to_s(show_name=false)
    "#{self.threshold} #{"product #{self.product.name} " if show_name}for #{currencify(self.price)}"
  end  
end
