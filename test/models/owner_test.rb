require 'test_helper'

class OwnerTest < ActiveSupport::TestCase

  def setup
    @owner = Owner.new(name: "Example Owner", email: "owner@example.com",
        password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @owner.valid?
  end

  test "name should be present" do
    @owner.name = ""
    assert_not @owner.valid?
  end

  test "email should be present" do
    @owner.email = "     "
    assert_not @owner.valid?
  end

  test "name should not be too long" do
    @owner.name = "a" * 51
    assert_not @owner.valid?
  end

  test "email should not be too long" do
    @owner.email = "a" * 256
    assert_not @owner.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[owner@example.com owner@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @owner.email = valid_address
      assert @owner.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[owner@example,com owner_at_foo.org owner.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @owner.email = invalid_address
      assert_not @owner.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @owner.email = mixed_case_email
    @owner.save
    assert_equal mixed_case_email.downcase, @owner.reload.email
  end

  test "email addresses should be unique" do
    duplicate_owner = @owner.dup
    @owner.save
    duplicate_owner.email = @owner.email.upcase
    assert_not duplicate_owner.valid?
  end

  test "password should have a minimum length" do
    @owner.password = @owner.password_confirmation = "a" * 5
    assert_not @owner.valid?
  end

end
