json.array!(@customers) do |customer|
  json.partial! 'customers/customer', customer: customer
end
