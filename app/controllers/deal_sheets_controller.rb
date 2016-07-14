require "googleauth"
class DealSheetsController < ApplicationController
  @@address = nil
  @@credentials = Google::Auth::UserRefreshCredentials.new(
    client_id: ENV["google_id"],
    client_secret: ENV["google_secret"],
    scope: [
      "https://www.googleapis.com/auth/drive.readonly",
      "https://spreadsheets.google.com/feeds/",
    ],
    redirect_uri: "http://localhost:3000/oauth2callback")
  # Redirect the user to auth_url and get authorization code from redirect URL.
  def new
    @deal_sheet = DealSheet.new
  end

  def create
    @@address = deal_sheet_params["details"]
    # @deal_sheet = DealSheet.new
    begin
      @@credentials.refresh_token = ENV["google_refresh"]
      @@credentials.fetch_access_token!
      session = GoogleDrive.login_with_oauth(@@credentials)
      use_session(session)
    rescue
      auth_url = @@credentials.authorization_uri
      redirect_url = auth_url.origin + auth_url.request_uri
      redirect_to redirect_url
    end
  end

  def redirect
    @@credentials.code = params["code"]
    @@credentials.fetch_access_token!
    session = GoogleDrive.login_with_oauth(@@credentials)
    use_session(session)
  end

  def use_session(session)
    sheet_rows = session.spreadsheet_by_title("Test Real Estate Data").worksheets[0].rows
    target = sheet_rows.detect {|row| row[0] == @@address}
    binding.pry
  end

  def pdf
    binding.pry
    pdf = render_to_string pdf: "some_file_name", template: "deal_sheets/template.html.erb", encoding: "UTF-8"

    save_path = Rails.root.join('app','pdfs','deal_template.pdf')
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
  end

  private
  def deal_sheet_params
    params.require(:deal_sheet).permit(:details)
  end
end
