@echo off
set pwd=%~dp0

set names=IntelliJIdea Idea WebStorm DataGrip PhpStorm CLion PyCharm GoLand RubyMine Rider

for %%i in (%names%) do (

    @rem old version
    for /d %%j in (%USERPROFILE%\.%%i*) do (
        if exist "%%j\config\eval" (
            echo delete %%j\config\eval

            rmdir /s /q "%%j\config\eval"
        )

        if exist "%%j\config\options\options.xml" (
            echo delete %%j\config\options\options.xml

            type "%%j\config\options\options.xml" | find /v /i "evlsprt" > "%TEMP%\options.xml"
            move /y "%TEMP%\options.xml" "%%j\config\options\options.xml"
        )
    )

    @rem new version
    for /d %%j in (%APPDATA%\JetBrains\%%i*) do (
        if exist "%%j\eval" (
            echo delete %%j\eval

            rmdir /s /q "%%j\eval"
        )

        if exist "%%j\options\other.xml" (
            echo modify %%j\options\other.xml

            type "%%j\options\other.xml" | find /v /i "evlsprt" > "%TEMP%\other.xml"
            move /y "%TEMP%\other.xml" "%%j\options\other.xml"
        )
    )

    reg query HKEY_CURRENT_USER\Software\JavaSoft\Prefs\jetbrains\%%i /ve 1>nul 2>nul
    if ERRORLEVEL 1 (
        rem not found
    ) else (
        echo delete HKEY_CURRENT_USER\Software\JavaSoft\Prefs\jetbrains\%%i

        reg delete "HKEY_CURRENT_USER\Software\JavaSoft\Prefs\jetbrains\%%i" /f 2>nul
    )
)

pause
