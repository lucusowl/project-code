@ECHO OFF
SET lan=%1

@REM Save to archive/ and Initialize main code as template code
IF EXIST template.%lan% (
	COPY main.%lan% "archive/%date%-%time::=-%.%lan%"
	ECHO Archiving Completed.
	COPY "template/template.%lan%" main.%lan%
) ELSE (
	ECHO [ERROR]Not Found Template-Code of %lan%
	GOTO :eof
)

@REM Delete Executables
IF EXIST out	 ( DEL out )
IF EXIST out.out ( DEL out.out )
IF EXIST out.exe ( DEL out.exe )
IF EXIST out.app ( DEL out.app )
IF EXIST out.hex ( DEL out.hex )
ECHO Reset Completed.