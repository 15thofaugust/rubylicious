module NotificationsHelper

  def noti_items
    @noti_items = current_user.passive_notifications
  end

  def noti_number
    noti_items
    i = 0
    @noti_items.each do |noti|
      if !noti.isSeen
        i += 1
      end
    end
    i
  end
end
