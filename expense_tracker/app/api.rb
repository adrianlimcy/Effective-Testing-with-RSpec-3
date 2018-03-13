require 'sinatra/base'
require 'json'
require_relative 'ledger'

module ExpenseTracker
  class API < Sinatra::Base
    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super()
    end
    post '/expenses' do
      # JSON.generate('expense_id'=> 42)
      # status 404
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)

      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end
    get '/expenses/:date' do
      # JSON.generate([])
      # if params['date'] == '2017-06-12'
      #   result = RecordResult.new(true, 417, nil)
      #   JSON.generate('expense_id' => result.expense_id)
      # else
      #   JSON.generate([])
      # end
      JSON.generate(@ledger.expenses_on(params[:date]))

    end


    # get '/hello/:name' do
    #   "Hello #{params['name']}!"
    # end
    # get '/bye/:name' do |n|
    #   "Good bye #{n}!"
    # end
    # get '/say/*/to/*' do
    #   params['splat'] # => ["hello", "world"]
    # end
    # get '/download/*.*' do |path, ext|
    #   [path, ext] # => ["path/to/file", "xml"]
    # end
    # get /\/hello\/([\w]+)/ do
    #   "Hello, #{params['captures'].first}!"
    # end
    # get %r{/hello/([\w]+)} do |c|
    #   # Matches "GET /meta/hello/world", "GET /hello/world/1234" etc.
    #   "Hello, #{c}!"
    # end
    # get '/posts/:format?' do
    #   # matches "GET /posts/" and any extension "GET /posts/json", "GET /posts/xml" etc
    # end
    # get '/posts' do
    #   # matches "GET /posts?title=foo&author=bar"
    #   title = params['title']
    #   author = params['author']
    #   # uses title and author variables; query is optional to the /posts route
    # end
    # https://github.com/sinatra/sinatra
    # http://sinatrarb.com/testing.html
  end
end
