# RemoveRazerGameManager
Disables the "Razer Game Manager Service" that is known to cause issues on some PC configurations.
Razer prevents this service from being disabled by setting it as a dependency of the Synapse service, when really it is not. 
This removes that restriction and disables it for you.

Simply download the `Remove_Razor_GameManager_Service.bat` file from the Releases section, right-click it and "Run as administrator" and it will do the rest for you :)
