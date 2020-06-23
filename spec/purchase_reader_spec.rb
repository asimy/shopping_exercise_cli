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
      'apple' => ItemPricing.new(0.89, 0, 0)
    }
  end
  let(:no_sale_price_list) do
    {
      'milk' => ItemPricing.new(3.97, 0, 0),
      'bread' => ItemPricing.new(2.17, 0, 0),
      'banana' => ItemPricing.new(0.99, 0, 0),
      'apple' => ItemPricing.new(0.89, 0, 0)
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
    bill.sort
  end

  let(:purchase_bill_with_sales) do
    bill = []
    bill << LineItem.new('milk', 3, 8.97, 2.94)
    bill << LineItem.new('bread', 4, 8.17, 0.51)
    bill << LineItem.new('apple', 1, 0.89, 0)
    bill << LineItem.new('banana', 1, 0.99, 0)
    bill.sort
  end

  it 'returns correct pricing with no items' do
    calc = PricingCalculator.new([])
    expect(calc.shopping_items(no_item_list)).to eq([])
  end

  it 'returns correct pricing with items and no sales' do
    calc = PricingCalculator.new(no_sale_price_list)
    expect(calc.shopping_items(tallied_list).sort).to eq(purchase_bill_no_sales)
  end

  it 'returns correct pricing with items and sales' do
    calc = PricingCalculator.new(sale_price_list)
    expect(calc.shopping_items(tallied_list).sort).to eq(purchase_bill_with_sales)
  end
end

describe BillFormatter do
  let(:purchase_bill_with_sales) do
    bill = []
    bill << LineItem.new('milk', 3, 8.97, 2.94)
    bill << LineItem.new('bread', 4, 8.17, 0.51)
    bill << LineItem.new('apple', 1, 0.89, 0)
    bill << LineItem.new('banana', 1, 0.99, 0)
    bill.sort
  end

  let(:formatted_bill) do
    bill = <<~EOF
      Item     Quantity      Price
      --------------------------------------
      Apple     1            $0.89
      Banana    1            $0.99
      Bread     4            $8.17
      Milk      3            $8.97

      Total price: $19.02
      You saved $3.45 today.
    EOF
  end

  it 'calculates the total price' do
    formatter = BillFormatter.new(purchase_bill_with_sales)
    expect(formatter.total_price).to eq 19.02
  end

  it 'calculates the total savings' do
    formatter = BillFormatter.new(purchase_bill_with_sales)
    expect(formatter.total_savings).to eq 3.45
  end

  it 'returns a formatted text table from a shopping list' do
    formatter = BillFormatter.new(purchase_bill_with_sales)
    expect(formatter.printable_bill).to eq formatted_bill
  end
end
