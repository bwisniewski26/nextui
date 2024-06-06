local function s(...) return sleep(...) end
local function aw(...) return write(...) end
local function p(...) return print(...) end
local function tw(...) return term.write(...) end
local function scp(...) return term.setCursorPos(...) end
local function sbc(...) return term.setBackgroundColor(...) end
local function stc(...) return term.setTextColor(...) end
local function tc(...) return term.clear(...) end
local function tcl(...) return term.clearLine(...) end
local function r(...) return shell.run(...) end
local function sp(...) return textutils.slowPrint(...) end
local function sw(...) return textutils.slowWrite(...) end
local function fse(...) return fs.exists(...) end
local function pul(...) return paintutils.loadImage(...) end
local function pud(...) return paintutils.drawImage(...) end
local function pfb(...) return paintutils.drawFilledBox(...) end
local function su(...) return os.shutdown(...) end
local function re(...) return os.reboot(...) end
local function pdp(...) return paintutils.drawPixel(...) end

args = {...}
w, h = term.getSize()

function loadSettings()
	if not fse("/os/main/.settings") then
		settingsFile = fs.open("/os/main/.settings", "w")
		settingsFile.write(textutils.serialize(settings))
		settingsFile.close()
	else 
		settingsFile = fs.open("/os/main/.settings", "r")
		settings = textutils.unserialize(settingsFile.readAll())
		settingsFile.close()
	end
	return settings
end

settings = {["check_updates"] = true, ["sound"] = false, ["background_color"] = 512, ["modem"] = false, ["animations"] = true, ["lang"] = 1}
languages = {"pl.lua", "eng.lua"}

settings = loadSettings()

