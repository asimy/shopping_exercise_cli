# frozen_string_literal: true

# to keep the file structure as simple as possible, I'm creating all my classes in this file

class ShoppingListParser
  attr_reader :shopping_input, :tallied_list

  def initialize(shopping_input)
    @shopping_input = shopping_input
    @tallied_list = {}
    @tallied_list = convert_to_list if valid?
  end

  def valid?
    /^([a-z]+, *)*[a-z]+$/.match?(shopping_input)
  end

  def convert_to_list
    cleaned_input = shopping_input.gsub(/\s+/, '')
    shopping_array = cleaned_input.split(',')
    shopping_list = shopping_array.tally
  end
end

ItemPricing = Struct.new(:standard_price,
                         :sale_price,
                         :sale_quantity)
LineItem = Struct.new(:item_name,
                      :quantity,
                      :purchase_price,
                      :savings)

class PricingCalculator
  attr_reader :pricing_list

  def initialize(pricing_list)
    @pricing_list = pricing_list
  end

  def shopping_bill(shopping_list)
    bill_line_items = []
    shopping_list.each do |item_name, quantity|
      bill_line_items << calculate_line_item(item_name, quantity)
    end
    bill_line_items
  end

  def calculate_line_item(item_name, quantity)
    item_pricing = pricing_list[item_name]

    if item_pricing.sale_quantity == 0
      purchase_price = quantity * item_pricing.standard_price
      savings = 0
    end

    LineItem.new(item_name, quantity, purchase_price, savings)
  end
end
