unless @facility.nil?
  json.extract! @facility, :id, :name, :address, :phone
  json.memberships @facility.memberships, :id, :name, :duration, :cost
end
