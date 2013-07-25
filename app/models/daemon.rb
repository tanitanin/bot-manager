class Daemon < ActiveRecord::Base

  def self.start(command)
    daemon = Daemon.new
    daemon.command = command
    begin
      daemon.pid = Process.spawn(command)
    rescue
      throw Error
    else
      daemon.save
    end
    daemon
  end

  def self.stop(id)
    daemon = find(id)
    Process.kill('KILL',daemon.pid)
    Daemon.delete(id)
  end
  
  belongs_to :bot
end
