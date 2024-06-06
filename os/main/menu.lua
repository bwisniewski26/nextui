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
-- Domyslne wartosci
settings = {["check_updates"] = true, ["sound"] = false, ["background_color"] = 512, ["modem"] = false, ["animations"] = true, ["lang"] = 2, ["shell"] = false}
languages = {"pl.lua", "eng.lua"}
w,h = term.getSize()
mon = false
args = {...}

if not fse("/user") then fs.makeDir("/user") end

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
	  

function nilToNotFound(str)
	if str == nil then str = "X" end
	return str
end

function findPeripherals()
	peripherals = {}
	
	peripherals[1] = nilToNotFound(peripheral.getType("top"))
	peripherals[2] = nilToNotFound(peripheral.getType("bottom"))
	peripherals[3] = nilToNotFound(peripheral.getType("left"))
	peripherals[4] = nilToNotFound(peripheral.getType("right"))
	peripherals[5] = nilToNotFound(peripheral.getType("front"))
	peripherals[6] = nilToNotFound(peripheral.getType("back"))

	return peripherals
end

function changeSetting(setting) 
	settingsFile = fs.open("/os/main/.settings", "w")
	settingsFile.write(textutils.serialize(settings))
	settingsFile.close()
end



function findPeriph(setting) 
	if peripheral.find("speaker") then
		setting["sound"] = true
	else
		setting["sound"] = false
	end
	if peripheral.find("modem") then
		setting["modem"] = true
	else
		setting["modem"] = false
	end
	return setting
end

function loadSettings()
	if not fse("/os/main/.settings") then
		settings = findPeriph(settings)
		settingsFile = fs.open("/os/main/.settings", "w")
		settingsFile.write(textutils.serialize(settings))
		settingsFile.close()
	else 
		settingsFile = fs.open("/os/main/.settings", "r")
		settings = textutils.unserialize(settingsFile.readAll())
		settings = findPeriph(settings)
		settingsFile.close()
	end
	return settings
end

function downloadFile(url, sciezka)
    local response = http.get(url)
    if response then
        local fileContent = response.readAll()
        response.close()
        
        local file = fs.open(sciezka, "w")
        file.write(fileContent)
        file.close()
		return 1
    else
		return 0
    end
end

function checkVersion()
	if settings["check_updates"] == false then return end
	if updateAvailable == 0 or updateAvailable == 1 then return end
	if not fse("/os/main/.ver") then
		verFile = fs.open("/os/main/.ver", "w")
		verFile.write("21")
		verFile.close()
	end
	verFile = fs.open("/os/main/.ver", "r")
	currentVer = verFile.readLine()
	verFile.close()
	if not fse("/os/main/.newVer") then 
		if downloadFile("https://pastebin.com/raw/1WnvDVEK", "/os/main/.newVer") == 0 then
			return
		end
	end
	newFile = fs.open("/os/main/.newVer", "r")
	newVer = newFile.readLine()
	newFile.close()
	fs.delete("/os/main/.newVer")
	if (currentVer < newVer) then 
		return 1
	else
		return 0
	end
end

function nilToBrak(str)
	if str == nil then str = "Brak" end
	return str
end

function findPeripherals()
	peripherals = {}
	
	peripherals[1] = nilToBrak(peripheral.getType("top"))
	peripherals[2] = nilToBrak(peripheral.getType("bottom"))
	peripherals[3] = nilToBrak(peripheral.getType("left"))
	peripherals[4] = nilToBrak(peripheral.getType("right"))
	peripherals[5] = nilToBrak(peripheral.getType("front"))
	peripherals[6] = nilToBrak(peripheral.getType("back"))

	return peripherals
end

-- Zmienne ogolne --

colory = {"1", "2", "8", "32", "64", "128", "256", "512", "1024", "2048", "4096", "8192", "16384", "32768"}
floppy = 0
peripherals = findPeripherals()
updateAvailable = 0 --checkVersion()
sides = {"top", "bottom", "left", "right", "front", "back"}


function soundHandler(sound)
	speaker = peripheral.find("speaker")
	if speaker then
		if sound == "boot" then 
			speaker.playNote("pling", 20, 20)
			speaker.playSound("minecraft:entity.villager.celebrate")
		elseif sound == "pop_up" then
			speaker.playNote("hat")
		elseif sound == "error" then
			speaker.playNote("pling")
		elseif sound == "critical_error" then
			count = 0
			while count < 5 do
				speaker.playNote("pling")
				s(0.4)
				count = count+1
			end
		end
	end
