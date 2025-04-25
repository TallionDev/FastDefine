@echo off
title Curatare Sisteme Extras si Defines
setlocal EnableDelayedExpansion

set DEFINE_FILE=GlobalDefines.h
set EXTRAS_DIR=SISTEMUL_EXTRAS_PRIN_DEFINE

:MENU
cls
echo ================================================
echo     [ MENIU DE CURATARE ]
echo ================================================
echo 1. Curata %EXTRAS_DIR%
echo 2. Curata %DEFINE_FILE%
echo 3. Curata ambele (Extras + Define)
echo 0. Iesire
echo.

set /p opt=Alege o optiune (1 2 3 0): 

if "%opt%"=="1" goto CURATA_EXTRAS
if "%opt%"=="2" goto CURATA_DEFINE
if "%opt%"=="3" goto CURATA_AMBELE
if "%opt%"=="0" goto EXIT
goto MENU

:CURATA_EXTRAS
echo [INFO] Se curata continutul din folderul %EXTRAS_DIR%...
rmdir /s /q "%EXTRAS_DIR%" >nul 2>&1
mkdir "%EXTRAS_DIR%"
echo [DONE] Curatare completa!
pause
goto MENU

:CURATA_DEFINE
echo [INFO] Se curata fisierul %DEFINE_FILE%...
del "%DEFINE_FILE%" >nul 2>&1
echo // DEFINES ADDON > "%DEFINE_FILE%"
echo [DONE] Fisierul a fost resetat.
pause
goto MENU

:CURATA_AMBELE
echo [INFO] Se curata %EXTRAS_DIR% si %DEFINE_FILE%...
rmdir /s /q "%EXTRAS_DIR%" >nul 2>&1
mkdir "%EXTRAS_DIR%"
del "%DEFINE_FILE%" >nul 2>&1
echo // DEFINES ADDON > "%DEFINE_FILE%"
echo [DONE] Ambele au fost curatate.
pause
goto MENU

:EXIT
echo Iesire...
pause
exit
