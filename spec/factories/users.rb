# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  phone_number           :string
#  day_of_birth           :datetime
#  is_activated           :boolean
#  allow_notification     :boolean
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

FactoryGirl.define do
  factory :user do
    first_name Faker::Name.name
    last_name Faker::Name.name
    email Faker::Internet.email
    phone_number Faker::Number.number(10)
    day_of_birth Faker::Date.backward(14)
    password Faker::Crypto.sha256

    factory :facebook_user do
      after(:create) do |user|
        create(:identity, :facebook, user: user)
      end
    end
  end
end
