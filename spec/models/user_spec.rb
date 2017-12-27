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

require 'rails_helper'

describe User do
  describe 'Validations' do
    context 'on a new user' do
      it 'should not be valid without a password' do
        user = User.new password: nil, password_confirmation: nil
        expect(user).to_not be_valid
      end

      it 'should not be valid with an empty password' do
        user = User.new password: '', password_confirmation: ''
        expect(user).to_not be_valid
      end

      it 'should be not be valid with a short password' do
        user = User.new password: 'short', password_confirmation: 'short'
        expect(user).to_not be_valid
      end

      it 'should not be valid with a confirmation mismatch' do
        user = User.new password: 'one thing', password_confirmation: 'another thing'
        expect(user).to_not be_valid
      end
    end

    context 'on an existing user' do
      let(:user) do
        user = FactoryGirl.create(:user)
        User.find(user.id) #Reload user to remove cached password attribute
      end

      it 'should be valid with no changes' do
        expect(user).to be_valid
      end

      it 'should be able to update the record without changing the password' do
        user.email = 'new_email@example.com'
        expect(user).to be_valid
      end


      it 'should be valid with a new (valid) password' do
        user.password = user.password_confirmation = 'new password'
        expect(user).to be_valid
      end

      it 'should be valid with a new (valid) email' do
        user.email = 'test@example.com'
        expect(user).to be_valid
      end

      it 'should not be valid with an empty email' do
        user.email = ''
        expect(user).to_not be_valid
      end

      it 'should not be valid with a new (invalid) email' do
        user.email = 'invalid email'
        expect(user).to_not be_valid
      end
    end
  end

  describe 'Associations' do
    it { is_expected.to have_many(:identities).autosave(true) }
  end

  describe '#facebook' do
    subject { create(:facebook_user) }

    it { is_expected.to respond_to(:facebook) }
    it { expect(subject.facebook).to be_an_instance_of(Identity) }
  end

  describe '#create_from_omniauth', :omniauth do
    let(:user) { { email: Faker::Internet.email, phone_number: Faker::Number.number(10) } }
    let(:auth) {
      {
        provider: 'facebook',
        uid: '12345',
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        token: Faker::Crypto.sha256,
        expires_at: Time.now
      }
    }

    it { expect(subject.class).to respond_to(:create_from_omniauth) }

    describe 'create a user with valid info' do
      let(:created_user) { subject.class.create_from_omniauth(auth, user) }

      it { expect(created_user.persisted?).to be_truthy }
      it { expect(created_user.email).to eq(user[:email]) }
      it { expect(created_user.first_name).to eq(auth[:first_name]) }
      it { expect(created_user.last_name).to eq(auth[:last_name]) }
      it { expect(created_user.phone_number).to eq(user[:phone_number]) }
      it { expect(created_user.encrypted_password).not_to be_nil }
    end

    describe 'create a Identity with valid info' do
      let(:created_identity) { subject.class.create_from_omniauth(auth, user).identities.first }

      it { expect(created_identity.persisted?).to be_truthy }
      it { expect(created_identity.provider).to eq(auth[:provider]) }
      it { expect(created_identity.uid).to eq(auth[:uid]) }
      it { expect(created_identity.email).to eq(auth[:email]) }
      it { expect(created_identity.first_name).to eq(auth[:first_name]) }
      it { expect(created_identity.last_name).to eq(auth[:last_name]) }
      it { expect(created_identity.token).to eq(auth[:token]) }
      it { expect(created_identity.expires_at).not_to be_nil }
    end

    context 'create an identity if it is not existed' do
      it { expect{ subject.class.create_from_omniauth(auth, user)}.to change{User.count}.by(1) }
      it { expect{ subject.class.create_from_omniauth(auth, user)}.to change{Identity.count}.by(1) }

      context 'with existed user' do
        before do
          create(:user, email: user[:email])
        end

        it { expect{ subject.class.create_from_omniauth(auth, user)}.not_to change{User.count} }
        it { expect( subject.class.create_from_omniauth(auth, user)).not_to be_valid }
        it { expect{ subject.class.create_from_omniauth(auth, user)}.not_to change{Identity.count} }
      end
    end

    context 'update existed identity' do
      let!(:existed_identity) { subject.class.create_from_omniauth(auth, user).identities.first }
      let(:new_auth) {
        {
          provider: 'facebook',
          uid: '12345',
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email,
          token: Faker::Crypto.sha256,
          expires_at: Time.now
        }
      }

      let(:created_identity) { subject.class.create_from_omniauth(auth, user).identities.first }

      it { expect{subject.class.create_from_omniauth(new_auth, user)}.not_to change{User.count} }
      it { expect{subject.class.create_from_omniauth(new_auth, user)}.not_to change{Identity.count} }
      it { expect(created_identity.persisted?).to be_truthy }
      it { expect(created_identity.email).to eq(auth[:email]) }
      it { expect(created_identity.first_name).to eq(auth[:first_name]) }
      it { expect(created_identity.token).to eq(auth[:token]) }
      it { expect(created_identity.expires_at).not_to be_nil }
    end
  end
end
