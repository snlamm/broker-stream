require "googleauth"
class DealSheetsController < ApplicationController

  @@drive_extractor

  def show
    confirm_token = params[:token]
    @deal_sheet = DealSheet.find_by(confirm_token: confirm_token)
    if @deal_sheet
      render 'deal_sheets/deal_sheet', layout: false
    else
      flash[:alert] = "Invalid link. Please resubmit the address"
      redirect_to root_path
    end
  end

  def new
    # example input: 3 Maple Ave
    @deal_sheet = DealSheet.new
  end

  def create
    address = deal_sheet_params["details"].titleize
    @@drive_extractor = DriveExtractor.new(address)
    begin
      row_data = @@drive_extractor.login_with_refresh_token
      build_deal_sheet(row_data)
    rescue
      redirect_url = @@drive_extractor.authorization_token_url
      redirect_to redirect_url
    end
  end

  def redirect
    code = params["code"]
    row_data = @@drive_extractor.login_from_redirect(code)
    build_deal_sheet(row_data)
  end

  private
  def deal_sheet_params
    params.require(:deal_sheet).permit(:details)
  end

  def build_deal_sheet(row_data)
    binding.pry
    deal_sheet = DealSheet.new
    deal_sheet.details = row_data
    deal_sheet.save
    # send email
    # redirect to page with alert that email send for so and so address to such and such people
  end
end
