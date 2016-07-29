class DealSheetMailer < ApplicationMailer
  default from: ENV['email']

  def send_deal_sheet(deal_sheet)
    @deal_sheet = deal_sheet
    broker_email = @deal_sheet.details["broker_email"]
    @address = @deal_sheet.details["ADDRESS"]
    @headers = deal_sheet.details.keys
    @content = deal_sheet.details.values
    mail(
      to: ENV['exec_email'],
      cc: broker_email,
      subject: "Broker-Stream: #{@address}"
    )
  end
end