end	


function popUp(msg)
	middleW = math.floor(w/2)
	middleH = math.floor(h/2)
	popupDim = {middleW-20, middleH-3, middleW+20, middleH+3}
	pfb(popupDim[1], popupDim[2], popupDim[3], popupDim[4], colors.white)
	scp(middleW-20, middleH-2)
	stc(colors.black)
	if msg == "disk_insert" then
		p(systemMessages[1])
	elseif msg == "disk_eject" then
		p(systemMessages[2])
	elseif msg == "update" then
		p(systemMessages[3])
		scp(middleW-20, middleH-1)
		p(systemMessages[4])
	elseif msg == "monitor_found" then
		p(systemMessages[5])
		scp(middleW-20, middleH-1)
		p(systemMessages[6])
	end
	pfb(middleW-20, middleH-3, middleW+20, middleH-3, colors.blue)
	scp(middleW-20, middleH-3)
	stc(colors.white)
	if msg == "disk_insert" or msg == "disk_eject" then
		p(systemMessages[7])
	elseif msg == "update" then
		print(systemMessages[8])
		updateAvailable = 0
	elseif msg == "monitor_found" then
		p(systemMessages[9])
	end
	pfb(middleW-20, middleH+3, middleW-19, middleH+3, colors.gray)
	scp(middleW-20, middleH+3)
	stc(colors.white)
	if msg ~= "monitor_found" then
		p("OK")
	else
		p(systemMessages[10])
	end
	soundHandler("pop_up")
	color = get_color()
	klik = mouseClick()
	if msg ~= "monitor_found" then
		if klik[2] == middleH+3 and klik[1] > middleW-21 and klik[1] < middleW-18 then s(0.1) end
	else
		if klik[1] > middleW-21 and klik[1] < middleW-18 and klik[2] == middleH+3 then 
			tc()
			pfb(1,1,w,h,colors.black)
			scp(1,1)
			stc(colors.white)
			p(systemMessages[11])
			return 6 
		end
		return
	end
	return
end

function bsod(reason)
	soundHandler(critical_error)
	sbc(colors.blue)
	tc()
	sbc(colors.blue)
	stc(colors.white)
	ac = w/2
	scp(ac-2,3)
	sbc(colors.white)
	stc(colors.black)
	p("NextUI")
	sbc(colors.blue)
	stc(colors.white)
	scp(1,6)
	p(systemMessages[12])
	p(systemMessages[13])
	s(4)
	p(systemMessages[14], reason)
	p("")
	p("")
if (reason == "NextExplorer Missing") then
	p(systemMessages[15])
	status = downloadFile("https://pastebin.com/raw/za0ck7T5", "/os/main/explorer")
	if status == 1 then 
		p(systemMessages[16])
	else
		p(systemMessages[17])
		p("")
		error("Explorer missing.")
	end
	s(1)
	end
	s(10)
	p(systemMessages[18])
end

function get_color()
	color = settings["background_color"]
	--if color == nil then color = 2048 end
return tonumber(color)
end

function mouseClick()
	local event, button, x, y = os.pullEvent("mouse_click")
    klik = {x, y, button}
    return klik
end


function devMgr()
while true do
pfb(1,1,w,1,colors.blue)
stc(colors.white)
scp(1,1)
p("NextUI Device Manager")
pfb(1,2,w,h,colors.black)
pdp(w,1,colors.red)
stc(colors.white)
pfb(1,h,5,h,colors.black)
scp(1,h)
stc(colors.white)
write("Start")
pfb(6,h,w,h,colors.blue)
pdp(w,h,colors.red)
pdp(w-1,h,colors.orange)
sbc(colors.black)
scp(1,2)
stc(colors.white)
p("NextUI Compatible PC")
local char1 = "\149"
p(char1)
p(char1)
local char2 = "\131"
for i = 5,14 do
	scp(1,i)
	p(char1)
end

peripheralsFound = findPeripherals()

scp(2,5)
p(char2,"Top ", peripheralsFound[1])
scp(2,7)
p(char2, "Bottom", peripherals[2])
scp(2,9)
p(char2, "Left", peripherals[3])
scp(2,11)
p(char2, "Right", peripherals[4])
scp(2,13)
p(char2, "Front", peripherals[5])
scp(2,15)
p(char2, "Back", peripherals[6])
klik = mouseClick()

