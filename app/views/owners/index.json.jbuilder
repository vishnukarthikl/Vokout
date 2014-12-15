json.array!(@owners) do |owner|
  json.extract! owner, :id, :name, :email, :password_digest
  json.url owner_url(owner, format: :json)
end
