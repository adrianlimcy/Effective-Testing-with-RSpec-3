#---
# Excerpted from "Effective Testing with RSpec 3",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rspec3 for more book information.
#---
require 'invoice'

RSpec.describe Invoice do
  let(:address) { Address.new(zip: '90210') }
  let(:items) { [Item.new(cost: 30), Item.new(cost: 70)] }

  it 'calculates the total' do
    tax_rate = instance_double(Taxjar::Rate, combined_rate: 0.095)
    tax_client = instance_double(Taxjar::Client, rates_for_location: tax_rate)

    invoice = Invoice.new(address, items, tax_client: tax_client)

    expect(invoice.calculate_total).to eq(109.50)
  end
end
