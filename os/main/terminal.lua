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

w,h = term.getSize()
-- Default bootargs --

function saveBootargs()
    argFile = fs.open("/.bootargs", "w")
    bootargst = textutils.serialize(bootargst)
    argFile.write(bootargst)
    argFile.close()
    return
end

function loadBootargs()
    if fse("/.bootargs") == false then
        return
    else 
        saveBootargs()
    end
    argFile = fs.open("/.bootargs", "r")
	bootargst = textutils.unserialize(argFile.readAll())
	argFile.close()
    return bootargst
end
bootargst = {["verbose"]=false,["shell"]=true}
if fse("/.bootargs") == true then
    bootargst = loadBootargs()
else
    saveBootargs()
end

sciezka = "/"
shell.setDir("/")
-- NextUI Shell --

function ls(args)
    i = 1
    arg = {}
    for j=1,#args do
        arg[i] = args[j]
        i = i + 1
    end

    if arg[1] == nil then
        pliki = fs.list(sciezka)
        for i=1,#pliki do
            if fs.isDir(sciezka.."/"..pliki[i]) then
                p(pliki[i].. "<DIR>")
            else
                p(pliki[i])
            end
        end
        return
    end

    if arg[1] == "-la" then
        size = true
        if #arg == 2 then 
            path = arg[2]
        else
            path = sciezka
        end
    else
        path = arg[1]
        size = false
    end

    if fse(path) == false or fs.isDir(path) == false then
        p("Provided path doesn't exists or is a file.")
        return
    end

    pliki = fs.list(path)

    for i=1,#pliki do
        if size == true then
            if fs.isDir(path.."/"..pliki[i]) then
                stc(colors.yellow)
                p(pliki[i].." <DIR>")
                stc(colors.white)
            else
                p(pliki[i].." "..fs.getSize(path.."/"..pliki[i]).."B")
            end
        else
            if fs.isDir(path.."/"..pliki[i]) then
                stc(colors.yellow)
                p(pliki[i].. "<DIR>")
                stc(colors.white)
            else
                p(pliki[i])
            end
        end
    end
    return
end

function bootargs(args)
    if args[1] == nil then
        p("Usage: bootargs <argument> <value>")
        return
    else
        bootargst = loadBootargs()
        if args[2] == nil then
            if args[1] == "verbose" then
                p("Verbose: "..tostring(bootargst["verbose"]))
            elseif args[1] == "shell" then
                p("Shell: "..tostring(bootargst["shell"]))
            else
                p("Unknown argument.")
            end
            return
        else
            if args[1] == "verbose" then
                if args[2] == "true" then
                    bootargst["verbose"] = true
                elseif args[2] == "false" then
                    bootargst["verbose"] = false
                else
                    p("Value must be 'true' or 'false'.")
                    return
                end
            elseif args[1] == "shell" then
                if args[2] == "true" then
                    bootargst["shell"] = true
                elseif args[2] == "false" then
                    bootargst["shell"] = false
                else
                    p("Value must be 'true' or 'false'.")
                    return
                end
            else
                p("Unknown argument.")
                return
            end
        end
    end
    saveBootargs()
    return
end

function man(command)
    tc()
    scp(1,1)
    if command == "ls" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[ls - displays directory contents
Usage - ls <argument> <path>
Arguments:
-la - additionally displays file size]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "explorer" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[explorer - Launches NextExplorer
Usage - explorer <path>
Argumenty:
sciezka - Path to the directory, default path: "/"]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "bootargs" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[bootargs - Boot arguments manager
Usage - bootargs <argument> <value>
Arguments:
verbose - Displays additional bootup information, enables system integrity check
shell - Switches between Terminal Emulator and GUI as default interface]]
    scp(1,h)
    write("NextUI 2.1")
    elseif command == "exit" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[exit - exit from terminal]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "reboot" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[reboot - reboots your computer]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "shutdown" or command == "su" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[shutdown/su - shuts down your computer]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "help" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[help - displays help]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "man" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[man - launches NextUI Terminal Manual
Usage - man <command>
Arguments:
command - Desired command manual]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "menu" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[menu - goes to NextUI GUI]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "touch" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[touch - creates empty file or directory
Usage - touch <filename> <type>
Arguments:
filename - New file name
type - file or dir (directory)]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "cd" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[cd - switches to provided directory
Usage - cd <path>
Arguments:
path - path to directory
Special argument:
path ".." - goes to the parent directory of current one]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "echo" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[echo - Displays text to the desired output
Usage - echo <text> <output>
Arguments:
text - desired text to display
output - desired output location, default: standard output (Terminal Emulator)]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "clear" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[clear - clears the display
Usage - clear]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "rm" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[rm - deletes file or directory
Usage - rm <file>
Arguments:
file - directory or file name
Warning! This command doesn't check for importance of selected file. Use with caution and double check name you provide.]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "ver" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[ver - displays system version]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "label" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[label - sets computer label
Usage - label <name>
Arguments:
name - new computer label]]
        scp(1,h)
        write("NextUI 2.1")
    else
        p("Unknown command.")
    end
    write(" Press any key to go back.")
    s(0.1)
    key = os.pullEvent("key")
    tc()
    scp(1,1)
    return
