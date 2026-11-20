@echo off
setlocal

set "REPO_DIR=%~dp0"
set "SP_DIR=%USERPROFILE%\ifm electronic gmbh\ifm.US.Product Management - Draw.io"
set "MSG=%~1"
if "%MSG%"=="" set "MSG=Update ifm draw.io libraries"

echo [1/3] Syncing XML libraries to SharePoint local folder...
if exist "%SP_DIR%" (
    copy /Y "%REPO_DIR%*.xml" "%SP_DIR%\" >nul
    echo       Copied *.xml to %SP_DIR%
) else (
    echo       WARNING: SharePoint sync folder not found at %SP_DIR% (skipping Desktop sync)
)

echo [2/3] Committing changes to Git...
cd /d "%REPO_DIR%"
git add -A
git diff --cached --quiet
if %errorlevel%==0 (
    echo       No Git changes to commit.
) else (
    git commit -m "%MSG%"
)

echo [3/3] Pushing to GitHub (auto-deploys GitHub Pages)...
git push

echo.
echo Done! Browser (GitHub Pages) and Desktop (SharePoint) are both updated.
pause
