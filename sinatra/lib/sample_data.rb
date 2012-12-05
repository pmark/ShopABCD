DB_PRODUCTS ||= {
  "A" => Product.new('A', 1.25),
  "B" => Product.new('B', 4.25),
  "C" => Product.new('C', 1.00),
  "D" => Product.new('D', 0.75)
}

DB_DISCOUNTS ||= {
  "A" => VolumeDiscount.new(DB_PRODUCTS["A"], 3, 3.00),
  "C" => VolumeDiscount.new(DB_PRODUCTS["C"], 6, 5.00)  
}
