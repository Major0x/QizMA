# QuizMaster Lab Installer
# This script creates a desktop shortcut that opens QuizMaster in "App Mode"

$AppUrl = "https://Major0x.github.io/QizMA/"
$AppName = "QuizMaster"
$IconUrl = "https://Major0x.github.io/QizMA/icon.png"
$AppDataPath = Join-Path $env:LOCALAPPDATA "QuizMaster"

# 1. Create AppData folder for the icon
if (!(Test-Path $AppDataPath)) {
    New-Item -ItemType Directory -Path $AppDataPath | Out-Null
}

# 2. Download Icon
$IconPath = Join-Path $AppDataPath "icon.ico"
Write-Host "Setting up $AppName..." -ForegroundColor Cyan

# Note: We use the PNG as icon source; Windows shortcuts prefer .ico but modern browsers handle this
$TempIcon = Join-Path $AppDataPath "icon.png"
Invoke-WebRequest -Uri $IconUrl -OutFile $TempIcon

# 3. Find Browser (Chrome or Edge)
$BrowserPath = ""
$ChromePath = "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
$ChromePath86 = "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
$EdgePath = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"

if (Test-Path $ChromePath) { $BrowserPath = $ChromePath }
elseif (Test-Path $ChromePath86) { $BrowserPath = $ChromePath86 }
elseif (Test-Path $EdgePath) { $BrowserPath = $EdgePath }

if ($BrowserPath -eq "") {
    Write-Error "Neither Chrome nor Edge was found. Please install a modern browser."
    exit
}

# 4. Create Desktop Shortcut
$WshShell = New-Object -ComObject WScript.Shell
$ShortcutPath = Join-Path ([Environment]::GetFolderPath("Desktop")) "$AppName.lnk"
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $BrowserPath
$Shortcut.Arguments = "--app=$AppUrl"
$Shortcut.WorkingDirectory = $BrowserPath | Split-Path
$Shortcut.IconLocation = $TempIcon
$Shortcut.Save()

Write-Host "✅ Success! $AppName has been installed on your Desktop." -ForegroundColor Green
Write-Host "You can now open it to start taking quizzes." -ForegroundColor Gray
