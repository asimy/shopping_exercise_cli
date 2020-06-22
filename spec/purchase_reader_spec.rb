# frozen_string_literal: true

require_relative '../price_calculator'

describe PurchaseReader do
  let(:valid_shopping_list) { 'milk,milk, bread,banana,bread,bread,bread,milk,apple' }
  let(:invalid_shopping_list) {'milk;milk; bread;banana;bread;bread;bread;milk;apple'}
  let(:pr) {PurchaseReader.new}

  it 'validates a valid shopping list' do
    expect(pr.valid?(valid_shopping_list)).to be true
  end

  it 'does not validate an invalid shopping list' do
    expect(pr.valid?(invalid_shopping_list)).to be false
  end
  
  it 'converts valid input into an array' do
    expect(pr.convert_to_list(valid_shopping_list)).to equal %w[milk milk bread banana bread bread bread milk apple]
  end

  # it 'reports an error for invalid input' do
    
  # end
end