if klik[1] == w and klik[2] == 1 then break end
if klik[1]>0 and klik[1]<6 and klik[2] == h then start() end
if klik[1] == w-1 and klik[2] == h then re() end
if klik[1] == w and klik[2] == h then su() end

end

end

function draw(color)
	color = get_color()
	local char = "\142"
	local char2 = "\16"
	pfb(1,2,w,h-1,color)
	pfb(1,1,w,1,colors.black)
	pfb(6,h,w,h,colors.blue)
	pfb(1,h,5,h,colors.black)
	stc(colors.white)
	scp(1,h)
	write("Start")
	sbc(colors.black)
	stc(colors.white)
	if h>=19 and w>=51 then
		scp(1,1)
		p("NextUI 2.1 - Peripherals Update")
		if settings["sound"] == true then
			stc(colors.green)
			scp(w-1,1)
			p(char2)
			stc(colors.white)
		end
		if settings["modem"] == true then
			stc(colors.green)
			scp(w,1)
			p(char)
			stc(colors.white)
		end
	end
	pdp(w,h,colors.red)
	pdp(w-1,h,colors.orange)
	sbc(color)
	stc(colors.yellow)
	scp(2,3)
	p(systemMessages[19])
	if fse("/User") then
		stc(colors.yellow)
		scp(2,4)
		p("[[User]]")
	end
    if fse("/nshop") then
        stc(colors.yellow)
		scp(2,5)
		p("[[nshop]]")
	end
	if fse("/disk") and floppy == 1 then
		stc(colors.yellow)
		sbc(color)
		scp(2,6)
		p("[[Floppy]]")
	end
	if fse("/disk") and floppy == 0 then
		floppy = 1
		popUp("disk_insert")
		stc(colors.yellow)
		sbc(color)
		scp(2,6)
		p("[[Floppy]]")
	end
	if not fse("/disk") and floppy == 1 then
		floppy = 0
		popUp("disk_eject")
		scp(1,6)
		sbc(color)
		stc(color)
		term.clearLine()
	end

	if updateAvailable == 1 then
		popUp("update")
		updateAvailable = 0
	end
end

function mouseClick()
if event == "terminate" then
	error()
end
 local event, button, x, y = os.pullEvent("mouse_click")
klik = {x, y, button}
return klik
end

function start()
	pfb(1,h-4,15,h-5,colors.white)
	scp(1,h-5)
	stc(colors.black)
	p("Explorer")
	pfb(1,h-4,15,h-1,colors.black)
	scp(1,h-4)
	sbc(colors.black)
	stc(colors.white)
	p(systemMessages[20])
	p(systemMessages[21])
	p(systemMessages[22])
	p(systemMessages[23])
	klik = mouseClick()
	if (klik[1]>0 and klik[1]<16 and klik[2] == h-1) then
			scp(1,1)
			sbc(colors.black)
			tc()
			sbc(colors.black)
			stc(colors.white)
			return 512
	end
	if (klik[1]>0 and klik[1]<16 and klik[2] == h-3) then
			r("pastebin run 7qMxuP59")
	end
	if (klik[1]>0 and klik[1]<16 and klik[2] == h-2) then
			ustawienia()
	end
	if (klik[1]>0 and klik[1]<16 and klik[2] == h-4) then
			r("/os/main/terminal.lua")
			
	end
	if (klik[1]>1 and klik[1]<20 and klik[2] == h-5) then
		r("/os/main/explorer.lua")
	end
end


function infust()
	pfb(6,h,w,h,colors.blue)
	pfb(1,h,5,h,colors.black)
	scp(1,h)
	stc(colors.white)
	write("Start")
	pdp(w,1,colors.red)
	pfb(1,2,w,h-1,colors.black)
    pdp(w,h,colors.red)
    pdp(w-1,h,colors.orange)
	scp(1,1)
	sbc(colors.blue)
	stc(colors.white)
	p(systemMessages[24])
	sbc(colors.black)
	p(systemMessages[25])
	p(systemMessages[26], os.getComputerLabel())
	p(systemMessages[27], w, "x", h)
	miejsce = math.floor(((fs.getFreeSpace("/")/1024)/1024))
	p(systemMessages[28], miejsce, "MB")
	p(systemMessages[29], os.version())
	while true do
		klik = mouseClick()
		if (klik[1] == w and klik[2] == 1) then break end
		if klik[1]>0 and klik[1]<6 and klik[2] == h then start() end
	end
end

function kol_plik(color)
		desk_col_file = fs.open("/os/desk_color", "w")
		desk_col_file.write(color)
		desk_col_file.close()
end

