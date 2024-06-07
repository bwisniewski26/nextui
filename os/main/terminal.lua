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
        p("Podana sciezka nie istnieje badz jest plikiem.")
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
        p("Zastosowanie: bootargs <argument> <wartosc>")
        return
    else
        bootargst = loadBootargs()
        if args[2] == nil then
            if args[1] == "verbose" then
                p("Verbose: "..tostring(bootargst["verbose"]))
            elseif args[1] == "shell" then
                p("Shell: "..tostring(bootargst["shell"]))
            else
                p("Nieznany argument.")
            end
            return
        else
            if args[1] == "verbose" then
                if args[2] == "true" then
                    bootargst["verbose"] = true
                elseif args[2] == "false" then
                    bootargst["verbose"] = false
                else
                    p("Wartosc musi byc 'true' lub 'false'.")
                    return
                end
            elseif args[1] == "shell" then
                if args[2] == "true" then
                    bootargst["shell"] = true
                elseif args[2] == "false" then
                    bootargst["shell"] = false
                else
                    p("Wartosc musi byc 'true' lub 'false'.")
                    return
                end
            else
                p("Nieznany argument.")
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
        p[[ls - Wyswietla zawartosc katalogu
Uzycie - ls <argument> <sciezka>
Argumenty:
-la - Wyswietla rozmiar plikow]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "explorer" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[explorer - Uruchamia NextExplorer
Uzycie - explorer <sciezka>
Argumenty:
sciezka - Sciezka do katalogu, domyslnie: "/"]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "bootargs" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[bootargs - Zarzadza argumentami startowymi
Uzycie - bootargs <argument> <wartosc>
Argumenty:
verbose - Wyswietla dodatkowe informacje podczas startu
shell - Domyslnie uruchamia terminal]]
    scp(1,h)
    write("NextUI 2.1")
    elseif command == "exit" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[exit - Wyjscie z terminala]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "reboot" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[reboot - Restartuje komputer]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "shutdown" or command == "su" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[shutdown/su - Wylacza komputer]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "help" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[help - Wyswietla pomoc]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "man" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[man - Wyswietla pomoc dla danej komendy
Uzycie - man <komenda>
Argumenty:
komenda - Komenda ktorej pomoc chcemy wyswietlic]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "menu" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[menu - Uruchamia GUI NextUI]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "touch" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[touch - Tworzy plik lub katalog
Uzycie - touch <plik> <typ>
Argumenty:
plik - Nazwa pliku
typ - file lub dir]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "cd" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[cd - Zmienia katalog
Uzycie - cd <sciezka>
Argumenty:
sciezka - Sciezka do katalogu]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "echo" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[echo - Wyswietla tekst
Uzycie - echo <tekst>
Argumenty:
tekst - Tekst do wyswietlenia]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "clear" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[clear - Czysci ekran
Uzycie - clear]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "rm" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[rm - Usuwa plik lub folder
Uzycie - rm <plik>
Argumenty:
plik - Nazwa pliku lub folderu]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "ver" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[ver - Wyswietla wersje systemu]]
        scp(1,h)
        write("NextUI 2.1")
    elseif command == "label" then
        scp(1,1)
        p("NEXTUI TERMINAL MANUAL")
        p[[label - Ustawia nazwe komputera
Uzycie - label <nazwa>
Argumenty:
nazwa - Nazwa komputera]]
        scp(1,h)
        write("NextUI 2.1")
    else
        p("Nieznana komenda.")
    end
    write(" Nacisnij dowolny klawisz aby wrocic.")
    s(0.1)
    key = os.pullEvent("key")
    tc()
    scp(1,1)
    return
end

function touch(args)
    if args[1] == nil then
        p("Zastosowanie: touch <plik> <typ>")
        return
    end
    if fse(args[1]) == true then
        p("Plik juz istnieje.")
        return
    end
    if args[2] == "file" then
        file = fs.open(args[1], "w")
        file.close()
    elseif args[2] == "dir" then
	currentDirectory = shell.dir()
        fs.makeDir(fs.combine(currentDirectory, args[1]))
	if (fse(fs.combine(currentDirectory, args[1])) == false) then
		p("Nie udalo sie utworzyc katalogu")
	end
    end
    return
end

function rm(args)
    if args[1] == nil then
        p("Zastosowanie: rm <plik>")
        return
    end
    if fse(args[1]) == false then
        p("Plik nie istnieje.")
        return
    end
    fs.delete(args[1])
    return
end

function help()
    p[[NextUI Shell
ls - Wyswietla zawartosc katalogu
explorer - Uruchamia NextExplorer
bootargs - Zarzadza argumentami startowymi
exit - Wyjscie z terminala
reboot - Restartuje komputer
shutdown/su - Wylacza komputer
help - Wyswietla pomoc
man - Wyswietla pomoc dla danej komendy
menu - Uruchamia GUI NextUI
touch - Tworzy plik lub katalog
cd - Zmienia katalog
echo - Wyswietla tekst
clear - Czysci ekran
rm - Usuwa plik lub folder
ver - Wyswietla wersje systemu
label - Ustawia nazwe komputera
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
                if args[1] == ".." then
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
                            p("Podana sciezka nie istnieje lub nie jest katalogiem.")
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
                p("Zastosowanie: label <nazwa>")
            else
                os.setComputerLabel(args[1])
            end
        else
            if fse(command) == true then
                r(command)
                tc()
            else
                p("Nieznana komenda. Wpisz 'help' aby uzyskac pomoc.")
            end
        end
    end
end

bootargst = loadBootargs()
terminal()
