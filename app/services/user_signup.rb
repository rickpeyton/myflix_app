class UserSignup

  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, friend_token)
    if @user.valid?
      customer = StripeWrapper::Customer.create(
          user: @user,
          source: stripe_token
        )
      if customer.successful?
        @user.save
        create_relationship(friend_token)
        RegisterMailer.welcome_email(@user).deliver
        @status = :success
        self
      else
        @status = :failed
        @error_message = customer.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Something went wrong."
      self
    end
  end

  def successful?
    @status == :success
  end

  private

  def create_relationship(friend_token)
    if friend_token.present?
      @invitation = Invitation.find_by(token: friend_token)
      leader = User.find(@invitation.user_id)
      Relationship.create(leader: leader, follower: @user)
      Relationship.create(leader: @user, follower: leader)
    end
  end

end