end

function touch(args)
    if args[1] == nil then
        p("Usage: touch <file> <type>")
        return
    end
    if fse(args[1]) == true then
        p("File exists")
        return
    end
    if args[2] == "file" then
        file = fs.open(args[1], "w")
        file.close()
    elseif args[2] == "dir" then
	currentDirectory = shell.dir()
        fs.makeDir(fs.combine(currentDirectory, args[1]))
	if (fse(fs.combine(currentDirectory, args[1])) == false) then
		p("Could not create directory")
	end
    end
    return
end

function rm(args)
    if args[1] == nil then
        p("Usage: rm <file>")
        return
    end
    if fse(args[1]) == false then
        p("File doesn't exist")
        return
    end
    fs.delete(args[1])
    return
end

function help()
    p[[NextUI Shell
ls - displays directory contents
explorer - launches NextExplorer
bootargs - manages boot arguments
exit - exists terminal
reboot - reboots computer
shutdown/su - shuts down your computer
help - displays this menu
man - displays provided command manual
menu - launches GUI
touch - creates file or directory
cd - changes directory
echo - displays text
clear - clears the display
rm - removes file or directory
ver - displays system version
label - sets computer label
]]
end

function terminal()
    tc()
    s(0.1)
    pfb(1,1,w,h,colors.black)
    scp(1,1)
    p("NextUI Terminal Emulator")
    while true do
        write(sciezka..">")
        input = read()
        args = {}
        i = 1
        arg = string.find(input, " ")
        if arg ~= nil then
            command = string.sub(input, 1, arg-1)
            input = string.sub(input, arg+1)
            while input ~= "" do
                arg = string.find(input, " ")
                if arg == nil then
                    args[i] = input
                    input = ""
                else
                    args[i] = string.sub(input, 1, arg-1)
                    input = string.sub(input, arg+1)
                end
                i = i + 1
            end
        else
            command = input
        end

        if command == "ls" then
            ls(args)
        elseif command == "explorer" then
            if args[1] == nil then
                r("/os/main/explorer")
                tc()
                scp(1,1)
            else
                r("/os/main/explorer "..args[1])
                tc()
                scp(1,1)
            end
        elseif command == "bootargs" then
            bootargs(args)
        elseif command == "exit" then
            return
        elseif command == "man" then 
            man(args[1])
        elseif command == "reboot" then 
            re()
        elseif command == "shutdown" or command == "su" then
            su()
        elseif command == help then
            help()
        elseif command == "touch" then
            touch(args)
        elseif command == "menu" then
            r("/os/main/menu")
        elseif command == "help" then
            help()
        elseif command == "cd" then
            if args[1] == nil then
                sciezka = "/"
                os.setDir("/")
            else
                if args[1] == ".." and sciezka == "/" then
                    p("Cannot go to parent directory. Current directory is root.")
                elseif args[1] == ".." then
                    p(sciezka)
                    s(5)
                    sciezka = fs.getDir(sciezka)
                    
                    shell.setDir(sciezka)
                else
                    if string.sub(args[1], 1, 1) == "/" then
                        sciezka = args[1]
                        shell.setDir(sciezka)
                    else
                        sciezka = fs.combine(sciezka, args[1])
                        sciezka = "/"..sciezka
                        if fse(sciezka) == true and fs.isDir(sciezka) == true then
                            shell.setDir(sciezka)
                        else
                            p("Provided path does not exist or is not a directory.")
			    shell.setDir("/")
                        end
                    end
                end
            end
        elseif command == "echo" then
            for i=1,#args do
                write(args[i].." ")
            end
        elseif command == "clear" then
            terminal()
            return
        elseif command == "rm" then
            rm(args)
        elseif command == "ver" then
            p("NextUI 2.1")
            p("Terminal Emulator 1.0")
        elseif command == "label" then
            if args[1] == nil then
                p("Usage: label <name>")
            else
                os.setComputerLabel(args[1])
            end
        else
            if fse(command) == true then
                r(command)
                tc()
            else
                p("Unknown command. Type 'help' for command list.")
            end
        end
    end
end

bootargst = loadBootargs()
terminal()
