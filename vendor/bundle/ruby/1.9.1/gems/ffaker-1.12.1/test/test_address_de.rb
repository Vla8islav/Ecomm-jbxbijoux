require 'helper'

class TestAddressDE < Test::Unit::TestCase
  def test_city
    assert_match /[ a-z]+/, Faker::AddressDE.city
  end

  def test_state
    assert_match /[ a-z]/, Faker::AddressDE.state
  end

  def test_zip_code
    assert_match /^\d{5}$/, Faker::AddressDE.zip_code
  end
end
