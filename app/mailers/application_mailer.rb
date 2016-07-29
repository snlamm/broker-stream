class ApplicationMailer < ActionMailer::Base

  def send_deal_sheet(deal_sheet)
    @deal_sheet = @deal_sheet
    broker_email = @deal_sheet.details["broker_email"]
    @address = @deal_sheet.details["ADDRESS"]
    mail(
      to: ENV['exec_email'],
      cc: broker_email,
      subject: "Broker-Stream: #{address} Deal Sheet"
    )
  end
  
end
