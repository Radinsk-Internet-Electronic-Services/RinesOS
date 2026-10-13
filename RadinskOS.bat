@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title RinesOS
mode con: cols=100 lines=40

:: ---------- persistent "firmware" settings ----------
set "secureboot=Enabled"
set "turbo=Enabled"
set "bootorder=RinesOS Boot Manager"
set "thm=0A"
set "user=Rines"
set "tag="
set "safe=0"
set "cmds=0"
goto boot

:: =====================================================
::  BOOT SEQUENCE
:: =====================================================
:boot
color 07
cls
call :post
call :splash
goto bootmenu

:post
echo RinesBIOS v4.2.0  -  Copyright (C) 2026 Rines Systems Inc.
echo Build 2026.10.13  -  Release Candidate 7
echo.
echo CPU      : RinesCore X9 Octa-Core @ 5.20 GHz
echo GPU      : Rines Photon RTX-Infinity 24GB
echo.
<nul set /p "=Testing memory "
for /l %%i in (1,1,12) do (
  <nul set /p "=."
  call :tick
)
echo  32768 MB OK
echo.
call :ok "Initializing PCI Express bus"
call :ok "Detecting storage devices"
call :ok "NVMe Drive 0: RINES-SSD 1TB"
call :ok "USB Controller: 6 ports active"
call :ok "Network Adapter: RinesLink Gigabit"
call :ok "Secure Boot: %secureboot%"
call :ok "Turbo Boost: %turbo%"
call :ok "Loading RinesOS Boot Manager"
echo.
echo Boot device priority: %bootorder%
call :wait 2
exit /b

:splash
cls
color 0B
echo.
echo      ✦          .            ✧              .          ✦           .
echo           .            ✦             .            ✧           .
echo.
echo.
call :logo
echo.
echo                ░▒▓█   T H E   N E X T   G E N   O S   █▓▒░
echo.
echo      ·     ✧        .          ✦         .        ✧      ·
echo.
call :bar "   Starting up "
call :wait 1
exit /b

:logo
echo         ██████╗ ██╗███╗   ██╗███████╗███████╗
echo         ██╔══██╗██║████╗  ██║██╔════╝██╔════╝
echo         ██████╔╝██║██╔██╗ ██║█████╗  ███████╗
echo         ██╔══██╗██║██║╚██╗██║██╔══╝  ╚════██║
echo         ██║  ██║██║██║ ╚████║███████╗███████║
echo         ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝
echo                    ═══════  O S  ═══════
exit /b

:: =====================================================
::  BOOT MENU
:: =====================================================
:bootmenu
color 1F
cls
echo.
echo   ╔════════════════════════════════════════════════════════════╗
echo   ║                    RINESOS BOOT MANAGER                    ║
echo   ╚════════════════════════════════════════════════════════════╝
echo.
echo        Choose an option:
echo.
echo          1.  Boot $#Rines#$0S
echo.
echo          2.  Enter BIOS Setup
echo.
echo          3.  Troubleshoot Menu (Restart required)
echo.
echo          4.  Boot from Bootable Drive/Disc
echo.
echo   ──────────────────────────────────────────────────────────────
echo    Secure Boot: %secureboot%     Default: Option 1     Auto-boot in 20s
echo   ──────────────────────────────────────────────────────────────
echo.
choice /c 1234 /t 20 /d 1 /n /m "        Select an option (1-4): "
set "sel=%errorlevel%"
if "%sel%"=="1" goto startos
if "%sel%"=="2" goto bios
if "%sel%"=="3" goto troubleshoot
if "%sel%"=="4" goto drives
goto bootmenu

:: =====================================================
::  START RINESOS
:: =====================================================
:startos
cls
color 0A
echo.
echo   Starting RinesOS...
echo.
call :bar "   Kernel    "
call :bar "   Drivers   "
call :bar "   Services  "
if "%safe%"=="1" goto shellstart
call :bar "   Desktop   "
call :wait 1

:login
cls
color 0B
echo.
echo.
call :logo
echo.
echo        ┌──────────────────────────────────────────────┐
echo        │  ◉  User: %user%
echo        └──────────────────────────────────────────────┘
echo.
set "pw="
set /p "pw=       Password (anything works): "
echo.
<nul set /p "=       Authenticating "
for /l %%i in (1,1,8) do (
  <nul set /p "=●"
  call :tick
)
echo.
echo.
echo        Welcome back, %user%  ✦
call :wait 2

