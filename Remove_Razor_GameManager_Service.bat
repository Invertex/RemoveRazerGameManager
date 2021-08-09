@Echo off
ECHO Removing Game Manager Service dependency from Registry...
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Razer Synapse Service" /v DependOnService /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Razer Synapse Service" /v DependOnService /t Reg_Sz /d RzActionSvc /f
ECHO.

sc query "Razer Synapse Service" | find "RUNNING" > NUL
IF %ERRORLEVEL% NEQ 1 ( 
	ECHO Stopping "Razer Synapse Service"...
	sc stop "Razer Synapse Service" > NUL
)
sc query "Razer Game Manager Service" | find "RUNNING" > NUL
IF %ERRORLEVEL% NEQ 1 ( 
	ECHO Stopping "Razer Game Manager Service"...
	sc stop "Razer Game Manager Service" > NUL
)
sc query "RzActionSvc" | find "RUNNING" > NUL
IF %ERRORLEVEL% NEQ 1 ( 
	ECHO Stopping "Razer Action Service"...
	sc stop "RzActionSvc" > NUL
)

sc config "RzActionSvc" start=demand > NUL
sc config "Razer Synapse Service" depend=RzActionSvc > NUL
sc config "Razer Synapse Service" start=auto > NUL

ECHO Disabling "Razer Game Manager Service"...
sc config "Razer Game Manager Service" start=disabled > NUL

:CHECK_RZ_SERVICE_PENDING
sc query "RzActionSvc" | find "PENDING" > NUL
IF %ERRORLEVEL% NEQ 1 ( 
	ECHO Waiting for "Razer Action Service" to stop...
	TIMEOUT /t 4 /NOBREAK
	ECHO.
	GOTO CHECK_RZ_SERVICE_PENDING
)

sc start "RzActionSvc" > NUL
ECHO Starting "Razer Action Service"...

:CHECK_RZ_SERVICE
sc query "RzActionSvc" | find "RUNNING" > NUL
IF %ERRORLEVEL% NEQ 0 (
	ECHO "Razer Action Service" is not running yet, waiting...
	TIMEOUT /t 10 /NOBREAK
	ECHO.
	GOTO CHECK_RZ_SERVICE
) ELSE (
	ECHO "Razer Action Service" is now running.
)

sc start "Razer Synapse Service" > NUL
ECHO "Razer Synapse Service" started.
ECHO.
ECHO All done!
ECHO.
pause
