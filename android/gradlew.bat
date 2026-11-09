@echo off
setlocal
set "GRADLE_VERSION=8.10.2"
set "GRADLE_HOME=%USERPROFILE%\.gradle\manual-gradle\gradle-%GRADLE_VERSION%"
if not exist "%GRADLE_HOME%\bin\gradle.bat" (
  set "ZIP=%TEMP%\gradle-%GRADLE_VERSION%-bin.zip"
  powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest 'https://services.gradle.org/distributions/gradle-%GRADLE_VERSION%-bin.zip' -OutFile '%TEMP%\gradle-%GRADLE_VERSION%-bin.zip'; New-Item -ItemType Directory -Force -Path '%USERPROFILE%\.gradle\manual-gradle' | Out-Null; Expand-Archive -Force '%TEMP%\gradle-%GRADLE_VERSION%-bin.zip' '%USERPROFILE%\.gradle\manual-gradle'"
  if errorlevel 1 exit /b 1
)
call "%GRADLE_HOME%\bin\gradle.bat" %*
exit /b %ERRORLEVEL%
