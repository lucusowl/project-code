@ECHO OFF
@REM start.bat [+][language]
@REM if '+' exist in parameter, keep previous result in archive/
@REM language := c[default], cpp(c++), py(python)
SETLOCAL enabledelayedexpansion

@REM parsing parameter
IF "%1"=="" (
	@REM default lang is C/C++
	SET lan=cpp
) ELSE (
	ECHO %1 | FINDSTR /C:"+">nul && (
		@REM if '+' existed, backup previous result
		SET lan=%1
		SET lan=!lan:+=!
		ECHO.>>archive\result-backup.txt
		ECHO --------- %date% %time% --------->>archive\result-backup.txt
		TYPE result.txt >> archive\result-backup.txt
	) || (
		SET lan=%1
	)
)

@REM compile process
:Compile
IF !lan!==cpp (
	@REM C++
	IF EXIST "main.cpp" (
		g++ -o out.exe main.cpp
	) ELSE (
		ECHO [ERROR]Not Found Source-Code of C++
		GOTO :eof
	)
) ELSE IF !lan!==py (
	@REM python
	IF EXIST "main.py" (
		python -m py_compile main.py
	) ELSE (
		ECHO [ERROR]Not Found Source-Code of Python
		GOTO :eof
	)
) ELSE IF !lan!==c (
	@REM C
	IF EXIST "main.c" (
		gcc -o out.exe main.c
	) ELSE (
		ECHO [ERROR]Not Found Source-Code of !lan!
		GOTO :eof
	)
) ELSE (
	@REM Other language
	ECHO [INVALID]Not Supported !lan! type language.
	GOTO :eof
)
ECHO Complie completed.

:Main
@REM remove previous result
DEL result.txt
@REM test all case in test directory
SET idx=1
FOR %%A IN (test/*) DO (
	ECHO ========= Test Case !idx! : "%%A" =========>>result.txt
	IF !lan!==py (
		python main.py < test\%%A >> result.txt
	) ELSE (
		out.exe < test\%%A >> result.txt
	)
	SET /a idx+=1
)
ECHO ===========================================>>result.txt

:End
ENDLOCAL
ECHO Test Finish Sucessfully.