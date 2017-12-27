class Api::V1::ConfirmationsController < Devise::ConfirmationsController
  require "bunny"
  include Deviseable

  skip_before_action :parse_user_from_token
  skip_before_action :authenticate_user_from_token!

  # POST /v1/confirmation
  #
  # Send a code included 6 numerics for user validate their account
  # This function just create the code, save to database call to backgroud job for sending SMS

  #   parameters:
  #     - phone_number: string
  #
  #   response:
  #     - result message: string
  def create
     # find user who had the phone number like input
      user = User.find_by phone_number: params[:phone_number]
      raise Devise::Unknowuser unless user.present?
      # create a random code and save, notice that this code is unique
      # verify_code = 6.times.map{rand(10)}.join
      # user.verify_code = verify_code

      # # make sure verify code is unique
      # until user.valid?
      #   verify_code = 6.times.map{rand(10)}.join
      #   user.verify_code = verify_code
      # end

      # FIXME: hardcode this for now
      verify_code = "686868"
      user.verify_code = verify_code

      raise Devise::Unablesaved unless user.save

      # make a job for sending sms
      send_message verify_code

      # return ok status
      render status: :ok, json: { success: true }
  end

  # GET /v1/confirmation?verify_code=123456
  #
  # User has to enter the code included 6 digits to verify their account
  # If the code is correct, then system will get his login and return an jwt

  #   parameters:
  #     - verify_code: string
  #
  #   response:
  #     - json:
  #         - jwt: token string
  #         - user: object
  def show
    # find user who had the verify code like input

    user = User.find_by verify_code: params[:verify_code]
    raise Devise::Unknowuser unless user.present?

    # Activate this user
    user.is_activated = true
    user.verify_code = nil
    raise Devise::Unablesaved unless user.save

    # trigger sign in
    sign_in user, store: false

    # if everything ok, return the authenticated user
    render json: user, serializer: serializer
  end

  private

  # create sending sms job and push to queue
  # The rabbit server will take this job to send sms to user
  def send_message(data)
    conn    = Bunny.new
    conn.start
    ch      = conn.create_channel
    q       = ch.queue("test.sms")
    q.publish(data)
    conn.close
  end

  # serialize the user object and include the token
  def serializer
    AuthenticatedUserSerializer
  end
end
