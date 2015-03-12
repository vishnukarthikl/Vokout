module AccountsetupHelper
  def is_account_setup(facility)
    !facility.nil? && !facility.memberships.empty? && !facility.members.empty?
  end
end
