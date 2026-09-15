@echo off
echo NOTICE: This project won't have TOR and won't route traffic through it
echo Building the Go project...

REM Ensure Go modules are tidy
go mod tidy

REM Build the executable
go build -o minestalker.exe

REM Check if the build succeeded
IF %ERRORLEVEL% EQU 0 (
    echo Build succeeded. Running the executable...
    minestalker.exe
) ELSE (
    echo Build failed.
    exit /b 1
)
