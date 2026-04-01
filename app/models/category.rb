class Category < ApplicationRecord
  has_many :suggestions

  def capitalized_name
    (name.length > 2) ? name.capitalize : name.upcase
  end
end