:desktop
cls
color 3F
echo.
echo   ◈ RinesOS Desktop ──────────────────────────────────────────  %time:~0,5%
echo.
echo.
echo     ┌──────┐   ┌──────┐   ┌──────┐   ┌──────┐   ┌──────┐
echo     │  ▣▣  │   │  ◍   │   │  ♫   │   │  ⚙   │   │  ▶_  │
echo     └──────┘   └──────┘   └──────┘   └──────┘   └──────┘
echo      Files      Browser     Music     Settings   Terminal
echo.
echo.
echo.
echo        ·    ✧         .            ✦          .       ✧
echo.
echo   ─────────────────────────────────────────────────────────────
echo   [ Start ]  RinesShell ready                  ▂▃▅▇ 100%%  ⚡
echo.
echo   Press any key to open Terminal...
pause >nul

:shellstart
color %thm%
cls
echo RinesShell 2.0  -  RinesOS 1.0 "Nebula" %tag%
echo Type help for a list of commands.
echo.
goto shell

:: =====================================================
::  RINESSHELL
:: =====================================================
:shell
set /a cmds+=1
set "input="
set /p "input=%user%@RinesOS%tag%:~$ "
if not defined input goto shell
set "c="
set "args="
for /f "tokens=1,*" %%a in ("!input!") do (set "c=%%a"&set "args=%%b")
if /i "!c!"=="help" goto c_help
if /i "!c!"=="ver" goto c_ver
if /i "!c!"=="about" goto c_ver
if /i "!c!"=="neofetch" goto c_neofetch
if /i "!c!"=="sysinfo" goto c_sysinfo
if /i "!c!"=="whoami" goto c_whoami
if /i "!c!"=="date" goto c_date
if /i "!c!"=="time" goto c_time
if /i "!c!"=="uptime" goto c_uptime
if /i "!c!"=="clear" goto c_clear
if /i "!c!"=="cls" goto c_clear
if /i "!c!"=="echo" goto c_echo
if /i "!c!"=="calc" goto c_calc
if /i "!c!"=="dice" goto c_dice
if /i "!c!"=="coinflip" goto c_coin
if /i "!c!"=="8ball" goto c_8ball
if /i "!c!"=="fortune" goto c_fortune
if /i "!c!"=="joke" goto c_joke
if /i "!c!"=="matrix" goto c_matrix
if /i "!c!"=="hack" goto c_hack
if /i "!c!"=="scan" goto c_scan
if /i "!c!"=="ping" goto c_ping
if /i "!c!"=="weather" goto c_weather
if /i "!c!"=="say" goto c_say
if /i "!c!"=="theme" goto c_theme
if /i "!c!"=="music" goto c_music
if /i "!c!"=="rainbow" goto c_rainbow
if /i "!c!"=="countdown" goto c_countdown
if /i "!c!"=="guess" goto c_guess
if /i "!c!"=="ls" goto c_ls
if /i "!c!"=="dir" goto c_ls
if /i "!c!"=="cat" goto c_cat
if /i "!c!"=="sudo" goto c_sudo
if /i "!c!"=="rm" goto c_rm
if /i "!c!"=="bsod" goto c_bsod
if /i "!c!"=="bios" goto bios
if /i "!c!"=="reboot" goto boot
if /i "!c!"=="restart" goto boot
if /i "!c!"=="shutdown" goto c_shutdown
if /i "!c!"=="exit" goto c_shutdown
echo '!c!' is not recognized by RinesShell. Type help for commands.
goto shell

:c_help
echo.
echo  ┌─ RinesShell Command Reference ─────────────────────────────┐
echo.
echo   SYSTEM      ver  neofetch  sysinfo  whoami  date  time
echo               uptime  clear  ls  cat  bios  theme
echo               reboot  shutdown  bsod
echo.
echo   TOOLS       echo  calc  ping  scan  weather  countdown
echo.
echo   GAMES/FUN   dice  coinflip  8ball  fortune  joke  guess
echo               say  music  rainbow  matrix  hack
echo.
echo   SECRETS     try: cat secret.txt   sudo   rm
echo.
echo  └────────────────────────────────────────────────────────────┘
echo.
goto shell

