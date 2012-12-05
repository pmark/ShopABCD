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