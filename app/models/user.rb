# == Schema Information
#
# Table name: auth_users
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
#  date_of_birth          :datetime
#  is_activated           :boolean
#  allow_notification     :boolean
#  country_code           :string
#
# Indexes
#
#  index_auth_users_on_email                 (email) UNIQUE
#  index_auth_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :identities, autosave: true

  validates_associated :identities

  before_save :correct_email

  validates :phone_number,
            uniqueness: true,
            format: { with: /\b^([0-9]{10})$\b/ }

  # validates :verify_code,
  #           uniqueness: true, if: 'verify_code.present?',
  #           format: {with: /\b^([0-9]{6})$\b/}

  def facebook
    identities.where(provider: :facebook).first
  end

  def self.create_from_omniauth(auth_attrs, user_attrs)
    identity = Identity.find_by(provider: auth_attrs[:provider], uid: auth_attrs[:uid])

    unless identity.nil?
      identity.update_attributes(auth_attrs)
      identity.user
    else
      user = User.new(
        email: user_attrs[:email],
        first_name: auth_attrs[:first_name],
        last_name: auth_attrs[:last_name],
        phone_number: user_attrs[:phone_number],
        password: Devise.friendly_token[0, 20]
      )

      user.identities.build(auth_attrs)
      user.save

      user
    end
  end

  private
  def correct_email
    self.email = email.downcase
  end
end
