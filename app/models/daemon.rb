class Daemon < ActiveRecord::Base
  belongs_to :bot

  def self.start(bot_id,command,*args)

    if ! Daemon.where(:command => command).empty? then
      return nil
    end

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
    daemon.kill if daemon
  end

  def kill
  rescue
    Process.kill('KILL',pid)
  ensure
    delete
  end

end
