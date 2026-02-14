@echo off
if "%~1"=="" (
    wsl.exe -e /home/linuxbrew/.linuxbrew/bin/nvim
) else (
    for /f "usebackq tokens=*" %%a in (`wsl.exe -e wslpath -ua "%~dp1."`) do (
        for /f "usebackq tokens=*" %%b in (`wsl.exe -e wslpath -ua "%~1"`) do (
            wsl.exe --cd "%%a" -e /home/linuxbrew/.linuxbrew/bin/nvim "%%b"
            goto :eof
        )
    )
    wsl.exe -e /home/linuxbrew/.linuxbrew/bin/nvim %*
)
