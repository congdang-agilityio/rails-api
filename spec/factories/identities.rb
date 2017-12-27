# == Schema Information
#
# Table name: identities
#
#  id         :integer          not null, primary key
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  token      :string
#  expires_at :datetime
#  email      :string
#  first_name :string
#  last_name  :string
#
# Indexes
#
#  index_identities_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :identity do
    trait :facebook do
      provider 'facebook'
      uid "123456"
    end

    first_name Faker::Name.name
    last_name Faker::Name.name
    user
  end
end
