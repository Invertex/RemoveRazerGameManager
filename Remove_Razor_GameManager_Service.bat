reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Razer Synapse Service" /v DependOnService
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Razer Synapse Service" /v DependOnService /t Reg_Sz /d RzActionSvc
sc stop "Razer Synapse Service"
sc config "Razer Synapse Service" depend=RzActionSvc
sc stop "Razer Game Manager Service"
sc config "Razer Game Manager Service" start=disabled
sc start "Razer Synapse Service"
pause
