def have_alert(alert_type, options = {})
    have_selector(".ALERT-#{alert_type}", options)
end
