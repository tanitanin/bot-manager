class Bot < ActiveRecord::Base

  

  belongs_to :user
  has_many :daemon
end