:c_ver
echo.
echo   RinesOS 1.0 "Nebula"   build 2026.10.13
echo   Kernel  : Rines-NT 10.26
echo   Shell   : RinesShell 2.0
echo   Author  : Rines Systems Inc.  ^(not a real company^)
echo.
goto shell

:c_neofetch
echo.
echo   ██████╗      %user%@RinesOS
echo   ██╔══██╗     ─────────────────────
echo   ██████╔╝     OS      : RinesOS 1.0 Nebula
echo   ██╔══██╗     Kernel  : Rines-NT 10.26
echo   ██║  ██║     Shell   : RinesShell 2.0
echo   ╚═╝  ╚═╝     CPU     : RinesCore X9 @ 5.2GHz
echo                 GPU     : Rines Photon RTX-Infinity
echo                 Memory  : 4096MiB / 32768MiB
echo                 Cmds run: !cmds!
echo                 Theme   : %thm%
echo.
goto shell

:c_sysinfo
set /a cpu=%random% %% 60 + 10
set /a ram=%random% %% 40 + 20
set /a tmp1=%random% %% 25 + 35
echo.
echo   CPU  Load   : !cpu!%%   ████████░░░░░░░░░░░░
echo   RAM  Usage  : !ram!%%   █████░░░░░░░░░░░░░░░
echo   Temp        : !tmp1! C  ▂▃▄
echo   Secure Boot : %secureboot%
echo   Turbo Boost : %turbo%
echo   Boot Device : %bootorder%
echo.
goto shell

:c_whoami
echo %user%
goto shell

:c_date
echo %date%
goto shell

:c_time
echo %time:~0,8%
goto shell

:c_uptime
echo up for !cmds! commands, load average: 0.42, 0.37, 0.30
goto shell

:c_clear
cls
goto shell

