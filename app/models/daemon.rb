class Daemon < ActiveRecord::Base
  belongs_to :bot

  def self.start(bot_id,command,*args)

    tmp = fork do
      daemon = Daemon.new
      daemon.bot_id = bot_id
      daemon.command = command
      daemon.pid = Process.pid
      daemon.save

      if command == :userstream then
        bot = Bot.find(bot_id)
        bot.userstream
      end

      Daemon.delete_all(pid: Process.pid)
    end
    Process.detach(tmp)
  end

  def self.stop(id)
    daemon = find(id)
    Process.kill('KILL',daemon.pid)
    Daemon.delete(id)
  end

end
