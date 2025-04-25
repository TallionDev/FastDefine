@echo off
setlocal EnableDelayedExpansion

:: Calea spre fișierul de define-uri
set DEFINE_FILE=GlobalDefines.h

:: Creează fișierul dacă nu există
if not exist "%DEFINE_FILE%" (
    echo // DEFINES ADDON > "%DEFINE_FILE%"
)

:LOOP
cls
echo --------------------------------------
echo Introdu numele define-ului pe care vrei sa-l adaugi.
echo Adauga doar numele fara #define exemplu: ENABLE_DIRECTX9.
echo Scrie ^<exit^> pentru a iesi
echo --------------------------------------

set /p DEFINE_NAME=Define: 
set DEFINE_NAME=%DEFINE_NAME: =%

:: Dacă e "exit", închide scriptul
if /i "%DEFINE_NAME%"=="exit" goto EOF

:: Verifică dacă define-ul există deja
findstr /B /C:"#define %DEFINE_NAME%" "%DEFINE_FILE%" >nul
if %errorlevel%==0 (
    echo [INFO] Define-ul "#define %DEFINE_NAME%" exista deja.
) else (
    echo #define %DEFINE_NAME%>>"%DEFINE_FILE%"
    echo [OK] Define-ul "#define %DEFINE_NAME%" a fost adaugat.
)

pause
goto LOOP

:EOF
echo Script terminat.
pause
