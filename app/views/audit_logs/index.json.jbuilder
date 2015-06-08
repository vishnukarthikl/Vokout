json.array!(@audit_logs) do |log|
  json.extract! log, :id, :date, :auditable_type
  if log.auditable_type == 'Purchase'
    json.purchase log.auditable, :id, :name, :cost,:purchase_type
    json.member log.auditable.member, :id, :name
  end
end
