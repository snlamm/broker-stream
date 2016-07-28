class DriveExtractor

  @@credentials = Google::Auth::UserRefreshCredentials.new(
    client_id: ENV["google_id"],
    client_secret: ENV["google_secret"],
    scope: [
      "https://www.googleapis.com/auth/drive.readonly",
      "https://spreadsheets.google.com/feeds/",
    ],
    redirect_uri: "http://localhost:3000/oauth2callback")

  attr_reader :address

  def initialize(address)
    @address = address
  end

  def google_login
    begin
      @@credentials.refresh_token = ENV["google_refresh"]
      @@credentials.fetch_access_token!
      session = GoogleDrive.login_with_oauth(@@credentials)
      get_row_data(session)
    rescue
      auth_url = @@credentials.authorization_uri
      redirect_url = auth_url.origin + auth_url.request_uri
      redirect_to redirect_url
    end
  end


  def google_redirect_for_access_token(oauth_code)
    @@credentials.code = oauth_code
    @@credentials.fetch_access_token!
    session = GoogleDrive.login_with_oauth(@@credentials)
    get_row_data(session)
  end

  def get_row_data(google_session)
    sheet_rows = session.spreadsheet_by_title("Test Real Estate Data").worksheets[0].rows
    target = sheet_rows.detect {|row| row[0] == @address}
  end

  end

end
