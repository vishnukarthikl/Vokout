class PopulateExpiresOn < ActiveRecord::Migration
  def change
    Owner.all.each do |o|
      if o.facility
        o.facility.expires_on = 1.months.since
        o.facility.save
      end
    end
  end
end
