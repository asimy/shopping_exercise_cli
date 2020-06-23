#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './price_calculator.rb'

class UserInterface
  def self.run(pricing_list)
    puts 'Please enter all the items purchased separated by a comma (hit return when the list is complete)'
    input = gets
    parser = ShoppingListParser.new(input)
    puts 'Please make sure you enter just your purchased items separated by commas...' unless parser.valid?
    shopping_list = parser.convert_to_list
    calc = PricingCalculator.new(pricing_list)
    formatter = BillFormatter.new(calc.shopping_items(shopping_list))
    puts "\n"
    puts formatter.printable_bill
  end
end

pricing_list = {
  'milk' => ItemPricing.new(3.97, 2, 5.00),
  'bread' => ItemPricing.new(2.17, 3, 6.00),
  'banana' => ItemPricing.new(0.99, 0, 0),
  'apple' => ItemPricing.new(0.89, 0, 0)
}

UserInterface.run(pricing_list)
