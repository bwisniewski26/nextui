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



if fs.exists("/.bootargs") then
	bootargs = textutils.unserialize(fs.open("/.bootargs","r").readAll())
else
	bootargs = {["verbose"]=false,["shell"]=false}
end

speakerPresent = 0
local w, h = term.getSize()

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

peripherals = findPeripherals()
for i=1,6 do
	if peripherals[i] == "speaker" then speakerPresent = i end
end

function bsod(powod)
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
    p[[System NextUI napotkal problem i musial zostac zatrzymany. Jesli widzisz ten ekran po raz pierwszy poczekaj na ponowny rozruch komputera, jesli blad bedzie sie powtarzal moze byc konieczna naprawa systemu NextUI.
    Trwa zbieranie informacji na temat Bledu STOP]]
	if speakerPresent ~= 0 then
		speaker = peripheral.find("speaker")
		speaker.playNote("chime")
		s(0.5)
		speaker.playNote("chime")
		s(0.5)
		speaker.playNote("chime")
		s(0.5)
		speaker.playNote("chime")
		s(0.5)
		speaker.playNote("chime")
		end
    s(4)
    p("Nazwa bledu: ", powod)
    p("")
    p("")
	s(10)
	re()
end


function regular()
	sbc(colors.black)
	tc()
	sbc(colors.black)
	scp(1,1)
	sbc(colors.gray)
	stc(colors.white)
	sp("NextUI Bootloader")
	if speakerPresent ~= 0 then
		scp(1,3)
		sp("Loading sound extension...")
		speaker = peripheral.find("speaker")
		speaker.playNote("chime")
		s(0.1)
		speaker.playNote("bass")
		s(0.1)
		speaker.playNote("guitar")
	end
	scp(1,5)
	if bootargs["shell"] == true then
		sp("Booting into Terminal Emulator...")
		shell.setDir("/")
		if shell.run("/os/main/terminal") == false then
			bsod("NextUI Failure")
		end
		return
	end
	sp("Booting into NextExplorer...")

	shell.setDir("/")
	if shell.run("/os/main/menu") == false then
		bsod("NextUI Failure")
	end
end

function verbose()
	tc()
	pfb(1,1,w,h,colors.black)
	stc(colors.white)
	scp(1,1)
	sbc(colors.gray)
	p("NextUI 2.0")
	sbc(colors.black)
	p("Booting in verbose mode...")
	s(0.5)
	sp("Checking system folder...")
	if (fse("/os/main/menu.lua") == false and fse("/os/main/menu")) or fse("/os/main/explorer.lua") == false or fse("/os/luaide") == false then
		stc(colors.red)
		p("NextUI system files not found!")
		s(1)
		bsod("NextUI Failure")
	else
		stc(colors.green)
		p("System scan complete.")
		stc(colors.white)
	end
	s(0.5)
	sp("Checking for peripherals...")
	peripherals = findPeripherals()
	for i=1,6 do
		if peripherals[i] == "speaker" then speakerPresent = i end
		if peripherals[i] == "modem" then modemPresent = i end
	end
	
	if speakerPresent ~= 0 then
		stc(colors.green)
		p("Speaker found.")
		stc(colors.white)
	else
		stc(colors.red)
		p("Speaker not found.")
		stc(colors.white)
	end
	if modemPresent ~= 0 then
		stc(colors.green)
		p("Modem found.")
		stc(colors.white)
	else
		stc(colors.red)
		p("Modem not found.")
		stc(colors.white)
	end
	s(0.5)
	sp("Peripheral scan complete.")
	if shell == false then
		sbc(colors.gray)
		stc(colors.white)
		sp("Booting into NextExplorer...")
		shell.setDir("/")
		status = shell.run("/os/main/menu")
	else 
		sbc(colors.gray)
		stc(colors.white)
		sp("Booting into Terminal Emulator...")
		shell.setDir("/")
		status = shell.run("/os/main/terminal")
	end
	if status == false then
		bsod("NextUI Failure")
	else
		return
	end
end


if bootargs["verbose"] == true then
	verbose()
else
	regular()
end
