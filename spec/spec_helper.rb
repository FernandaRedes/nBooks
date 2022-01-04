require "faker"
require_relative "base_api.rb"
require_relative "../app.rb"

#deleta todo banco de dados antes de executar os testes
#Esse é o primeiro teste a ser executado

Book.delete_all

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

end
