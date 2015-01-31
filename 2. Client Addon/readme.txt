A3EAI Client Optional Addon
----------------------------

1. How to install
------------------
The A3EAI client optional addon is used by A3EAI to run client-side commands. To install:
1. Unpack your mission pbo file (example: epoch.Altis.pbo) and copy the A3EAI_Client folder into the extracted folder.
2. Edit your extracted mission folder's init.sqf (or create one if none exists) and insert this:

	#include "A3EAI_Client\A3EAI_initclient.sqf";

3. Repack your mission pbo file.
4. In your server's A3EAI_config.sqf, you may now enable features supported by the A3EAI Client Addon:
	
	A3EAI_radioMsgs: 		Enables text message warnings to players with radios (Radio Quartz) when they are under pursuit by AI.
	A3EAI_deathMessages: 	Enables death messages for killing AI units. Messages are displayed to player who killed the AI unit. 
							If the player is in a vehicle, all crew members are notified if at least one crew member has a Radio in their inventory.


2. How to configure
------------------
Edit A3EAI_client_config.sqf to change settings and enable/disable features. By default, all features are enabled.