require 'open-uri'

filePath = "C:/Program Files/OpenVPN/config/password.txt"
url = "http://freevpn.me/accounts"
execpath = "C:/Program Files/OpenVPN/bin/openvpn-gui.exe"
ustring = "Username:</b>"
pstring = "Password:</b>"

def getStringInContent(searchFor, currentString)
	iIndex1 = currentString.index(searchFor,currentString.index(searchFor)+10)
	if iIndex1 != nil then
		iIndex2 = iIndex1 + searchFor.length
		fragment1 = currentString[iIndex2,30]
		iIndex3 = fragment1.index("<")
		fragment = fragment1[0,iIndex3]		
		fragment = fragment.gsub(/\s+/, "")				
		return fragment		
	end
	return ""
end

cnt = 0
oldusername = ""
oldpassword = ""

File.readlines(filePath).each do |line|
	if cnt == 0 then
		oldusername = line
		cnt = 1
	elsif cnt == 1 then
		oldpassword = line
		cnt = 2
	else
	
	end
end

oldusername = oldusername.gsub(/\s+/, "")
oldpassword = oldpassword.gsub(/\s+/, "")

content = ""
open(url) do |f|
	content = f.read
end

username = getStringInContent(ustring,content)
password = getStringInContent(pstring,content)

if oldusername != username or oldpassword != password then
	output = username + "\n" + password
	File.open(filePath,"w") do |f|
		f.puts(output)
		f.close()
		puts "Saved new account details"
	end
else
	puts "File did not change"
end


system("cmd /C \""+execpath+"\"")