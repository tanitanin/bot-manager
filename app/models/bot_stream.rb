class BotStream < ActiveRecord::Base
  belongs_to :bot

  def self.add_from_raw_json(raw_data)
    
  end

end
