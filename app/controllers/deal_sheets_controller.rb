class DealSheetsController < ApplicationController
  def new
    @deal_sheet = DealSheet.new
  end
end
