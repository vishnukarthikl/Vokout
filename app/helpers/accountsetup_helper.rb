module AccountsetupHelper
  def is_account_setup(facility)
    !facility.nil? && !facility.memberships.empty?
  end
end
