# frozen_string_literal: true

require_relative '../price_calculator'

describe ShoppingListParser do
  let(:valid_shopping_list) { 'milk,milk, bread,banana,bread,bread,bread,milk,apple' }
  let(:invalid_shopping_list) { 'milk;milk; bread;banana;bread;bread;bread;milk;apple' }

  it 'validates a valid shopping list' do
    parser = ShoppingListParser.new(valid_shopping_list)
    expect(parser.valid?).to be true
  end

  it 'does not validate an invalid shopping list' do
    parser = ShoppingListParser.new(invalid_shopping_list)
    expect(parser.valid?).to be false
  end

  it 'converts valid input into a tallied list' do
    parser = ShoppingListParser.new(valid_shopping_list)
    expect(parser.tallied_list).to eq({ 'milk' => 3, 'bread' => 4, 'banana' => 1, 'apple' => 1 })
  end

  it 'converts invalid input into an empty list' do
    parser = ShoppingListParser.new(invalid_shopping_list)
    expect(parser.tallied_list).to eq({})
  end
end

describe PricingCalculator do
  let(:sale_price_list) do
    {
      'milk' => ItemPricing.new(3.97, 2, 5.00),
      'bread' => ItemPricing.new(2.17, 3, 6.00),
      'banana' => ItemPricing.new(0.99, 0, 0),
      'apple' => ItemPricing.new(0.79, 0, 0)
    }
  end
  let(:no_sale_price_list) do
    {
      'milk' => ItemPricing.new(3.97, 0, 0),
      'bread' => ItemPricing.new(2.17, 0, 0),
      'banana' => ItemPricing.new(0.99, 0, 0),
      'apple' => ItemPricing.new(0.79, 0, 0)
    }
  end
  let(:tallied_list) { { 'milk' => 3, 'bread' => 4, 'banana' => 1, 'apple' => 1 } }
  let(:no_item_list) { {} }

  let(:purchase_bill_no_sales) do
    bill = []
    bill << LineItem.new('milk', 3, 11.91, 0)
    bill << LineItem.new('bread', 4, 8.68, 0)
    bill << LineItem.new('apple', 1, 0.89, 0)
    bill << LineItem.new('banana', 1, 0.99, 0)
  end

  it 'returns correct pricing with no items' do
    calc = PricingCalculator.new([])
    expect(calc.shopping_bill(no_item_list)).to eq([])
  end

  it 'returns correct pricing with items and no sales' do
    calc = PricingCalculator.new(no_sale_price_list)
    expect(calc.shopping_bill(tallied_list)).to eq(purchase_bill_no_sales)
  end
end
