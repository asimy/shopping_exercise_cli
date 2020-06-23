#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'
# to keep the file structure as simple as possible, I'm creating all my classes in this file
ItemPricing = Struct.new(:standard_price,
                         :sale_quantity,
                         :sale_price)

LineItem = Struct.new(:item_name,
                      :quantity,
                      :purchase_price,
                      :savings) do
                        def <=>(other)
                          item_name <=> other.item_name
                        end
                      end

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
    shopping_array.tally
  end
end

class PricingCalculator
  attr_reader :pricing_list

  def initialize(pricing_list)
    @pricing_list = pricing_list
  end

  def shopping_items(shopping_list)
    bill_line_items = []
    shopping_list.each do |item_name, quantity|
      bill_line_items << calculate_line_item(item_name, quantity)
    end
    bill_line_items
  end

  def calculate_line_item(item_name, quantity)
    item_pricing = pricing_list[item_name]

    if item_pricing.sale_quantity.zero?
      purchase_price = quantity * item_pricing.standard_price
      savings = 0
    else
      reg_price_quantity = quantity % item_pricing.sale_quantity
      sale_price_quantity = quantity / item_pricing.sale_quantity

      reg_price_purchase = reg_price_quantity * item_pricing.standard_price
      sale_price_purchase = sale_price_quantity * item_pricing.sale_price

      purchase_price = reg_price_purchase + sale_price_purchase
      savings = quantity * item_pricing.standard_price - purchase_price
    end

    LineItem.new(item_name, quantity, purchase_price, savings.round(2))
  end
end

class BillFormatter
  def initialize(line_items)
    @line_items = line_items
  end

  def total_savings
    @line_items.map(&:savings).sum(0)
  end

  def total_price
    @line_items.map(&:purchase_price).sum(0)
  end

  def printable_bill
    # header
    bill = format("%-9s%-14s%-s\n", 'Item', 'Quantity', 'Price')
    bill << '-' * 38 + "\n"

    formatting_string = "%-10s%-13d$%-.2f\n"

    @line_items.each do |item|
      bill << format(formatting_string, item.item_name.capitalize, item.quantity, item.purchase_price)
    end

    bill << "\n"
    bill << "Total price: $#{total_price}\n"
    bill << "You saved $#{total_savings} today.\n"
    bill
  end
end
