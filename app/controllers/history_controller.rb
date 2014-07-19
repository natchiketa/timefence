class HistoryController < ApplicationController
  def index
  end

  def tracks
    @data = File.read("public/history.json")

    render :json => @data
  end
end