function desk_ust()
	while true do
    pfb(6,h,w,h,colors.blue)
	pfb(1,h,5,h,colors.black)
	scp(1,h)
	stc(colors.white)
	write("Start")
	pdp(w,1,colors.red)
	pfb(1,2,w,h-1,colors.black)
    pdp(w,h,colors.red)
    pdp(w-1,h,colors.orange)
	scp(1,1)
	sbc(colors.blue)
	stc(colors.white)
	p(systemMessages[31])
	scp(1,2)
	sbc(colors.black)
    p(systemMessages[32])
	klik = mouseClick()
	if klik[1] == w and klik[2] == 1 then break end
	if klik[1]>0 and klik[1]<6 and klik[2] == h then start() end
	if klik[1]>0 and klik[1]<25 and klik[2] == 2 then
		paintutils.drawBox(1,6,16,8, colors.white)
		pdp(1, 7, 1)
		pdp(2, 7, 2)
		pdp(3, 7, 8)
		pdp(4, 7, 32)
		pdp(5, 7, 64)
		pdp(6, 7, 128)
		pdp(7, 7, 256)
		pdp(8, 7, 512)
		pdp(9, 7, 1024)
		pdp(10, 7, 2048)
		pdp(11, 7, 4096)
		pdp(12, 7, 8192)
		pdp(13, 7, 16384)
		klik2 = mouseClick()

		settings["background_color"] = colory[klik2[1]]
		changeSetting(settings)

		break
	end
    end
end

function godz()
i = 0
for i=0,60,1 do
	scp(w-6,h)
	stc(colors.white)
	sbc(colors.blue)
	if i == 0 then
	write( textutils.formatTime(os.time("local"), true ) )
	end
end
sbc(colors.black)
end

function ust()
	while true do
    pfb(6,h,w,h,colors.blue)
	pfb(1,h,5,h,colors.black)
	scp(1,h)
	stc(colors.white)
	write("Start")
	pdp(w,1,colors.red)
	pfb(1,2,w,h-1,colors.black)
    pdp(w,h,colors.red)
    pdp(w-1,h,colors.orange)
	scp(1,1)
	sbc(colors.blue)
	stc(colors.white)
	p(systemMessages[33])
	sbc(colors.black)
	p(systemMessages[34])
	p(systemMessages[35])
	p(systemMessages[36])
	p(systemMessages[37])
	if (settings["check_updates"] == true) then 
		stc(colors.green) 
	else 
		stc(colors.red) 
	end
	scp(1,6)
	p(systemMessages[38])
	if (settings["sound"] == true) then 
		stc(colors.green) 
	else 
		stc(colors.red) 
	end
	scp(1,7)
	p(systemMessages[39])
	if (settings["modem"] == true) then 
		stc(colors.green) 
	else 
		stc(colors.red) 
	end
	scp(1,8)
	p(systemMessages[40])
	scp(1,9)
	if (settings["animations"] == true) then 
		stc(colors.green) 
	else 
		stc(colors.red) 
	end
	p(systemMessages[41])
	stc(colors.white)
	p(systemMessages[48])
	scp(1,h-1)
	stc(colors.white)
	p(systemMessages[42])
	stc(colors.white)
	while true do
        klik = mouseClick()
		if klik[1] == w and klik[2] == 1 then return end
        if klik[1]>0 and klik[1]<25 and klik[2]==2 then
            scp(1,10)
            p(systemMessages[43])
            newName = read()
            os.setComputerLabel(newName)
        end
        if klik[1]>0 and klik[1]<25 and klik[2]>=3 and klik[2]<=5 then
            r("wget run https://raw.githubusercontent.com/bwisniewski26/nextui/main/update.lua")
        end
		if klik[1]>0 and klik[1]<25 and klik[2]==6 then
			if settings["check_updates"] == true then
				settings["check_updates"] = false
				changeSetting(settings)
				break
			else
				settings["check_updates"] = true
				changeSetting(settings)
				break
			end
		end
		if klik[1]>0 and klik[1]<25 and klik[2] == 9 then
			if settings["animations"] == true then
				settings["animations"] = false
				changeSetting(settings)
				break
			else
				settings["animations"] = true
				changeSetting(settings)
				break
			end
		end
		if klik[1]>0 and klik[1]<25 and klik[2] == 10 then
			if settings["lang"] == 1 then
				settings["lang"] = 2
				changeSetting(settings)
				systemMessages = loadLang()
				return
			else
				settings["lang"] = 1
				changeSetting(settings)
				systemMessages = loadLang()
				return
			end
		end
	end
	end
