


SCHEDULER.every '20m', :first_in => 0 do |job|
    url = "http://www.youtube.com/embed/XGSy3_Czz8k"
    puts url
    send_event('myiframe', src: url)
end