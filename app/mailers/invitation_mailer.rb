class InvitationMailer < ActionMailer::Base
  def invitation_email(invitation)
    @invitation = invitation
    @user = User.find(invitation.user_id)
    mail(from: "peytorb@gmail.com", to: @invitation.friend_email, subject: "#{@user.name} has invited you to join MyFlix!")
  end
end
