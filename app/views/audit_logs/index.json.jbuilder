json.array!(@audit_logs) do |log|
  json.extract! log, :id, :date, :auditable_type, :description
  if log.auditable_type == 'Purchase'
    json.purchase log.auditable, :id, :name, :cost, :purchase_type
    json.member log.auditable.member, :id, :name
  elsif log.auditable_type == 'Member'
    json.member log.auditable, :id, :name
  elsif log.auditable_type == 'Subscription'
    json.subscription log.auditable, :id, :end_date
    json.membership log.auditable.membership, :id, :name
    json.member log.auditable.member, :id, :name
  end
end
