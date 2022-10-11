@echo off
setlocal EnableDelayedExpansion
echo [ Steam Path ]
set KeyNameS="HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Bethesda Softworks\Skyrim Special Edition"
set ValueNameS="Installed Path"
for /f "tokens=3* delims= " %%A in ('reg query !KeyNameS! /v !ValueNameS!') do (
    set ResultTypeS="%%A"
    set ResultDataS="%%B"
)
echo Key   = !KeyNameS!
echo Value = !ValueNameS!
echo Type  = !ResultTypeS!
echo Data  = !ResultDataS!
echo:
echo [ GOG Path ]
set KeyNameG="HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\GOG.com\Games\1711230643"
set ValueNameG="Path"
for /f "tokens=2* delims= " %%A in ('reg query !KeyNameG! /v !ValueNameG!') do (
    set ResultTypeG="%%A"
    set ResultDataG="%%B"
)
echo Key   = !KeyNameG!
echo Value = !ValueNameG!
echo Type  = !ResultTypeG!
echo Data  = !ResultDataG!
echo:
echo For a more advanced solution visit https://github.com/Meridiano/SkyrimSE-Reg
echo:
pause