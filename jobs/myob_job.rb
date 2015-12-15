require 'json'
require 'open-uri'

# Job list for NZ ONLY
def webToList(url, marker)

	webpage = open(url)
	html = webpage.read
	newHTML = ""

	for char in html.split("")
	  if char == ">" or char == "=" or char == "-"
	      newChar = "<"
	  elsif char == "\n" or char == "\r" or char == "\t"
	  newChar = ""
	  else
	    newChar = char
	  end
	  newHTML += newChar

	end
	htmlList = newHTML.split("<")
	jobList = []
	if marker != "\"jbTableTextStyle\" nowrap"
	    for item in htmlList
	      if item == marker
	        jobList.push(htmlList[(htmlList.find_index(item))+1])
	        htmlList.delete_at(htmlList.find_index(item))
	      end
	    end
    else
	    for item in htmlList
	      if item == marker
	        combine = htmlList[(htmlList.find_index(item))+1]+"-"
	        combine +=htmlList[(htmlList.find_index(item))+2]+"-"
	        combine +=htmlList[(htmlList.find_index(item))+3]
	        jobList.push(combine)
	        htmlList.delete_at(htmlList.find_index(item))
	      end
	    end
    end
	return jobList
end



def arrayOfList(jobList, dateList, locList)
  iterate = 0

  arrayOf=[]
  for item in 0..(jobList.count-1)
    if jobList.count%2 == 0
      if iterate <= jobList.count-1
        data = {:label=> jobList[iterate], :value=> (dateList[iterate].to_s+locList[iterate].to_s)}
        iterate+=1
        arrayOf.push(data)
      end
    else
      if iterate != jobList.count-1
        data = {:label=> jobList[iterate], :value=> dateList[iterate].to_s+locList[iterate].to_s}
        iterate+=1
        arrayOf.push(data)
      else
        data = {:label=> jobList[iterate], :value=> dateList[iterate].to_s+locList[iterate].to_s}
        arrayOf.push(data)
      end
    end
  end
  return arrayOf
end


SCHEDULER.every '12h', :first_in => 0 do |job|

	jobListNZ = webToList("http://fsr.cvmail.com.au/myob/main.cfm?page=jobBoard&fo=1&groupType_7=&groupType_8=7173&groupType_8=7174&groupType_8=7414&groupType_11=&filter", "\"jobMoreDetailCaptionStyle\"")
	jobListAU = webToList("http://fsr.cvmail.com.au/myob/main.cfm?page=jobBoard&fo=1&groupType_7=&groupType_8=7172&groupType_8=7170&groupType_8=7175&groupType_8=7168&groupType_8=7171&groupType_8=7169&groupType_11=&filter", "\"jobMoreDetailCaptionStyle\"")

	dateListNZ = webToList("http://fsr.cvmail.com.au/myob/main.cfm?page=jobBoard&fo=1&groupType_7=&groupType_8=7173&groupType_8=7174&groupType_8=7414&groupType_11=&filter", "\"jbTableTextStyle\" nowrap")
	dateListAU = webToList("http://fsr.cvmail.com.au/myob/main.cfm?page=jobBoard&fo=1&groupType_7=&groupType_8=7172&groupType_8=7170&groupType_8=7175&groupType_8=7168&groupType_8=7171&groupType_8=7169&groupType_11=&filter", "\"jbTableTextStyle\" nowrap")

	locationListNZ = webToList("http://fsr.cvmail.com.au/myob/main.cfm?page=jobBoard&fo=1&groupType_7=&groupType_8=7173&groupType_8=7174&groupType_8=7414&groupType_11=&filter", "color: ; height: 18px;\"")
	locationListAU = webToList("http://fsr.cvmail.com.au/myob/main.cfm?page=jobBoard&fo=1&groupType_7=&groupType_8=7172&groupType_8=7170&groupType_8=7175&groupType_8=7168&groupType_8=7171&groupType_8=7169&groupType_11=&filter", "color: ; height: 18px;\"")

	NZList = arrayOfList(jobListNZ,dateListNZ,locationListNZ)
	AUList = arrayOfList(jobListAU,dateListAU,locationListAU)

	send_event('job_list_NZ', {items: NZList })
	send_event('job_list_AU', {items: AUList })


end


