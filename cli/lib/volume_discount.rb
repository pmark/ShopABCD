# 
# ABCD Shop
# Copyright 2012 P. Mark Anderson
#
# mark@martianrover.com
# http://linkedin.com/in/pmark
# http://twitter.com/pmark
#

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
  
  def savings
    ((self.product.price * self.threshold) - self.price)
  end
  
  def to_s
    "#{self.threshold} product #{self.product.name} for #{currencify(self.price)}"
  end  
end