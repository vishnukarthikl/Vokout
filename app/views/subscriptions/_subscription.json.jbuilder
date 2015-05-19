json.extract! subscription, :id, :start_date, :days_left, :days_left_words, :expired, :end_date, :extended_till
if show_membership
  json.membership subscription.membership, :id, :name,:cost
end
