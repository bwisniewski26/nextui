
 
local function aw(...) return write(...) end
local function p(...) return print(...) end
local function s(...) return sleep(...) end
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
 
w, h = term.getSize()
 
pliki = {"https://raw.githubusercontent.com/bwisniewski26/nextui/main/startup.lua", "https://raw.githubusercontent.com/bwisniewski26/nextui/main/os/main/terminal.lua", "https://raw.githubusercontent.com/bwisniewski26/nextui/main/os/main/menu.lua", "https://raw.githubusercontent.com/bwisniewski26/nextui/main/os/main/explorer.lua", "https://raw.githubusercontent.com/bwisniewski26/nextui/main/os/lang/eng.lua", "https://raw.githubusercontent.com/bwisniewski26/nextui/main/os/lang/pl.lua"}
 
function downloadFile(url, path)
    local response = http.get(url)
    if response then
        local fileContent = response.readAll()
        response.close()
        
        local file = fs.open(path, "w")
        file.write(fileContent)
        file.close()
    else
        print("Setup failed to download file from url: " .. url .. " to path: " .. path)
    end
end
 
function setupUI()
    pfb(1,1,w,h, colors.blue)
    pfb(1,h,w,h,colors.gray)
    local char1 = "\149"
    local char2 = "\131"
    scp(1,1)
    stc(colors.white)
    sbc(colors.blue)
    p("NextUI Setup")
    scp(1,2)
    p(char2, char2, char2, char2, char2, char2, char2, char2, char2)
end
 
function welcome()
    setupUI()
    scp(1,4)
    sbc(colors.blue)
    stc(colors.white)
    p[[Welcome to NextUI Setup! This program will install NextUI GUI on your computer.]]
    p[[Current default language is English. You can change it after installation in settings.]]
    scp(1,12)
    p[[Press Enter to start installation or Backspace to cancel.]]
    local event, key = os.pullEvent("key")
    if key == keys.backspace then
        pfb(1,1,w,h,colors.black)
        tc()
        s(1)
        scp(1,1)
        stc(colors.white)
        p("NextUI Setup has been canceled. Changes have not been made.")
    elseif key == keys.enter then
        install()
    else
        welcome()
    end
        
end
 
function install()
    setupUI()
    scp(1,h)
    sbc(colors.gray)
    stc(colors.white)
    write("Downloading system files...")
    paintutils.drawBox(8,12,43,14,colors.white)
    scp(1,3)
    downloadFile(pliki[1], "/startup")
    scp(9,13)
    sbc(colors.yellow)
    stc(colors.yellow)
    sp("******")
    sbc(colors.blue)
    stc(colors.white)
    scp(1,3)
    downloadFile(pliki[2], "/os/main/terminal.lua")
    scp(15,13)
    sbc(colors.yellow)
    stc(colors.yellow)
    sp("******")
    scp(1,3)
    downloadFile(pliki[3], "/os/main/menu.lua")
    scp(21,13)
    sbc(colors.yellow)
    stc(colors.yellow)
    sp("******")
    scp(1,3)
    downloadFile(pliki[4], "/os/main/explorer.lua")
    scp(27,13)
    sbc(colors.yellow)
    stc(colors.yellow)
    sp("*******")
    scp(1,3)
    downloadFile(pliki[5], "/os/lang/eng.lua")
    scp(34,13)
    sbc(colors.yellow)
    stc(colors.yellow)
    sp("******")
    scp(1,3)
    downloadFile(pliki[6], "/os/lang/pl.lua")
    scp(40,13)
    sbc(colors.yellow)
    stc(colors.yellow)
    sp("***")
    s(1)
    installStage2()
end
 
function installStage2()
    setupUI()
    scp(1,h)
    sbc(colors.gray)
    stc(colors.white)
    write("Injecting system settings...")
    paintutils.drawBox(8,12,43,14,colors.white)
    scp(1,3)
    sbc(colors.blue)
    stc(colors.blue)
    r("set shell.allow_disk_startup false")
    os.setComputerLabel("NextUI PC")
    fs.makeDir("/User")
    fs.makeDir("/nshop")
    s(1)
    pfb(1,h,w,h,colors.gray)
    stc(colors.white)
    scp(1,h)
    write("Rebooting...")
    for i = 9,42 do
        scp(i,13)
        sbc(colors.red)
        stc(colors.red)
        sp("*")
    end
    s(1)
    re()
end
 
welcome()
