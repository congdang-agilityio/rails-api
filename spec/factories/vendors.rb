# == Schema Information
#
# Table name: vendors
#
#  id          :integer          not null, primary key
#  name        :string
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :vendor do
    name "MyString"
    category_id 1
  end
end
