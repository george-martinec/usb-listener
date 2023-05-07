@ECHO OFF
@REM UTF-8
chcp 65001
cls

ECHO ██    ██ ███████ ██████      ██      ██ ███████ ████████ ███████ ███    ██ ███████ ██████  
ECHO ██    ██ ██      ██   ██     ██      ██ ██         ██    ██      ████   ██ ██      ██   ██ 
ECHO ██    ██ ███████ ██████      ██      ██ ███████    ██    █████   ██ ██  ██ █████   ██████  
ECHO ██    ██      ██ ██   ██     ██      ██      ██    ██    ██      ██  ██ ██ ██      ██   ██ 
ECHO  ██████  ███████ ██████      ███████ ██ ███████    ██    ███████ ██   ████ ███████ ██   ██ 
ECHO:
ECHO Listening ...
ECHO:

SET /a previousCount = 0
SET /a count=0

:COUNT
    powershell.exe "Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -match '^USB' }" > .devices
    set /a count = 0
    for /f %%a in (.devices) do set /a count+=1
    if %previousCount% == 0 set /a previousCount = count

    @REM Connected
    if %previousCount% LSS %count% (
        set /a previousCount = count
        GOTO :CONNECTED
    )

    @REM Disconnected
    if %previousCount% GTR %count% (
        set /a previousCount = count
        GOTO :DISCONNECTED
    )

    GOTO :LOOP

:LOOP
    TIMEOUT -T 1 /nobreak > NUL
    GOTO :COUNT
    GOTO :LOOP

:CONNECTED
    CALL connected.bat
    GOTO :LOOP

:DISCONNECTED
    CALL disconnected.bat
    GOTO :LOOP

PAUSE