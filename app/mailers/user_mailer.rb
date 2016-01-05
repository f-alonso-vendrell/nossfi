class UserMailer < ActionMailer::Base
  
  def notification_email(notification)
    @id = notification.id
    
    @act  = notification.act

    if ( notification.recipients.nil? )

      return

    end

    destinies = notification.recipients.split(",")

    #destinies.each do |destiny|

      # logger.info("mailing to "+destiny)

      if @act == "created"

          @form = Form.find(notification.id)

          mail(to: destinies, subject: 'Notification of Form creation', from: notification.from)

      elsif @act == "updated"

          @form = Form.find(notification.id)

          mail(to: destinies, subject: 'Notification of Form updated', from: notification.from)

      elsif @act == "deleted"

          mail(to: destinies, subject: 'Notification of Form deleted', from: notification.from)

      end 

    #end
   
  end

end
