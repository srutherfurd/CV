require 'Random'


randomiser = Random.new(1234)
imageList = ['/Worgen.jpeg', '/Draenei.jpeg', '/Forsaken.jpeg', '/Night Elven Malukah.jpeg', '/Protoss.png', '/Hydralisk.png']


SCHEDULER.every '10s', :first_in => 0 do |job|
	begin
		randomiser.rand(imageList.length)
		File.open(path, 'rb') {|file| file.read}
		send_event('image_display', comments: images)
		end
	end