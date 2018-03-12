class CoffeeExample
  def ingredients
    @ingredients ||= []
  end
  def add(ingredient)
    ingredients << ingredients
  end
  def price
    1.00 + ingredients.size * 0.25
  end
  def color
    ingredients.include?(:milk) ? :dark : :light
  end
  def temperature
    ingredients.include?(:milk) ? 205.0 : 190.0
  end
end

RSpec.configure do |config|
  # config.filter_run_when_matching focus: true
  config.example_status_persistence_file_path = 'spec/example.text'
end
RSpec.describe 'A cup of coffee' do

  let(:coffee){CoffeeExample.new}

  it 'cost $1' do
    expect(coffee.price).to eq(1.00)
  end

  context 'with milk' do
    before {coffee.add :milk}

    it 'cost $1.25' do
      expect(coffee.price).to eq(1.25)
    end

    it 'is light in color' do
      # pending 'Color not implemented yet'
      expect(coffee.color).to be(:light)
    end

    it 'is cooler than 200 degrees Faherheit' do
      # pending 'Temperature not implemented yet'
      expect(coffee.temperature).to be < 200.0
    end

  end

end
