def have_alert(alert_type, options = {})
    have_selector(".alert.alert-#{alert_type}", options)
end
