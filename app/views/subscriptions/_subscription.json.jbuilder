json.extract! subscription, :id, :start_date, :days_left, :days_left_words, :expired
if show_membership
  json.membership subscription.membership, :id, :name
end
