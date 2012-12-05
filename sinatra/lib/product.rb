class Product
  include Utility
  
  attr_accessor :name
  attr_accessor :price
  
  def initialize(name, price)
    self.name = name
    self.price = price
  end
  
  # names: CSV of vd product names e.g.  A,A,C,A,C
  def self.products_for_product_names(names)
    return nil if names.empty?

    names.collect do |name|
      DB_PRODUCTS[name]
    end    
  end
  
  def ==(other)
    self.name == other.name
  end
  
  def price_formatted
    self.currencify(self.price)
  end
  
  def to_json(a, b)
    {
      "name" => self.name,
      "price" => self.price
    }.to_json
  end
  
end