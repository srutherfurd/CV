require 'Random'

imageList = ['/Worgen.jpeg', '/Draenei.jpeg', '/Forsaken.jpeg', '/Night Elven Malukah.jpeg', '/Protoss.png', '/Hydralisk.png']


SCHEDULER.every '10s', :first_in => 0 do |job|
	begin
		images = imageList[rand(imageList.length)]
		send_event('image_display', comments: images)
		end
	end