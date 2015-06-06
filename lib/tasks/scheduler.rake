desc "This task is called by the Heroku scheduler add-on"
task :populate_active_members => :environment do
  print "Populating Active members - #{Time.now}"
  Facility.all.each do |f|
    active_member_count = Member.where({facility_id: f.id}).where.not({inactive: true}).count
    f.active_members_histories.create({count: active_member_count, total: f.members.count, in: Date.today})
  end
end