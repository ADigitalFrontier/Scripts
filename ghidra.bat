@echo off
set CURRENT_DIR=%cd%
set GHIDRA_SUPPORT_DIR="PATH_TO_SUPPORT"
set GHIDRA_RUN_PATH="PATH_TO_ghidraRun.bat"
set PROJECT_BASE_DIR="WHERE TO PUT PROJECTS

for %%f in (%1) do set FILENAME=%%~nf
set FILE_EXT=%~x1

if "%FILE_EXT%" == ".gpr" (
    echo Detected a Ghidra project file. Opening the project in Ghidra...
    %GHIDRA_RUN_PATH% "%CURRENT_DIR%\%1"
    goto end
)

set PROJECT_DIR=%PROJECT_BASE_DIR%\%FILENAME%

set /a counter=0
:checkProjectName
if exist "%PROJECT_DIR%" (
    echo Project name "%FILENAME%" already exists.
    set /a counter+=1
    set PROJECT_DIR=%PROJECT_BASE_DIR%\%FILENAME%-%counter%
    echo Trying new project name: %FILENAME%-%counter%
    goto checkProjectName
)

echo Creating new project: %PROJECT_DIR%

mkdir "%PROJECT_DIR%"

cd %GHIDRA_SUPPORT_DIR%

(echo exit) | analyzeHeadless "%PROJECT_DIR%" "%FILENAME%" -import "%CURRENT_DIR%\%1"

if %errorlevel% neq 0 (
    echo Error occurred during the analyzeHeadless process. Exiting...
    goto end
)

if exist "%PROJECT_DIR%\%FILENAME%.gpr" (
    echo Opening the project in Ghidra...
    %GHIDRA_RUN_PATH% "%PROJECT_DIR%\%FILENAME%.gpr"
) else (
    echo Project file not found: "%PROJECT_DIR%\%FILENAME%.gpr"
)

:end

cd %CURRENT_DIR%
