# 
# ABCD Shop
# Copyright 2012 P. Mark Anderson
#
# mark@martianrover.com
# http://linkedin.com/in/pmark
# http://twitter.com/pmark
#

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