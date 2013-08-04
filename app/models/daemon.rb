class Daemon < ActiveRecord::Base
  belongs_to :bot

  def self.start(bot_id,command,*args)
    logger.info("Daemon.start #{bot_id} #{command}")

    if ! Daemon.where(:command => command).empty? then
      logger.info("Daemon.start #{command} already exists") 
      return nil
    end

    logger.info("Daemon.start fork") 
    tmp = fork do
      daemon = Daemon.new
      daemon.bot_id = bot_id
      daemon.command = command
      daemon.pid = Process.pid
      daemon.save
      logger.info("pid:#{daemon.pid} saved")

      if command == "userstream" then
        logger.info("pid:#{Process.pid} userstream")
        bot = Bot.find(bot_id)
        bot.userstream
        logger.info("pid:#{Process.pid} userstream ended")
      end

      Daemon.delete_all(pid: Process.pid)
      logger.info("pid:#{Process.pid} delete_all")
    end
    Process.detach(tmp)
  end

  def self.stop(bot_id,command)
    Daemon.where(
      :bot_id => bot_id,
      :command => command
    ).each do |daemon|
      daemon.kill
    end
  end

  def kill
    begin
      Process.kill('KILL',pid)
    rescue
      logger.info("pid:#{pid} kill error")
    ensure
      delete
      logger.info("pid:#{pid} killed")
    end
  end

end
