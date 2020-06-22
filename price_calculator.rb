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

ItemPricing = Struct.new(:item_name, :standard_price, :sale_price, :sale_quantity)
LineItem = Struct.new(:item_name, :quantity, :purchase_price, :savings)

class PricingCalculator
  def initialize(pricing_list)
    @pricing_list = pricing_list
  end

  def shopping_bill(_shopping_list)
    []
  end
end
