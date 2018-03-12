#---
# Excerpted from "Effective Testing with RSpec 3",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rspec3 for more book information.
#---
RSpec::Matchers.define :have_a_balance_of do |amount|
  match { |account| account.current_balance == amount }
  failure_message { |account| super() + failure_reason(account) }
  failure_message_when_negated { |account| super() + failure_reason(account) }

private

  def failure_reason(account)
    ", but had a balance of #{account.current_balance}"
  end
end
