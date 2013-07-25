class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  def self.create_session_with_auth(auth)
    user = User.find_or_create_by(
      provider: auth["provider"],
      uid: auth["uid"]
    )
    user.name = auth["info"]["nickname"]
    user.save
    user.id
  end

  private
  def create_params
    params.require(:user).permit(:provider,:uid)
  end

  has_many :bot
end
