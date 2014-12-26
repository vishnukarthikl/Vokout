require 'test_helper'

class FacilityTest < ActiveSupport::TestCase
  def setup
    @owner = owners(:owner1)
    @facility = @owner.build_facility(name:"afterburn",owner_id: @owner.id)
  end


  test "facility should be valid" do
    assert @facility.valid?
  end

  test "facility's owner id should be present" do
    @facility.owner_id = nil
    assert_not @facility.valid?
  end
  
end
