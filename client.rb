require 'savon'

client = Savon.client do |wsdl, http|
  HTTPI.log = true
  HTTPI.log_level = :debug
  wsdl.document = "http://localhost:3000/rumbas/wsdl"
end

client.wsdl.soap_actions # => [:integer_to_string, :concat, :add_circle]

result = client.request(:concat) do
  soap.body = { :a => "123", :b => "abc" }
end

# actual wash_out
puts result.to_hash
