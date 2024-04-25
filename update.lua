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


filesList = {["/startup.lua"] = "https://raw.githubusercontent.com/bwisniewski26/nextui/main/startup.lua", ["/os/main/terminal.lua"] = "https://raw.githubusercontent.com/bwisniewski26/nextui/main/os/main/terminal.lua", ["/os/main/menu.lua"] = "https://raw.githubusercontent.com/bwisniewski26/nextui/main/os/main/menu.lua", ["/os/main/explorer.lua"] = "https://raw.githubusercontent.com/bwisniewski26/nextui/main/os/main/explorer.lua", ["/os/lang/eng.lua"] = "https://raw.githubusercontent.com/bwisniewski26/nextui/main/os/lang/eng.lua", ["/os/lang/pl.lua"] = "https://raw.githubusercontent.com/bwisniewski26/nextui/main/os/lang/pl.lua", ["/setup.lua"] = "https://raw.githubusercontent.com/bwisniewski26/nextui/main/setup.lua"}

backupPaths = {["/startup.lua"] = "/os/backup/startup.lua", ["/os/main/terminal.lua"] = "/os/backup/main/terminal.lua", ["/os/main/menu.lua"] = "/os/backup/main/menu.lua", ["/os/main/explorer.lua"] = "/os/backup/main/explorer.lua", ["/os/lang/eng.lua"] = "/os/backup/lang/eng.lua", ["/os/lang/pl.lua"] = "/os/backup/lang/pl.lua"}

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

os.pullEvent = os.pullEventRaw 

sbc(colors.black)
tc()
stc(colors.white)
scp(1,1)
p("NextUI System Update")
p("Terminating this app is disabled. In case update goes wrong, system files backup will be available in /os/backup folder.")
p("Attempting to download setup.lua")
if fse("/setup.lua") then
    fs.delete("/setup.lua")
end
success = downloadFile(filesList["/setup.lua"], "/setup.lua")
if success == 0 then
    p("Download failed. Update has been aborted, no changes has been made.")
    return
end

p("Download successful. Attempting to make system files backup.")
for path,backupPath in pairs(backupPaths) do
    if fse(backupPath) and fse(path) then
        fs.delete(backupPath)
    end

    if fse(path) then fs.copy(path, backupPath) end
end

sp("Backup complete. Downloading system files.")

for path,downloadURL in pairs(filesList) do
    if fse(path) then fs.delete(path) end

    success = downloadFile(downloadURL, path)
    if success == 0 then
        p(path .. "download unsuccessful! Your NextUI installation may be damaged. You can reinstall system by executing /setup.lua")

        return
    end
end

p("Update complete! Rebooting your computer in 2 seconds..")
s(2)
re()

