module Utility

  @@cache = {}
  
  # Takes a number and options hash and outputs a string in any currency format.
  # CREDIT:  http://codesnippets.joyent.com/posts/show/1812
  def currencify(number, options={})
    
    return "$0.00" if number.nil?
    
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
    
    def self.cache_set(key, value)
      return if key.empty?
      v = (value ? value.to_json : nil)
      @@cache[key] = v
      REDIS.set(key, v)
      puts("redis.set(#{key}, #{v})")
    end

    def self.cache_get(key)
      v = @@cache[key]
      
      if v.nil? 
        v = REDIS.get(key)
        @@cache[key] = v
      end
      
      JSON.parse(v) if v
    end
    
    def self.cache_clear
      @@cache = {}
    end
end