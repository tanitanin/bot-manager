class DaemonController < ApplicationController

  before_action :authenticate?, only: [
    :start,
    :stop
  ]

  def start
    Daemon.start(params[:bot],params[:command])
    flash[:notice] = "#{params[:command]} successfully started"
    redirect_to :root
  end

  def stop
    Daemon.stop(params[:bot],params[:command])
    flash[:notice] = "#{params[:command]} successfully stopped"
    redirect_to :root
  end

end
