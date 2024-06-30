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

pfb(1,1,w,1,colors.black)
scp(1,1)
stc(colors.white)
p("NextUI Window Apps DevTool")
pfb(1,2,w,h,colors.lightGray)
scp(1,3)
p[[This tool allows you to generate new NextUI Window App dependency wrapper. Press CTRL+T at the same time to quit.]]
while true do
p("Enter your app name: ")
write(".>")
name = read()

if (fse("/" .. name) == false) then
    fs.makeDir("/" .. name)
    wrapper = fs.open("/" .. name .. "/launch.next", "w")
    wrapper.writeLine("os.loadAPI(\"/os/apis/windowApp\")")
    wrapper.writeLine("os.loadAPI(\"/" .. name .. "/app\")")
    wrapper.writeLine("window = windowApp.windowCreate(\"".. name .."\")")
    wrapper.writeLine("term.redirect(window)")
    wrapper.writeLine("app.main()")
    wrapper.close()
    app = fs.open("/" .. name .. "/app", "w")
    app.write([[function main()
    print("This is example NextUI Window App.")
    while true do
    local event, button, x, y = os.pullEvent("mouse_click")
    print("You clicked at x:"..x.." y:"..y.."!")
        if (x == 51 and y == 2) then
            term.current().setVisible(false)
            term.redirect(term.native())
            break
        end
    end
end]])
    app.close()
    break
else
    p("This app name already exists. Please choose another name.")
end

end

p("Finished. You can find your newly created template at /" .. name)
p("To launch your app execute /" .. name .. "/launch.next file.")
p("Launching editing tool using /" .. name .. "/app file.")

s(2)
scp(1,1)
sbc(colors.black)
tc()
shell.setDir("/" .. name)
r("edit", "/" .. name .. "/app")




