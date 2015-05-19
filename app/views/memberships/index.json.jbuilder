json.array!(@memberships) do |membership|
  if !membership.temporary
    json.partial! 'memberships/membership', membership: membership
  end
end
