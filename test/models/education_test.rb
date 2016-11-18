require 'test_helper'

class EducationTest < ActiveSupport::TestCase

  def setup
    @education = Education.new(name: "Example education", alias: "Example alias")
  end

  test "should be valid" do
    assert @education.valid?
  end

  test "education name should be present" do
    @education.name = ""
    assert_not @education.valid?
  end

  test "education alias should be present" do
    @education.alias = ""
    assert_not @education.valid?
  end

end
