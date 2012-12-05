$: << File.dirname(__FILE__) + "/lib"
require 'sinatra'
require 'haml'
require 'json'
require 'redistogo'
require 'pos_terminal'
require 'product'
require 'volume_discount'
require 'order'
require 'sample_data'
include Utility

set :protection, :except => :ip_spoofing

configure do
  @@shop = POSTerminal.new
end

get '/' do
  Utility.cache_clear
  @totals_json = (totals || {}).to_json
  @products = DB_PRODUCTS
  @discounts = DB_DISCOUNTS
  haml :index
end

get '/add' do
  Utility.cache_clear
  product_name = params["product"]
  @@shop.add_product_to_order_by_name(product_name) unless product_name.empty?
  send_order_json
end

get '/remove' do
  Utility.cache_clear
  product_name = params["product"]
  @@shop.remove_product_from_order_by_name(product_name) unless product_name.empty?
  send_order_json
end

get '/reset' do
  Utility.cache_clear
  @@shop.reset_order
  send_order_json
end

def send_order_json
  content_type :json
  totals.to_json  
end

def totals
  subtotal = currencify(@@shop.order.product_total)
  discount = currencify(@@shop.order.discount_savings)
  total = currencify(@@shop.order_total)
  
  counts = @@shop.catalog_products.inject({}) do |hash, product|
    hash[product.name] = @@shop.order.product_count(product)
    hash
  end
  
  { 
    :total => total, 
    :subtotal => subtotal, 
    :discount => discount,
    :product_counts => counts
  }
end
