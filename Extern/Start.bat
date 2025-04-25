@echo off
setlocal EnableDelayedExpansion

rem ========================================================
rem   Pentru a modifica calea către pythonw.exe,
rem   editează acest fișier și schimbă linia de mai jos:
rem   set "DEFAULT_PATH=C:\Users\USERULTAU\AppData\Local\Programs\Python\Python313\pythonw.exe"
rem ========================================================

rem set "DEFAULT_PATH=C:\Users\USERULTAU\AppData\Local\Programs\Python\Python313\pythonw.exe"	se poate folosi si pythonw.exe
set "DEFAULT_PATH=C:\Users\USERULTAU\AppData\Local\Programs\Python\Python313\python.exe"
set "PYTHON_PATH=%DEFAULT_PATH%"
set "DEFINE_FILE=GlobalDefines.h"
set "OUTPUT_FOLDER=SISTEMUL_EXTRAS_PRIN_DEFINE"

:MENU
cls
echo ============================================
echo          Script Tallion - start.py
echo ============================================
echo.
echo Calea actuala catre Python: !PYTHON_PATH!
echo (Pentru a o modifica, editeaza acest fisier .bat)
echo.
echo 1. Start sistem extragere
echo 0. Iesire
echo.
set /p opt=Alege optiunea: 

if "%opt%"=="1" goto CHECK_DEFINE
if "%opt%"=="0" exit
goto MENU

:CHECK_DEFINE
if not exist "%DEFINE_FILE%" (
    echo.
    echo [EROARE] Fisierul %DEFINE_FILE% nu exista!
    echo Creeaza-l sau ruleaza Adauga_Define.bat.
    pause
    goto MENU
)

findstr /B /C:"#define" "%DEFINE_FILE%" >nul 2>&1
if errorlevel 1 (
    echo.
    echo [EROARE] Fisierul %DEFINE_FILE% nu contine niciun #define.
    echo Adauga cel putin un sistem in lista.
    pause
    goto MENU
)

goto RUN

:RUN
cls
echo [INFO] Pornesc scriptul start.py cu:
echo !PYTHON_PATH!
echo --------------------------------------------

rem Stergem rezultatele anterioare
if exist "!OUTPUT_FOLDER!" (
    rmdir /s /q "!OUTPUT_FOLDER!"
)

"!PYTHON_PATH!" start.py

if !errorlevel! == 0 (
    rem Verificam daca s-au extras fișiere în OUTPUT_FOLDER
    if exist "!OUTPUT_FOLDER!" (
        dir /b /s "!OUTPUT_FOLDER!" | findstr /r /v "^$" >nul
        if errorlevel 1 (
            echo.
            echo [EROARE] Niciun cod nu a fost extras.
            echo Acest define nu exista in sursa dvs.
            echo Verificati folderul SURSA_GAME_DB_BINARY_PRINCIPALA si GlobalDefines.h.
        ) else (
            echo.
            echo ============================================
            echo [SUCCES] Sistemul a fost extras complet!
            echo ============================================
        )
    ) else (
        echo.
        echo [EROARE] Folderul de iesire nu a fost generat.
        echo Acest define nu exista in sursa dvs.
    )
) else (
    echo.
    echo [EROARE] A aparut o problema la rularea scriptului Python!
)

echo.
pause
goto MENU

