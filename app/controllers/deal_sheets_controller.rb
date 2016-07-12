class DealSheetsController < ApplicationController
  def new
    @deal_sheet = DealSheet.new
  end

  def create
    binding.pry
  end
end
