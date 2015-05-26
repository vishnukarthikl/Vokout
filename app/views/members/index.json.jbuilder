json.array!(@members) do |member|
  json.partial! 'members/member', member: member, show_extra_details: false
end
