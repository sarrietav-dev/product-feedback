require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  setup do
    @category = categories(:one)
  end

  # Happy path tests
  test "should have many suggestions" do
    assert_respond_to @category, :suggestions
  end

  test "capitalized_name returns capitalized name for long names" do
    category = Category.new(name: "feature")
    assert_equal "Feature", category.capitalized_name
  end

  test "capitalized_name returns uppercase for names with 2 or fewer characters" do
    category = Category.new(name: "ui")
    assert_equal "UI", category.capitalized_name
    
    category = Category.new(name: "ux")
    assert_equal "UX", category.capitalized_name
    
    category = Category.new(name: "a")
    assert_equal "A", category.capitalized_name
  end

  test "capitalized_name handles already capitalized names correctly" do
    category = Category.new(name: "FEATURE")
    assert_equal "Feature", category.capitalized_name
  end

  test "capitalized_name handles mixed case correctly" do
    category = Category.new(name: "FeAtUrE")
    assert_equal "Feature", category.capitalized_name
  end
end