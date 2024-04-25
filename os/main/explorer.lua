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
function ile_folderow(sciezka)
	local files = fs.list(sciezka)
	ile = 0
	for i,file in ipairs(files) do
		if fs.isDir(fs.combine(sciezka,file)) then
				ile = ile+1
		end
	end
	return ile
end
	
	
function ile_plikow(sciezka)
	local files = fs.list(sciezka)
	ile = 0
	for i,file in ipairs(files) do
		ile = ile+1
	end
	return ile
end

function wyswietl_pliki(sciezka, y)
	temp = y
	sbc(colors.black)
	tc()
	sbc(colors.black)
	stc(colors.white)
	scp(1,1)
	if pocket then p(systemMessages[49] .. " " .. fs.getDir(sciezka), sciezka) else p(systemMessages[50] .. " " .. sciezka) end
	scp(w,1)
	p("X")
	local files = fs.list(sciezka)
	j = 1
	for i,file in ipairs(files) do
		if ((h-3)*j <= i) then j = j+1 y = temp end
		scp(2+((j-1)*10),y)
		if fs.isDir(fs.combine(sciezka,file)) then
			if fs.isDir(fs.combine(sciezka,file)) == "os/main/" then
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
			if sciezka == "os/main" or file == "startup" then stc(colors.red) end
			file = string.sub(file, 1, 9)
			term.write(file)
			stc(colors.white)
		end
	y = y+1
	end
	scp(1,h)
	write(systemMessages[51])


end

function popup(sciezka, plik, arg)
	if (plik ~= nil) then
		pfb(1,h-6, 15, h-6, colors.lightGray)
		scp(1,h-6)
		stc(colors.white)
		str = string.sub(fs.combine(sciezka,plik), 1, 15)
		write(str)
		pfb(1,h-5,15,h-1,colors.white)
		stc(colors.black)
		scp(1,h-5)
		p(systemMessages[52])
		p(systemMessages[53])
		p(systemMessages[54])
		p(systemMessages[55])
		klik = mysz()
		if klik[1]>0 and klik[1]<16 and klik[2] == h-5 then
			status = shell.run(fs.combine(sciezka,plik))
		end
		if klik[1]>0 and klik[1]<16 and klik[2] == h-4 then
			shell.setDir("/")
			shell.run("/os/luaide", fs.combine(sciezka,plik))
		end
		if klik[1]>0 and klik[1]<16 and klik[2] == h-3 then
			fs.delete(fs.combine(sciezka,plik))
		end
		if klik[1]>0 and klik[1]<16 and klik[2] == h-2 then
			scp(1,2)
			sbc(colors.white)
			stc(colors.black)
			write(systemMessages[56])
			nowa_sciezka = read()
			if fse(fs.combine(sciezka,nowa_sciezka)) then
				fs.copy(fs.combine(sciezka,plik), fs.combine(sciezka,nowa_sciezka))
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
		klik = mysz()
		if klik[1]>0 and klik[1]<16 and klik[2] == h-3 then
			scp(1,2)
			sbc(colors.white)
			stc(colors.black)
			p(systemMessages[60])
			nowy_folder = read()
			fs.makeDir(fs.combine(sciezka,nowy_folder))
		end
		if klik[1]>0 and klik[1]<16 and klik[2] == h-2 then
			scp(1,2)
			sbc(colors.white)
			stc(colors.black)
			write(tostring(systemMessages[61]))
			nowy_plik = read()
			shell.setDir("/")
			plik = fs.combine(sciezka,nowy_plik)
			r("/os/luaide", plik)
		end
	end

	return
end

function wyswietl_foldery(sciezka, y)
	local files = fs.list(sciezka)
	for i,file in ipairs(files) do
		scp(2,y)
		if fs.isDir(fs.combine(sciezka,file)) then
			stc(colors.yellow)
			term.write("[["..file.."]]")
			stc(colors.white)
		end
	y = y+1
	end
end

function foldery(sciezka)
arg = {}
local files = fs.list(sciezka)
y = 1
for i,file in ipairs(files) do
    if fs.isDir(fs.combine(sciezka,file)) then
		arg[y] = file
    	y = y+1
	end
end
a = 1
scp(1,10)
arg[y+1] = y
return arg
end

function pliki(sciezka)
arg = {}
local files = fs.list(sciezka)
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

function mysz()
 local event, button, x, y = os.pullEvent("mouse_click")
klik = {x, y, button}
return klik
end


function pomoc(sciezka)
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
	klik = mysz()
	if (klik[1] == w and klik[2] == 1) then main(sciezka) end
end


function main(sciezka) 
while true do
shell.setDir(sciezka)
w, h = term.getSize()
		wyswietl_pliki(sciezka, 3)
		arg = pliki(sciezka)
		ile = ile_plikow(sciezka)
		
		klik = mysz()
		-- klik_y = klik[2]-2
		if (klik[1]<11) then 
			klik_y = klik[2] - 2
		elseif (klik[1]>10 and klik[1]<21) then
			klik_y = (math.floor(klik[1]/10)*10)+klik[2]+3
		elseif (klik[1]>20 and klik[1]<31) then
			klik_y = (math.floor(klik[1]/10)*10)+klik[2]+9
		elseif (klik[1]>30 and klik[1]<41) then
			klik_y = (math.floor(klik[1]/10)*10)+klik[2]+15
		elseif (klik[1]>40 and klik[1]<51) then
			klik_y = (math.floor(klik[1]/10)*10)+klik[2]+21
		end
		if (klik[1]>1 and klik[1]<5 and klik[2] == h) then
			pomoc(sciezka)
		end
		if (klik[1]>6 and klik[1]<11 and klik[2] == h) then
			scp(1,2)
			write(tostring(69))
			nazwa = read()
			if fs.isDir(nazwa) == true then main(nazwa) end
		end
		if (klik[1] > 11 and klik[1] < 16 and klik[2] == h) then
			popup(sciezka, nil, arg)
		end
		if (klik[1] == w and klik[2] == 1) then error() end
		if (klik[1] == 1 and klik[2] == 1) then
			sciezka = fs.getDir(sciezka)
			if (sciezka == "") then sciezka = "/" end
			break
		end
		if (klik[1]>0 and klik[1]<w and klik_y<ile+1 and klik_y>0 and klik[3] == 2) then
			if fs.exists(fs.combine(sciezka,arg[klik_y])) then
				popup(sciezka, arg[klik_y])
				break
			end
		end
		if (klik[1]>0 and klik[1]<w and klik_y<ile+1 and klik_y>0 and klik[3] == 1) then
			if fs.isDir(fs.combine(sciezka,arg[klik_y])) then
				sciezka = fs.combine(sciezka,arg[klik_y])
				main(sciezka)
			else
				if fs.exists(fs.combine(sciezka,arg[klik_y])) then
					tc()
					status = shell.run(arg[klik_y])
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
							arg_lua = string.sub(arg[klik_y], 1, 6)
							if arg_lua ~= "luaide" then p(systemMessages[70]) end
							s(1)
							break
						end
				end
			end
		end
	end
end
sciezka = "/"
shell.setDir("/")
while true do
if (args[1] == nil) then main(sciezka) else main(args[1]) end
end