:c_echo
echo(!args!
goto shell

:c_calc
set "res="
if not defined args (echo usage: calc 12*7+3& goto shell)
set /a "res=!args!" 2>nul
if defined res (echo   = !res!) else (echo   Invalid expression.)
goto shell

:c_dice
set /a d=%random% %% 6 + 1
echo   You rolled a !d!
goto shell

:c_coin
set /a c1=%random% %% 2
if "!c1!"=="0" (echo   HEADS) else (echo   TAILS)
goto shell

:c_8ball
set /a r=%random% %% 6
set "a0=Yes, definitely."
set "a1=Signs point to yes."
set "a2=Ask again later."
set "a3=Cannot predict now."
set "a4=Do not count on it."
set "a5=Very doubtful."
echo   (8)  !a%r%!
goto shell

:c_fortune
set /a r=%random% %% 5
set "f0=Your next compile will work on the first try."
set "f1=Someone is quietly proud of you."
set "f2=A bug you ignore today becomes a feature tomorrow."
set "f3=Snack break approved by RinesOS."
set "f4=The best time to reboot was ten minutes ago."
echo   ✦ !f%r%!
goto shell

:c_joke
set /a r=%random% %% 4
set "j0=Why do programmers prefer dark mode? Because light attracts bugs."
set "j1=There are 10 kinds of people: those who know binary and those who do not."
set "j2=My code does not have bugs. It has surprise features."
set "j3=I would tell you a UDP joke but you might not get it."
echo   !j%r%!
goto shell

:c_matrix
color 0A
for /l %%i in (1,1,120) do (
  echo !random!  !random!!random!  !random!  !random!!random!!random!  !random!  !random!
)
color %thm%
goto shell

:c_hack
color 0A
echo Initializing breach protocol...
call :wait 1
for %%s in (Bypassing firewall,Cracking mainframe,Injecting packets,Decrypting hash,Spoofing signal,Downloading secrets,Covering tracks) do (
  <nul set /p "=%%s "
  for /l %%d in (1,1,10) do (
    <nul set /p "=#"
    call :tick
  )
  echo  [OK]
)
echo.
echo ACCESS GRANTED.  ^(just kidding, nothing was hacked^)
color %thm%
goto shell

:c_scan
echo Scanning local network...
call :wait 1
echo   192.168.0.1    Router        [online]
echo   192.168.0.12   RinesOS-PC     [this device]
echo   192.168.0.23   SmartFridge    [online, judging you]
echo   192.168.0.47   Phone          [online]
echo   192.168.0.99   Mystery-Device [suspicious]
echo 5 devices found.
goto shell

:c_ping
set "host=!args!"
if not defined host set "host=rines.os"
echo Pinging !host! with 32 bytes of data:
for /l %%i in (1,1,4) do (
  set /a ms=!random! %% 40 + 8
  echo Reply from !host!: bytes=32 time=!ms!ms TTL=64
  call :wait 1
)
echo Ping complete.
goto shell

:c_weather
set /a r=%random% %% 4
set "w0=Sunny, 72F  ☀"
set "w1=Cloudy, 61F  ☁"
set "w2=Rainy, 55F  ☂"
set "w3=Snowy, 28F  ❄"
echo   RinesCity: !w%r%!
goto shell

:c_say
if not defined args set "args=Hello, I am Rinebot."
echo.
echo     ┌──────────┐
echo     │  ◉    ◉  │    !args!
echo     │    ──    │
echo     └──┬────┬──┘
echo        ╧    ╧
echo.
goto shell

:c_theme
echo   1. Matrix    2. Cyberpunk    3. Ocean    4. Sunset
choice /c 1234 /n /m "  Pick a theme: "
set "t=%errorlevel%"
if "%t%"=="1" set "thm=0A"
if "%t%"=="2" set "thm=0D"
if "%t%"=="3" set "thm=0B"
if "%t%"=="4" set "thm=0C"
color %thm%
echo   Theme applied.
goto shell

:c_music
echo   ♪ Playing the RinesOS startup jingle...
powershell -NoProfile -Command "[console]::beep(523,200);[console]::beep(659,200);[console]::beep(784,200);[console]::beep(1047,400)"
goto shell

:c_rainbow
for %%c in (1 2 3 4 5 6 9 A B C D E) do (
  color %%c
  echo   ░▒▓█ R I N E S  O S █▓▒░
  call :tick
)
color %thm%
goto shell

:c_countdown
for /l %%i in (5,-1,1) do (
  echo   %%i...
  call :wait 1
)
echo   ✦ LIFTOFF ✦
goto shell

:c_guess
set /a gs=%random% %% 20 + 1
echo   I am thinking of a number from 1 to 20.
:c_guess2
set "gg="
set /p "gg=  guess> "
set "gn=0"
set /a gn=gg 2>nul
if !gn! LSS !gs! echo   Higher.
if !gn! GTR !gs! echo   Lower.
if !gn! EQU !gs! (echo   Correct^^! & goto shell)
goto c_guess2

:c_ls
echo   drwx  Documents/
echo   drwx  Games/
echo   drwx  Music/
echo   -rw-  readme.txt
echo   -rw-  secret.txt
echo   -rwx  rinesos.sys
goto shell

:c_cat
if /i "!args!"=="readme.txt" (echo   Welcome to RinesOS. Type help to begin.& goto shell)
if /i "!args!"=="secret.txt" (echo   The cake is a lie. The snacks are real.& goto shell)
if not defined args (echo   usage: cat filename& goto shell)
echo   cat: !args!: No such file
goto shell

:c_sudo
echo   Nice try, %user%. You are already root of nothing.
goto shell

:c_rm
echo   Permission denied. RinesOS protects itself.
goto shell

:c_bsod
color 1F
cls
echo.
echo   :-(
echo.
echo   Your RinesOS ran into a problem and needs to restart.
echo   We are just collecting some error info, and then we will restart.
echo.
echo   Stop code: TOO_MANY_COMMANDS
echo.
echo   0%% complete
call :wait 4
goto boot

:c_shutdown
cls
color 07
echo.
echo   Saving settings...
call :bar "   Shutting down "
echo.
echo   It is now safe to turn off your imagination.
call :wait 2
endlocal
exit /b

:: =====================================================
::  BIOS SETUP
:: =====================================================
:bios
color 1F
cls
echo.
echo   ╔════════════════════════════════════════════════════════════╗
echo   ║               RinesBIOS Setup Utility v4.2.0               ║
echo   ╚════════════════════════════════════════════════════════════╝
echo.
echo     Boot Priority : %bootorder%
echo     Secure Boot   : %secureboot%
echo     Turbo Boost   : %turbo%
echo.
echo     1. System Information
echo     2. Change Boot Priority
echo     3. Toggle Secure Boot
echo     4. Toggle Turbo Boost
echo     5. Save and Exit
echo     6. Exit Without Saving
echo.
choice /c 123456 /n /m "     Select: "
set "b=%errorlevel%"
if "%b%"=="1" goto bios_info
if "%b%"=="2" goto bios_boot
if "%b%"=="3" goto bios_sb
if "%b%"=="4" goto bios_tb
if "%b%"=="5" goto bios_save
if "%b%"=="6" goto boot
goto bios

:bios_info
echo.
echo     BIOS     : RinesBIOS 4.2.0
echo     CPU      : RinesCore X9 Octa-Core @ 5.20 GHz
echo     Memory   : 32768 MB
echo     Storage  : RINES-SSD 1TB
echo     Serial   : RN-2026-%random%
echo.
pause
goto bios

:bios_boot
echo.
echo     1. RinesOS Boot Manager
echo     2. USB Drive
echo     3. Network ^(PXE^)
choice /c 123 /n /m "     Select first boot device: "
set "d=%errorlevel%"
if "%d%"=="1" set "bootorder=RinesOS Boot Manager"
if "%d%"=="2" set "bootorder=USB Drive"
if "%d%"=="3" set "bootorder=Network PXE"
goto bios

:bios_sb
if "%secureboot%"=="Enabled" (set "secureboot=Disabled") else (set "secureboot=Enabled")
goto bios

:bios_tb
if "%turbo%"=="Enabled" (set "turbo=Disabled") else (set "turbo=Enabled")
goto bios

:bios_save
echo.
echo     Saving configuration to CMOS...
call :wait 2
echo     Saved. Rebooting...
call :wait 1
goto boot

:: =====================================================
::  TROUBLESHOOT MENU
:: =====================================================
:troubleshoot
color 1F
cls
echo.
echo   ╔════════════════════════════════════════════════════════════╗
echo   ║                    TROUBLESHOOT MENU                       ║
echo   ╚════════════════════════════════════════════════════════════╝
echo.
echo     1. Startup Repair
echo     2. System Restore
echo     3. Memory Diagnostic
echo     4. Safe Mode
echo     5. Back to Boot Menu
echo.
choice /c 12345 /n /m "     Select: "
set "t=%errorlevel%"
if "%t%"=="5" goto bootmenu
cls
echo.
if "%t%"=="1" call :bar "   Repairing startup files "
if "%t%"=="2" call :bar "   Restoring last good state "
if "%t%"=="3" call :bar "   Testing memory "
if "%t%"=="4" (set "safe=1" & set "tag=[SAFE]" & echo   Safe Mode enabled for next boot.)
echo.
echo   Completed. A restart is required to apply changes.
echo   Restarting
for /l %%i in (1,1,6) do (
  <nul set /p "=."
  call :tick
)
goto boot

:: =====================================================
::  BOOTABLE DRIVES
:: =====================================================
:drives
color 1F
cls
echo.
echo   ╔════════════════════════════════════════════════════════════╗
echo   ║                 BOOT FROM DRIVE / DISC                     ║
echo   ╚════════════════════════════════════════════════════════════╝
echo.
echo     1. USB Drive    - RINES_LIVE
echo     2. DVD-RW Disc  - Install RinesOS 2.0
echo     3. Network PXE
echo     4. Back
echo.
choice /c 1234 /n /m "     Select: "
set "d=%errorlevel%"
if "%d%"=="4" goto bootmenu
if "%d%"=="3" goto pxe
if "%d%"=="2" goto installer
cls
color 0A
echo.
echo   Booting RinesOS Live from USB...
call :bar "   Loading live image "
set "tag=[LIVE]"
set "safe=0"
goto shellstart

:pxe
echo.
echo   Contacting PXE server...
call :wait 3
echo   PXE-E51: No DHCP or proxyDHCP offers were received.
call :wait 2
goto bootmenu

:installer
cls
color 0E
echo.
echo   RinesOS 2.0 Installer
echo.
call :bar "   Copying files "
call :bar "   Installing features "
call :bar "   Finalizing "
echo.
echo   Installation complete ^(simulated^). Restarting...
call :wait 3
goto boot

:: =====================================================
::  SUBROUTINES
:: =====================================================
:wait
set /a _n=%~1+1
ping -n !_n! 127.0.0.1 >nul
exit /b

:tick
for /l %%z in (1,1,15000) do rem
exit /b

:ok
echo [  OK  ] %~1
call :tick
exit /b

:bar
<nul set /p "=%~1 ["
for /l %%i in (1,1,30) do (
  <nul set /p "=█"
  call :tick
)
echo ] 100%%
exit /b
