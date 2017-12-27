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

require 'rails_helper'

describe Identity do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:uid) }
    it {
      is_expected.to validate_uniqueness_of(:uid).
        scoped_to(:provider)
    }
  end
end