function loadLang()

	local file = fs.open("/os/lang/"..languages[settings["lang"]], "r")
	lines = {}

	while true do
		local line = file.readLine()
	  
		if not line then break end
	  
		lines[#lines + 1] = line
	  end

	return lines
end

systemMessages = loadLang()
if (systemMessages == nil) then
	error("Nie wczytano jezyka!")
end
function ile_folderow(path)
	local files = fs.list(path)
	ile = 0
	for i,file in ipairs(files) do
		if fs.isDir(fs.combine(path,file)) then
				ile = ile+1
		end
	end
	return ile
end
	
	
function countFiles(path)
	local files = fs.list(path)
	fileCount = 0
	for i,file in ipairs(files) do
		fileCount = fileCount+1
	end
	return fileCount
end

function showFiles(path, y)
	temp = y
	sbc(colors.black)
	tc()
	sbc(colors.black)
	stc(colors.white)
	scp(1,1)
	if pocket then p(systemMessages[49] .. " " .. fs.getDir(path), path) else p(systemMessages[50] .. " " .. path) end
	scp(w,1)
	p("X")
	local files = fs.list(path)
	j = 1
	for i,file in ipairs(files) do
		if ((h-3)*j <= i) then j = j+1 y = temp end
		scp(2+((j-1)*10),y)
		if fs.isDir(fs.combine(path,file)) then
			if fs.isDir(fs.combine(path,file)) == "os/main/" then
				stc(colors.red)
				file = string.sub(file, 1, 9)
				term.write("[["..file.."]]")
				stc(colors.white)
			end
			stc(colors.yellow)
			file = string.sub(file, 1, 9)
			term.write("[["..file.."]]")
			stc(colors.white)
		else
			if path == "os/main" or file == "startup" then stc(colors.red) end
			file = string.sub(file, 1, 9)
			term.write(file)
			stc(colors.white)
		end
	y = y+1
	end
	scp(1,h)
	write(systemMessages[51])


end

function popup(path, file, arg)
	if (file ~= nil) then
		pfb(1,h-6, 15, h-6, colors.lightGray)
		scp(1,h-6)
		stc(colors.white)
		str = string.sub(fs.combine(path,file), 1, 15)
		write(str)
		pfb(1,h-5,15,h-1,colors.white)
		stc(colors.black)
		scp(1,h-5)
		p(systemMessages[52])
		p(systemMessages[53])
		p(systemMessages[54])
		p(systemMessages[55])
		mouse_button = retrieveMouseClickInfo()
		if mouse_button[1]>0 and mouse_button[1]<16 and mouse_button[2] == h-5 then
			status = shell.run(fs.combine(path,file))
		end
		if mouse_button[1]>0 and mouse_button[1]<16 and mouse_button[2] == h-4 then
			shell.setDir("/")
			shell.run("edit", fs.combine(path,file))
		end
		if mouse_button[1]>0 and mouse_button[1]<16 and mouse_button[2] == h-3 then
			fs.delete(fs.combine(path,file))
		end
		if mouse_button[1]>0 and mouse_button[1]<16 and mouse_button[2] == h-2 then
			scp(1,2)
			sbc(colors.white)
			stc(colors.black)
			write(systemMessages[56])
			new_path = read()
			if fse(fs.combine(path,new_path)) then
				fs.copy(fs.combine(path,file), fs.combine(path,new_path))
			end
		end

	else 
		pfb(1,h-4, 15, h-4, colors.lightGray)
		scp(1,h-4)
		stc(colors.white)
		p(systemMessages[57])
		pfb(1,h-3,15,h-1,colors.white)
		stc(colors.black)
		scp(1,h-3)
		p(systemMessages[58])
		p(systemMessages[59])
		mouse_button = retrieveMouseClickInfo()
		if mouse_button[1]>0 and mouse_button[1]<16 and mouse_button[2] == h-3 then
			scp(1,2)
			sbc(colors.white)
			stc(colors.black)
			p(systemMessages[60])
			nowy_folder = read()
			fs.makeDir(fs.combine(path,nowy_folder))
		end
		if mouse_button[1]>0 and mouse_button[1]<16 and mouse_button[2] == h-2 then
			scp(1,2)
			sbc(colors.white)
			stc(colors.black)
			write(tostring(systemMessages[61]))
			nowy_plik = read()
			shell.setDir("/")
			plik = fs.combine(path,nowy_plik)
			r("edit", plik)
		end
	end

	return
end

function listFiles(path)
arg = {}
local files = fs.list(path)
y = 1
for i,file in ipairs(files) do
	arg[y] = file
	y = y+1
end
a = 1
scp(1,10)
arg[y+1] = y
return arg
end

function retrieveMouseClickInfo()
	local event, button, x, y = os.pullEvent("mouse_click")
	mouse_button = {x, y, button}
	return mouse_button
end


function Help(path)
	tc()
	w, h = term.getSize()
	scp(w,1)
	p("X")
	scp(1,2)
	p(systemMessages[62])
	p(systemMessages[63])
	p(systemMessages[64])
	p(systemMessages[65])
	p(systemMessages[66])
	p(systemMessages[67])
	p(systemMessages[68])
	mouse_button = retrieveMouseClickInfo()
	if (mouse_button[1] == w and mouse_button[2] == 1) then main(path) end
end


function main(path) 
	while true do
	shell.setDir(path)
	w, h = term.getSize()
		showFiles(path, 3)
		arg = listFiles(path)
		ile = countFiles(path)
		
		mouse_button = retrieveMouseClickInfo()
		-- mouse_button_y = mouse_button[2]-2
		if (mouse_button[1]<11) then 
			mouse_button_y = mouse_button[2] - 2
		elseif (mouse_button[1]>10 and mouse_button[1]<21) then
			mouse_button_y = (math.floor(mouse_button[1]/10)*10)+mouse_button[2]+3
		elseif (mouse_button[1]>20 and mouse_button[1]<31) then
			mouse_button_y = (math.floor(mouse_button[1]/10)*10)+mouse_button[2]+9
		elseif (mouse_button[1]>30 and mouse_button[1]<41) then
			mouse_button_y = (math.floor(mouse_button[1]/10)*10)+mouse_button[2]+15
		elseif (mouse_button[1]>40 and mouse_button[1]<51) then
			mouse_button_y = (math.floor(mouse_button[1]/10)*10)+mouse_button[2]+21
		end
		if (mouse_button[1]>1 and mouse_button[1]<5 and mouse_button[2] == h) then
			Help(path)
		end
		if (mouse_button[1]>6 and mouse_button[1]<11 and mouse_button[2] == h) then
			scp(1,2)
			write(".>")
			name = read()
			if fs.isDir(name) == true then main(name) end
		end
		if (mouse_button[1] > 11 and mouse_button[1] < 16 and mouse_button[2] == h) then
			popup(path, nil, arg)
		end
		if (mouse_button[1] == w and mouse_button[2] == 1) then error() end
		if (mouse_button[1] == 1 and mouse_button[2] == 1) then
			path = fs.getDir(path)
			if (path == "") then path = "/" end
			break
		end
		if (mouse_button[1]>0 and mouse_button[1]<w and mouse_button_y<ile+1 and mouse_button_y>0 and mouse_button[3] == 2) then
			if fs.exists(fs.combine(path,arg[mouse_button_y])) then
				popup(path, arg[mouse_button_y])
				break
			end
		end
		if (mouse_button[1]>0 and mouse_button[1]<w and mouse_button_y<ile+1 and mouse_button_y>0 and mouse_button[3] == 1) then
			if fs.isDir(fs.combine(path,arg[mouse_button_y])) then
				path = fs.combine(path,arg[mouse_button_y])
				main(path)
			else
				if fs.exists(fs.combine(path,arg[mouse_button_y])) then
					tc()
					status = shell.run(arg[mouse_button_y])
					if status == false then
							logi = fs.open("/os/logs", "a")
							logi.writeLine("------")
							logi.writeLine("error while running file")
							logi.writeLine("------")
							logi.close()
							sbc(colors.black)
							tc()
							sbc(colors.black)
							stc(colors.white)
							scp(1,2)
							arg_lua = string.sub(arg[mouse_button_y], 1, 6)
							if arg_lua ~= "luaide" then p(systemMessages[70]) end
							s(1)
							break
						end
				end
			end
		end
	end
end
path = "/"
shell.setDir("/")
while true do
if (args[1] == nil) then main(path) else main(args[1]) end
end