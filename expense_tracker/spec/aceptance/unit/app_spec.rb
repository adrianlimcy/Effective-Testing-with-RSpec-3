require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
  # RecordResult = Struct.new(:success?, :expense_id, :error_message) #<-- no longer needed once app/ledger.rb is created
  RSpec.describe API do
    include Rack::Test::Methods
    def app
      API.new(ledger: ledger)
    end
    def parsing
      @parsed = JSON.parse(last_response.body)
    end

    let(:ledger) {instance_double('ExpenseTracker::Ledger')}
    let(:expense) {{'some'=> 'data'}}

    describe 'Post /expenses' do
      context 'when the expense is succssfully recorded' do
        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
        end
        it 'returns the expense of' do
          post '/expenses', JSON.generate(expense)
          # parsed = JSON.parse(last_response.body)
          parsing
          expect(@parsed).to include('expense_id' => 417)
        end
        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end
        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)
          # parsed = JSON.parse(last_response.body)
          parsing
          expect(@parsed).to include('error' => 'Expense incomplete')
        end
        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'Get /expenses/:date' do
      context 'when expenses exist on the given date' do
        it 'returns the expense records as JSON' do
          get '/expenses/2017-06-12'
          parsing
          expect(@parsed).to include('expense_id' => 417)
        end
        it 'responds with a 200 (OK)' do
          get '/expenses/2017-06-12'
          expect(last_response.status).to eq(200)
        end
      end
      context 'when there are no expenses on the given date' do
        it 'returns an empty array as JSON' do
          get '/expenses/2018-12-12'
          parsing
          expect(@parsed).to eq([])
        end
        it 'responds with a 200 (OK)' do
          get '/expenses/2017-12-12'
          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end
