json.array!(@memberships) do |membership|
  json.partial! 'memberships/membership', membership: membership
end
