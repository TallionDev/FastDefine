@echo off
cd /d "%~dp0"
title Stergere Continut - Sursa si Sisteme Extras

:: Verificam daca avem drepturi de administrator
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo [!] Scriptul necesita drepturi de administrator. Se relanseaza...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

cls
echo ==========================================
echo Script pentru a sterge si curata sursa si fisierele extrase din:
echo 1. SURSA_GAME_DB_BINARY_PRINCIPALA
echo 2. SISTEMUL_EXTRAS_PRIN_DEFINE
echo 3. GlobalDefines.h
echo ==========================================
echo.

echo 1. Curata tot continutul
echo 2. Iesire
echo.

set /p opt=Alege o optiune (1 sau 2): 

if "%opt%"=="1" (
    echo.
    echo [!] Se sterg fisierele si directoarele...

    :: CURATA SURSA_GAME_DB_BINARY_PRINCIPALA
    if exist "SURSA_GAME_DB_BINARY_PRINCIPALA" (
        attrib -r -s -h "SURSA_GAME_DB_BINARY_PRINCIPALA\*" /S /D >nul 2>&1
        del /f /q "SURSA_GAME_DB_BINARY_PRINCIPALA\*" >nul 2>&1
        for /d %%x in ("SURSA_GAME_DB_BINARY_PRINCIPALA\*") do rmdir /s /q "%%x"
        echo [OK] Curatat: SURSA_GAME_DB_BINARY_PRINCIPALA
    ) else (
        echo [!] Folderul SURSA_GAME_DB_BINARY_PRINCIPALA nu exista.
    )

    :: CURATA SISTEMUL_EXTRAS_PRIN_DEFINE
    if exist "SISTEMUL_EXTRAS_PRIN_DEFINE" (
        attrib -r -s -h "SISTEMUL_EXTRAS_PRIN_DEFINE\*" /S /D >nul 2>&1
        del /f /q "SISTEMUL_EXTRAS_PRIN_DEFINE\*" >nul 2>&1
        for /d %%x in ("SISTEMUL_EXTRAS_PRIN_DEFINE\*") do rmdir /s /q "%%x"
        echo [OK] Curatat: SISTEMUL_EXTRAS_PRIN_DEFINE
    ) else (
        echo [!] Folderul SISTEMUL_EXTRAS_PRIN_DEFINE nu exista.
    )

    :: RESET GLOBALDEFINES
    if exist "GlobalDefines.h" (
        del /f /q "GlobalDefines.h"
        echo [OK] GlobalDefines.h sters.
    )
    echo // DEFINES ADDON > "GlobalDefines.h"
    echo [OK] GlobalDefines.h a fost recreat.

    echo.
    echo [✓] Curatarea completa a fost efectuata cu succes!
) else (
    echo.
    echo Iesire...
)

pause
