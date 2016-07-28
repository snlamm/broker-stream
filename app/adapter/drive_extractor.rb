class DriveExtractor

  @@credentials = Google::Auth::UserRefreshCredentials.new(
    client_id: ENV["google_id"],
    client_secret: ENV["google_secret"],
    scope: [
      "https://www.googleapis.com/auth/drive.readonly",
      "https://spreadsheets.google.com/feeds/",
    ],
    redirect_uri: "http://localhost:3000/oauth2callback")
# Redirect the user to auth_url and get authorization code from redirect URL.

  attr_reader :address

  def initialize(address)
    @address = address
  end

  def login_with_refresh_token
    @@credentials.refresh_token = ENV["google_refresh"]
    @@credentials.fetch_access_token!
    session = GoogleDrive.login_with_oauth(@@credentials)
    get_row_data(session)
  end

  def authorization_token_url
    auth_url = @@credentials.authorization_uri
    configured_url = auth_url.origin + auth_url.request_uri
  end

  def login_from_redirect(oauth_code)
    @@credentials.code = oauth_code
    @@credentials.fetch_access_token!
    session = GoogleDrive.login_with_oauth(@@credentials)
    get_row_data(session)
  end

  def get_row_data(google_session)
    sheet_rows = google_session.spreadsheet_by_title("Test Real Estate Data").worksheets[0].rows
    # set headers index to whatever row has the headers
    headers = sheet_rows[2]
    details = sheet_rows.detect {|row| row[5] == @address}
    set_headers_for_details(headers, details)
  end

  def set_headers_for_details(headers, details)
    counter = 0
    entries_with_headers = {}
    headers.collect do |header|
      entries_with_headers[header] = details[counter]
      counter += 1
    end
    entries_with_headers
  end

end