end

function ustawienia()
	color = get_color()
	scp(1,1)
	sbc(tonumber(color))
	if settings["animations"] == true then
		for i=1,w,1 do
		scp(i,1)
		textutils.slowPrint(" ", 100)
		end
	else
		pfb(1,1,w,1,tonumber(color))
	end
	sbc(colors.blue)
	scp(1,1)
	if settings["animations"] == true then
		for i=1,w,1 do
		scp(i,1)
		textutils.slowPrint(" ", 100)
		end
	else
		pfb(1,1,w,1,tonumber(color))
	end
while true do
	pfb(6,h,w,h,colors.blue)
	pfb(1,h,5,h,colors.black)
	scp(1,h)
	stc(colors.white)
	write("Start")
	pdp(w,1,colors.red)
	pfb(1,2,w,h-1,colors.black)
    pdp(w,h,colors.red)
    pdp(w-1,h,colors.orange)
	scp(1,1)
	stc(colors.white)
	sbc(colors.blue)
	if settings["animations"] == true then
		textutils.slowPrint(systemMessages[33])
	else
		p(systemMessages[33])
	end
	pfb(1, 1, w, 1, colors.blue)
	scp(1,1)
	p(systemMessages[33])
	pdp(w,1, colors.red)
	pfb(3, 4, 13, 6, colors.orange)
	scp(3,5)
	stc(colors.white)
	p(systemMessages[46])
	pfb(27, 4, 37, 6, colors.cyan)
	scp(27,5)
	stc(colors.white)
	p(systemMessages[47])
	pfb(15, 4, 25, 6, colors.green)
	scp(15,5)
	stc(colors.white)
	p(systemMessages[22])
	pfb(39, 4, 49, 6, colors.purple)
	scp(39,5)
	stc(colors.white)
	p("Device Mgr")
	klik = mouseClick()
	if (klik[1] == w and klik[2] == 1) then break end
	if klik[1]>0 and klik[1]<6 and klik[2] == h then start() end
	if klik[1]>2 and klik[1]<14 and klik[2]>3 and klik[2]<7 then stc(colors.white) infust() end
	if klik[1]>14 and klik[1]<26 and klik[2]>3 and klik[2]<7 then 
		if (ust() == 0) then
			return
		end
	end
	if klik[1]>26 and klik[1]<38 and klik[2]>3 and klik[2]<7 then  desk_ust() end
	if klik[1]>38 and klik[1]<50 and klik[2]>3 and klik[2]<7 then devMgr() end
	end
end

function sys()
color = get_color()
p(color)
draw(tonumber(color))
end

function mouse_sys()
klik = mouseClick()
scp(1,1)
if klik[1] ~= nil and klik[2] ~= nil and klik[3] ~= nil then
	if (klik[1]>1 and klik[1]<20 and klik[2] == 3) then
		r("/os/main/explorer.lua", "/os")
	end
	if fse("/User") and fs.isDir("/User") and (klik[1]>1 and klik[1]<20 and klik[2] == 4) then
		r("/os/main/explorer.lua", "/User")
	end
	if fse("/nshop") and fs.isDir("/nshop") and (klik[1]>1 and klik[1]<20 and klik[2] == 5) then
		r("/os/main/explorer.lua", "/nshop")
	end
	flop = peripheral.find("drive")
	if flop then
		if fse("/disk") and fs.isDir("/disk") and (klik[1]>1 and klik[1]<20 and klik[2] == 6) then
			r("/os/main/explorer.lua", "/disk")
		end
	end
	if (klik[1] == w-1 and klik[2] == h) then re() end
	if (klik[1] == w and klik[2] == h) then su() end
	if (klik[1]>0 and klik[1]<6 and klik[2] == h) then 
		if (start() == 512) then
			return 5
		end
	
	end
end
end


settings = loadSettings()
systemMessages = loadLang()
if systemMessages == nil then
	bsod("Language not found")
end

soundHandler(boot)
tc()
for i=1,#sides do
	if peripheral.getType(sides[i]) == "monitor" then
		if popUp("monitor_found") == 6 then 
			r("monitor", sides[i], "/os/main/menu")
			return
		end
	end
end

while true do
w, h = term.getSize()
if fse("/os/main/explorer.lua") then 
	parallel.waitForAll(sys, godz)
	if (mouse_sys() == 5) then
		return 0
	end
else
bsod("NextExplorer Missing")
end
end
