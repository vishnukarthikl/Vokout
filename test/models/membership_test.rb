require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  def setup
    @facility = facilities(:afterburn)
    @memberships = Membership.new(name:"afterburn")
    @facility.memberships << @memberships
  end


  test "membership should be valid" do
    assert @memberships.valid?
  end

  test "members's facility id should be present" do
    @memberships.facility_id = nil
    assert_not @memberships.valid?
  end
end
