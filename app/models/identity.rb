# == Schema Information
#
# Table name: auth_identities
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
#  index_auth_identities_on_user_id  (user_id)
#

class Identity < ApplicationRecord
  belongs_to :user, optional: true

  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
end
