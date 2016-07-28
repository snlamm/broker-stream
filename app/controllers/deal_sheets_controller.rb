require "googleauth"
class DealSheetsController < ApplicationController

  @@drive_extractor

  def new
    # example input: 3 Maple Ave
    @deal_sheet = DealSheet.new
  end

  def create
    address = deal_sheet_params["details"]
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

  def pdf
    render 'deal_sheets/template', layout: false
  end

  private
  def deal_sheet_params
    params.require(:deal_sheet).permit(:details)
  end

  def build_deal_sheet(row_data)
    # address = row_data['ADDRESS']
    # binding.pry
    # deal_sheet = DealSheet.find_or_create_by(details: {'ADDRESS' => address})
    deal_sheet = DealSheet.new
    deal_sheet.details = row_data
    deal_sheet.save
    # create an address column for dealsheet and use that in a find or create_by
    # set a token for deal_sheet
  end
end
