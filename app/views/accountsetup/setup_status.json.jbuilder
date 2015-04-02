unless @facility.nil?
  json.extract! @facility, :id, :name, :address, :phone
  json.memberships @facility.memberships, :id, :name, :duration, :duration_type, :duration_in_days, :cost
  json.members @facility.members do |member|
    json.partial! 'members/member', member: member
  end
end
