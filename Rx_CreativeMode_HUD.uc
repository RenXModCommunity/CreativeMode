class Rx_CreativeMode_HUD extends Rx_HUD;

var int DefaultTargettingRangex, pageNum;
var privatewrite Rx_CreativeMode_HUDC AdminHud;
var bool OpenMenu;
var bool SpawnMenu;
var bool RxVehicleMenu;
var bool RxVehicleMenu2;
var bool TSVehicleMenu;
var bool DefencesMenu;
var bool OtherMenu;
var bool CharTeamSelect;
var bool GDICharMenu1;
var bool GDICharMenu2;
var bool NodCharMenu1;
var bool NodCharMenu2;

var bool bDrawFPSMenu;
var privatewrite array<Object> CurrentList;

event PostRender()
{
	Super.PostRender();

	if (OpenMenu) CreateAdminToolMenu();
}

function ButtonPressed(string Key)
{
	local Rx_CreativeMode_Controller PC;


	PC = Rx_CreativeMode_Controller(PlayerOwner);


	if (OpenMenu && !SpawnMenu && !RxVehicleMenu && !RxVehicleMenu2 && !TSVehicleMenu && !DefencesMenu && !OtherMenu && !CharTeamSelect && !GDICharMenu1 && !GDICharMenu2 && !NodCharMenu1 && !NodCharMenu2)
	{
		switch (Key)
		{
			case "one":
				PC.StartTyping("Gimme ");
			break;
	
			case "two":
				PC.StartTyping("SandboxSpawn ");
			break;
	
			case "three":
				PC.StartTyping("GiveChar ");
			break;
	
			case "four":
				PC.StartTyping("SandBoxKillOwned ");
			break;
	
			case "five":
				PC.StartTyping("GiveCreds ");
			break;
	
			case "six":
				PC.StartTyping("GivePromo ");
			break;

			case "seven":
				PC.LockHealth();
			break;

			case "eight":
				PC.StartTyping("GiveGod ");
			break;

			case "nine":
				PC.DestroyDefences();
			break;
			case "zero":
//				ToggleSpawnMenu();
			break;
		}
	}
	else if (SpawnMenu && !RxVehicleMenu)
	{
		switch (Key)
		{
			case "one":
//				ToggleRxVehicleMenu();
			break;
	
			case "two":
//				ToggleTSVehicleMenu();
			break;
	
			case "three":
//				ToggleDefencesMenu();
			break;
	
			case "four":
//				ToggleWeaponsMenu();
			break;
	
			case "five":
//				ToggleCharMenu();
			break;

			case "six":
//				ToggleOtherMenu();
			break;

			case "seven":
				PC.SandboxKillOwned();
			break;
	
			case "zero":
//				ToggleSpawnMenu();
			break;
		}
	}
	else if (RxVehicleMenu)
	{
		switch (Key)
		{
			case "one":
//				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_Humvee");
			break;
	
			case "two":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_APC_GDI");
			break;
	
			case "three":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_MRLS");
			break;
	
			case "four":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_MediumTank");
			break;
	
			case "five":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_MammothTank");
			break;
	
			case "six":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_Orca");
			break;

			case "seven":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_Chinook_GDI");
			break;

			case "eight":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_A10");
			break;

			case "nine":
//				ToggleRxVehicleMenu2();
			break;
			case "zero":
//				ToggleRxVehicleMenu();
			break;	
		}
	}
		else if (RxVehicleMenu2)
	{
		switch (Key)
		{
			case "one":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_Buggy");
			break;
	
			case "two":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_APC_Nod");
			break;
	
			case "three":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_Artillery");
			break;
	
			case "four":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_LightTank");
			break;
	
			case "five":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_FlameTank");
			break;
	
			case "six":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_StealthTank");
			break;

			case "seven":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_Apache");
			break;

			case "eight":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_Chinook_Nod");
			break;

			case "nine":
//				ToggleRxVehicleMenu2();
			break;
			case "zero":
//				ToggleRxVehicleMenu();
			break;	
		}
	}
		else if (TSVehicleMenu)
	{
		switch (Key)
		{
			case "one":
				PC.SandboxSpawn("Renx_Game.TS_Vehicle_Wolverine");
			break;
	
			case "two":
//				PC.SandboxSpawn("Renx_Game.TS_Vehicle_HoverMRLS");
			break;

			case "three":
				PC.SandboxSpawn("Renx_Game.TS_Vehicle_Titan");
			break;
	
			case "four":
				PC.SandboxSpawn("Renx_Game.TS_Vehicle_ReconBike");
			break;
	
			case "five":
				PC.SandboxSpawn("Renx_Game.TS_Vehicle_Buggy");
			break;
	
			case "six":
				PC.SandboxSpawn("Renx_Game.TS_Vehicle_TickTank");
			break;

			case "zero":
//				ToggleTSVehicleMenu();
			break;	
		}
	}
		else if (DefencesMenu)
	{
		switch (Key)
		{
			case "one":
				PC.SandboxSpawn("Renx_Game.Rx_Defence_GuardTower");
			break;
	
			case "two":
				PC.SandboxSpawn("Renx_Game.Rx_Defence_GuardTower_Nod");
			break;
	
			case "three":
//				PC.SandboxSpawn("Renx_Game.Rx_Defence_Turret");
			break;
	
			case "four":
				PC.SandboxSpawn("Renx_Game.Rx_Defence_Turret_GDI");
			break;
	
			case "five":
				PC.SandboxSpawn("Renx_Game.Rx_Defence_AATower");
			break;
	
			case "six":
				PC.SandboxSpawn("Renx_Game.Rx_Defence_SAMSite");
			break;

			case "seven":
				PC.SandboxSpawn("Renx_Game.Rx_Defence_GunEmplacement");
			break;

			case "eight":
				PC.SandboxSpawn("Renx_Game.Rx_Defence_RocketEmplacement");
			break;

			case "zero":
//				ToggleDefencesMenu();
			break;	
		}
	}
		else if (OtherMenu)
	{
		switch (Key)
		{
			case "one":
				PC.SandboxSpawn("Renx_Game.Rx_Vehicle_M2Bradley");
			break;
	
			case "two":
				PC.SandboxSpawn("Renx_Game.APB_Vehicle_TeslaTank");
			break;
	
			case "three":
				PC.SandboxSpawn("Renx_Game.Rx_Defence_SAMSite_Manual");
			break;
	
			case "four":
				PC.Gimme("TRR.Obygun");
				PC.CTextMessage("Obelisk Gun acquired", 'Green');
			break;
	
			case "five":
				PC.Gimme("TRR.SuperRepairGun");
				PC.CTextMessage("Super Repair Gun acquired", 'Green');
			break;
	

			case "zero":
//				ToggleOtherMenu();
			break;	
		}
	}
	else if (GDICharMenu1)
	{
		switch (Key)
		{
			case "one":
//				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Soldier");
			break;
	
			case "two":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Shotgunner");
			break;
	
			case "three":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Grenadier");
			break;
	
			case "four":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Marksman");
			break;
	
			case "five":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Engineer");
			break;
	
			case "six":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Officer");
			break;

			case "seven":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_RocketSoldier");
			break;

			case "eight":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_McFarland");
			break;

			case "nine":
//				ToggleRxVehicleMenu2();
			break;
			case "zero":
//				ToggleRxVehicleMenu();
			break;	
		}
	}
		else if (GDICharMenu2)
	{
		switch (Key)
		{
			case "one":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Deadeye");
			break;
	
			case "two":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Gunner");
			break;
	
			case "three":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Patch");
			break;
	
			case "four":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Havoc");
			break;
	
			case "five":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Sydney");
			break;
	
			case "six":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Mobius");
			break;

			case "seven":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Hotwire");
			break;

			case "eight":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Sydney_Suit");
			break;

			case "nine":
//				ToggleRxVehicleMenu2();
			break;
			case "zero":
//				ToggleRxVehicleMenu();
			break;	
		}
	}
		else if (NodCharMenu1)
	{
		switch (Key)
		{
			case "one":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_Soldier");
			break;
	
			case "two":
//				PC.GiveChar("Renx_Game.Rx_Familyinfo_GDI_Shotgunner");
			break;
	
			case "three":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_FlameTrooper");
			break;
	
			case "four":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_Marksman");
			break;
	
			case "five":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_Engineer");
			break;
	
			case "six":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_Officer");
			break;

			case "seven":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_RocketSoldier");
			break;

			case "eight":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_ChemicalTrooper");
			break;

			case "nine":
//				ToggleRxVehicleMenu2();
			break;
			case "zero":
//				ToggleRxVehicleMenu();
			break;	
		}
	}
		else if (NodCharMenu2)
	{
		switch (Key)
		{
			case "one":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_BlackHandSniper");
			break;
	
			case "two":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_StealthBlackHand");
			break;
	
			case "three":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_LaserChaingunner");
			break;
	
			case "four":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_Sakura");
			break;
	
			case "five":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_Raveshaw");
			break;
	
			case "six":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_Mendoza");
			break;

			case "seven":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_Technician");
			break;

			case "eight":
				PC.GiveChar("Renx_Game.Rx_Familyinfo_Nod_Raveshaw_Mutant");
			break;

			case "nine":
//				ToggleRxVehicleMenu2();
			break;
			case "zero":
//				ToggleRxVehicleMenu();
			break;	
		}
	}
	else return;
}


function Message(PlayerReplicationInfo PRI, coerce string Msg, name MsgType, optional float LifeTime)
{
	local string cName, fMsg, rMsg;
	local bool bEVA;

	if (Len(Msg) == 0)
		return;

	if (bMessageBeep)
		PlayerOwner.PlayBeepSound();

	// Create Raw and Formatted Chat Messages
	
	if (PRI != None)
	{	
		// We have a player, let's sort this out
		cName = CleanHTMLMessage(PRI.PlayerName);

		if (PRI.bAdmin)
			cName = "<font color='#00ffc9'><b>[ADMIN]</b></font> " $ cName;
	
		else if (Rx_PRI(PRI).bModeratorOnly)
			cName = "<font color='#02FF00'><b>[MOD]</b></font> " $ cName;
	}

	else
		cName = "Host";
		
	if (MsgType == 'Say') {
		if (PRI == None)
			fMsg = "<font color='" $HostColor$"'>" $cName$"</font>: <font color='#FFFFFF'>"$CleanHTMLMessage(Msg)$"</font>";
		else if (PRI.Team.GetTeamNum() == TEAM_GDI)
			fMsg = "<font color='" $GDIColor $"'>" $cName $"</font>: ";
		else if (PRI.Team.GetTeamNum() == TEAM_NOD)
			fMsg = "<font color='" $NodColor $"'>" $cName $"</font>: ";
	
		if ( cName != "Host" ) {
			fMsg $= CleanHTMLMessage(Msg);
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
		}
	}
	else if (MsgType == 'SSay') {
		if (PRI == None)
			fMsg = "<font color='" $"#C67EF9"$"'>" $"Creative"$"</font>: <font color='#FFFFFF'>"$CleanHTMLMessage(Msg)$"</font>";
		else if (PRI.Team.GetTeamNum() == TEAM_GDI)
			fMsg = "<font color='" $GDIColor $"'>" $cName $"</font>: ";
		else if (PRI.Team.GetTeamNum() == TEAM_NOD)
			fMsg = "<font color='" $NodColor $"'>" $cName $"</font>: ";
	
		if ( cName != "Host" ) {
			fMsg $= CleanHTMLMessage(Msg);
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
		}
	}
	else if (MsgType == 'TeamSay') {
		if (PRI.GetTeamNum() == TEAM_GDI)
		{
			fMsg = "<font color='" $GDIColor $"'>" $ cName $": "$ CleanHTMLMessage(Msg) $"</font>";
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
		}
		else if (PRI.GetTeamNum() == TEAM_NOD)
		{
			fMsg = "<font color='" $NodColor $"'>" $ cName $": "$ CleanHTMLMessage(Msg) $"</font>";
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
		}
	}
	else if (MsgType == 'Radio')
	{
		if(Rx_PRI(PRI).bGetIsCommander())
			fMsg = "<font color='" $CommandTextColor $"'>" $ "[Commander]" $ cName $": "$ Msg $"</font>"; 
		else
			fMsg = "<font color='" $RadioColor $"'>" $ cName $": "$ Msg $"</font>"; 
		
		fMsg = HighlightStructureNames(fMsg); 
		//PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = cName $": "$ Msg;
	}
	else if (MsgType == 'Commander') 
	{
		if(Left(Caps(msg), 2) == "/C") 
		{
			msg = Right(msg, Len(msg)-2);
			Rx_Controller(PlayerOwner).CTextMessage(msg,'Pink', 120.0,,true);
		}
		else
		if(Left(Caps(msg), 2) == "/R") 
		{
			msg = Right(msg, Len(msg)-2);
			Rx_Controller(PlayerOwner).CTextMessage(msg,'Pink', 360.0,,true);
		}
		fMsg = "<b><font color='" $CommandTextColor $"'>" $ "[Commander]"$ cName $": "$ CleanHTMLMessage(Msg) $"</font></b>";
		//PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = cName $": "$ Msg;
	}
	else if (MsgType == 'System') {
		if(InStr(Msg, "entered the game") >= 0)
			return;
		fMsg = Msg;
		PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = Msg;
	}
	else if (MsgType == 'PM') {
		if (PRI != None)
			fMsg = "<font color='"$PrivateFromColor$"'>Private from "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		else
			fMsg = "<font color='"$HostColor$"'>Private from "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		PrivateChatMessageLog $= "\n" $ fMsg;
		rMsg = "Private from "$ cName $": "$ Msg;
	}
	else if (MsgType == 'PM_Loopback') {
		fMsg = "<font color='"$PrivateToColor$"'>Private to "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		PrivateChatMessageLog $= "\n" $ fMsg;
		rMsg = "Private to "$ cName $": "$ Msg;
	}
	else
		bEVA = true;

	// Add to currently active GUI | Edit by Yosh : Don't bother spamming the non-HUD chat logs with radio messages... it's pretty pointless for them to be there.
	if (bEVA)
	{
		if (HudMovie != none && HudMovie.bMovieIsOpen)
			HudMovie.AddEVAMessage(Msg);
	}
	else
	{
		if (HudMovie != none && HudMovie.bMovieIsOpen)
			HudMovie.AddChatMessage(fMsg, rMsg);

		if (Scoreboard != none && MsgType != 'Radio' && Scoreboard.bMovieIsOpen) {
			if (PlayerOwner.WorldInfo.GRI.bMatchIsOver) {
				Scoreboard.AddChatMessage(fMsg, rMsg);
			}
		}

		if (RxPauseMenuMovie != none && MsgType != 'Radio' && RxPauseMenuMovie.bMovieIsOpen) {
			if (RxPauseMenuMovie.ChatView != none) {
				RxPauseMenuMovie.ChatView.AddChatMessage(fMsg, rMsg, MsgType=='PM' || MsgType=='PM_Loopback');
			}
		}

	}
}

function ToggleMenu()
{
	OpenMenu = !OpenMenu;
}

function ToggleSpawnMenu()
{
	SpawnMenu = !SpawnMenu;
}


function CreateAdminToolMenu()
{
	local array<MenuOption> MenuOptions;
	local MenuOption Option;
	local Rx_Controller PC;
	local ASColorTransform defaultCT;

	defaultCT.add.R = 0;
	defaultCT.add.G = 0;
	defaultCT.add.B = 0;
	defaultCT.multiply.R = 0.83;
	defaultCT.multiply.G = 0.94;
	defaultCT.multiply.B = 1.0;

	PC = Rx_Controller(PlayerOwner);

	Option.myCT = defaultCT;

if (!SpawnMenu && !RxVehicleMenu && !RxVehicleMenu2 && !TSVehicleMenu &&!DefencesMenu && !OtherMenu && !CharTeamSelect && !GDICharMenu1 && !GDICharMenu2 && !NodCharMenu1 && !NodCharMenu2)
{

	Option.Position = 0;
	Option.Key = "";
	Option.Message = "Creative Mode";
	MenuOptions.AddItem(Option);

	Option.Position = 14;
	Option.Key = "CTRL + B";
	Option.Message = "              Exit Menu";
	MenuOptions.AddItem(Option);

	if (PC.PlayerReplicationInfo.bAdmin)
	{
		Option.Position = 1;
		Option.Key = "1";
		Option.Message = "Gimme (WeaponClass)";
		MenuOptions.AddItem(Option);
	
		Option.Position = 2;
		Option.Key = "2";
		Option.Message = "SandboxSpawn (VehicleClass)";
		MenuOptions.AddItem(Option);

		Option.Position = 3;
		Option.Key = "3";
		Option.Message = "GiveChar (Class)";
		MenuOptions.AddItem(Option);

		Option.Position = 4;
		Option.Key = "4";
		Option.Message = "SandboxKillOwned Optional (Class)";
		MenuOptions.AddItem(Option);

		Option.Position = 5;
		Option.Key = "5";
		Option.Message = "GiveCreds Optional (Player)";
		MenuOptions.AddItem(Option);
	
		Option.Position = 6;
		Option.Key = "6";
		Option.Message = "GivePromo Optional (Player)";
		MenuOptions.AddItem(Option);
	
		Option.Position = 7;
		Option.Key = "7";
		Option.Message = "LockHealth";
		MenuOptions.AddItem(Option);

		Option.Position = 8;
		Option.Key = "8";
		Option.Message = "GiveGod Optional (Player)";
		MenuOptions.AddItem(Option);

		Option.Position = 9;
		Option.Key = "9";
		Option.Message = "DestroyDefences";
		MenuOptions.AddItem(Option);
		
		Option.Position = 10;
		Option.Key = "0";
		Option.Message = "Spawn Menu";
		MenuOptions.AddItem(Option);
	} 
	else
	{
		Option.Position = 1;
		Option.Key = "1";
		Option.Message = "Gimme (WeaponClass)";
		MenuOptions.AddItem(Option);
	
		Option.Position = 2;
		Option.Key = "2";
		Option.Message = "SandboxSpawn (VehicleClass)";
		MenuOptions.AddItem(Option);

		Option.Position = 4;
		Option.Key = "";
		Option.Message = "You're not admin :(";
		MenuOptions.AddItem(Option);

		Option.Position = 3;
		Option.Key = "0";
		Option.Message = "Spawn Menu";
		MenuOptions.AddItem(Option);
	}
	
}
if (SpawnMenu)
{
	Option.Position = 0;
	Option.Key = "";
	Option.Message = "Spawn Menu";
	MenuOptions.AddItem(Option);

	Option.Position = 13;
	Option.Key = "0";
	Option.Message = "              Exit";
	MenuOptions.AddItem(Option);

	Option.Position = 14;
	Option.Key = "CTRL + B";
	Option.Message = "              Exit Menu";
	MenuOptions.AddItem(Option);

	Option.Position = 1;
	Option.Key = "1";
	Option.Message = "RenX Vehicles";
	MenuOptions.AddItem(Option);
	
	Option.Position = 2;
	Option.Key = "2";
	Option.Message = "TS Vehicles";
	MenuOptions.AddItem(Option);

	Option.Position = 3;
	Option.Key = "3";
	Option.Message = "Defences";
	MenuOptions.AddItem(Option);

	Option.Position = 4;
	Option.Key = "4";
	Option.Message = "Weapons (Soon)";
	MenuOptions.AddItem(Option);

	Option.Position = 5;
	Option.Key = "5";
	Option.Message = "Characters";
	MenuOptions.AddItem(Option);

	Option.Position = 6;
	Option.Key = "6";
	Option.Message = "Other";
	MenuOptions.AddItem(Option);

	Option.Position = 7;
	Option.Key = "7";
	Option.Message = "Remove all your spawns";
	MenuOptions.AddItem(Option);


}
if (RxVehicleMenu)
{
	Option.Position = 0;
	Option.Key = "";
	Option.Message = "RenX Vehicles";
	MenuOptions.AddItem(Option);

	Option.Position = 12;
	Option.Key = "9";
	Option.Message = "              Next Page";
	MenuOptions.AddItem(Option);

	Option.Position = 13;
	Option.Key = "0";
	Option.Message = "              Exit";
	MenuOptions.AddItem(Option);

	Option.Position = 14;
	Option.Key = "CTRL + B";
	Option.Message = "              Exit Menu";
	MenuOptions.AddItem(Option);

	Option.Position = 1;
	Option.Key = "1";
	Option.Message = "Humvee";
	MenuOptions.AddItem(Option);
	
	Option.Position = 2;
	Option.Key = "2";
	Option.Message = "APC (GDI)";
	MenuOptions.AddItem(Option);

	Option.Position = 3;
	Option.Key = "3";
	Option.Message = "MRLS";
	MenuOptions.AddItem(Option);

	Option.Position = 4;
	Option.Key = "4";
	Option.Message = "Medium Tank";
	MenuOptions.AddItem(Option);

	Option.Position = 5;
	Option.Key = "5";
	Option.Message = "Mammoth Tank";
	MenuOptions.AddItem(Option);

	Option.Position = 6;
	Option.Key = "6";
	Option.Message = "Orca";
	MenuOptions.AddItem(Option);

	Option.Position = 7;
	Option.Key = "7";
	Option.Message = "Chinook (GDI)";
	MenuOptions.AddItem(Option);

	Option.Position = 8;
	Option.Key = "8";
	Option.Message = "A10";
	MenuOptions.AddItem(Option);
}
if (RxVehicleMenu2)
{
	Option.Position = 0;
	Option.Key = "";
	Option.Message = "RenX Vehicles";
	MenuOptions.AddItem(Option);

	Option.Position = 13;
	Option.Key = "0";
	Option.Message = "              Previous Page";
	MenuOptions.AddItem(Option);

	Option.Position = 14;
	Option.Key = "CTRL + B";
	Option.Message = "              Exit Menu";
	MenuOptions.AddItem(Option);

	Option.Position = 1;
	Option.Key = "1";
	Option.Message = "Buggy";
	MenuOptions.AddItem(Option);
	
	Option.Position = 2;
	Option.Key = "2";
	Option.Message = "APC (Nod)";
	MenuOptions.AddItem(Option);

	Option.Position = 3;
	Option.Key = "3";
	Option.Message = "Artillery";
	MenuOptions.AddItem(Option);

	Option.Position = 4;
	Option.Key = "4";
	Option.Message = "Light Tank";
	MenuOptions.AddItem(Option);

	Option.Position = 5;
	Option.Key = "5";
	Option.Message = "Flame Tank";
	MenuOptions.AddItem(Option);

	Option.Position = 6;
	Option.Key = "6";
	Option.Message = "Stealth Tank";
	MenuOptions.AddItem(Option);

	Option.Position = 7;
	Option.Key = "7";
	Option.Message = "Apache";
	MenuOptions.AddItem(Option);

	Option.Position = 8;
	Option.Key = "8";
	Option.Message = "Chinook (Nod)";
	MenuOptions.AddItem(Option);
	
	Option.Position = 9;
	Option.Key = "9";
	Option.Message = "MIG35";
	MenuOptions.AddItem(Option);
}

if (TSVehicleMenu)
{
	Option.Position = 0;
	Option.Key = "";
	Option.Message = "TS Vehicles";
	MenuOptions.AddItem(Option);

	Option.Position = 13;
	Option.Key = "0";
	Option.Message = "              Exit";
	MenuOptions.AddItem(Option);

	Option.Position = 14;
	Option.Key = "CTRL + B";
	Option.Message = "              Exit Menu";
	MenuOptions.AddItem(Option);

	Option.Position = 1;
	Option.Key = "1";
	Option.Message = "Wolverine";
	MenuOptions.AddItem(Option);
	
	Option.Position = 2;
	Option.Key = "2";
	Option.Message = "Hover MRLS";
	MenuOptions.AddItem(Option);

	Option.Position = 3;
	Option.Key = "3";
	Option.Message = "Titan";
	MenuOptions.AddItem(Option);

	Option.Position = 4;
	Option.Key = "4";
	Option.Message = "Attack Cycle";
	MenuOptions.AddItem(Option);

	Option.Position = 5;
	Option.Key = "5";
	Option.Message = "Buggy";
	MenuOptions.AddItem(Option);

	Option.Position = 6;
	Option.Key = "6";
	Option.Message = "Tick Tank";
	MenuOptions.AddItem(Option);



}

if (DefencesMenu)
{
	Option.Position = 0;
	Option.Key = "";
	Option.Message = "Defences";
	MenuOptions.AddItem(Option);

	Option.Position = 13;
	Option.Key = "0";
	Option.Message = "              Exit";
	MenuOptions.AddItem(Option);

	Option.Position = 14;
	Option.Key = "CTRL + B";
	Option.Message = "              Exit Menu";
	MenuOptions.AddItem(Option);

	Option.Position = 1;
	Option.Key = "1";
	Option.Message = "Guard Tower";
	MenuOptions.AddItem(Option);
	
	Option.Position = 2;
	Option.Key = "2";
	Option.Message = "Guard Tower (Nod)";
	MenuOptions.AddItem(Option);

	Option.Position = 3;
	Option.Key = "3";
	Option.Message = "Turret";
	MenuOptions.AddItem(Option);

	Option.Position = 4;
	Option.Key = "4";
	Option.Message = "Turret (GDI)";
	MenuOptions.AddItem(Option);

	Option.Position = 5;
	Option.Key = "5";
	Option.Message = "Anti-Air Tower";
	MenuOptions.AddItem(Option);

	Option.Position = 6;
	Option.Key = "6";
	Option.Message = "SAM Site";
	MenuOptions.AddItem(Option);

	Option.Position = 7;
	Option.Key = "7";
	Option.Message = "Gun Emplacement";
	MenuOptions.AddItem(Option);

	Option.Position = 8;
	Option.Key = "8";
	Option.Message = "Rocket Emplacement";
	MenuOptions.AddItem(Option);
}

if (OtherMenu)
{
	Option.Position = 0;
	Option.Key = "";
	Option.Message = "Other";
	MenuOptions.AddItem(Option);

	Option.Position = 13;
	Option.Key = "0";
	Option.Message = "              Exit";
	MenuOptions.AddItem(Option);

	Option.Position = 14;
	Option.Key = "CTRL + B";
	Option.Message = "              Exit Menu";
	MenuOptions.AddItem(Option);

	Option.Position = 1;
	Option.Key = "1";
	Option.Message = "M2 Light Tank";
	MenuOptions.AddItem(Option);
	
	Option.Position = 2;
	Option.Key = "2";
	Option.Message = "Tesla Tank";
	MenuOptions.AddItem(Option);

	Option.Position = 3;
	Option.Key = "3";
	Option.Message = "SAM Site Manual";
	MenuOptions.AddItem(Option);

	Option.Position = 4;
	Option.Key = "4";
	Option.Message = "Obelisk Gun";
	MenuOptions.AddItem(Option);

	Option.Position = 5;
	Option.Key = "5";
	Option.Message = "Super Repair Gun";
	MenuOptions.AddItem(Option);

}

if (CharTeamSelect)
{
	Option.Position = 0;
	Option.Key = "";
	Option.Message = "Select Team";
	MenuOptions.AddItem(Option);

	Option.Position = 13;
	Option.Key = "0";
	Option.Message = "              Exit";
	MenuOptions.AddItem(Option);

	Option.Position = 14;
	Option.Key = "CTRL + B";
	Option.Message = "              Exit Menu";
	MenuOptions.AddItem(Option);

	Option.Position = 1;
	Option.Key = "1";
	Option.Message = "GDI";
	MenuOptions.AddItem(Option);
	
	Option.Position = 2;
	Option.Key = "2";
	Option.Message = "Nod";
	MenuOptions.AddItem(Option);

}

if (GDICharMenu1)
{
	Option.Position = 0;
	Option.Key = "";
	Option.Message = "GDI Characters";
	MenuOptions.AddItem(Option);

	Option.Position = 12;
	Option.Key = "9";
	Option.Message = "              Next Page";
	MenuOptions.AddItem(Option);

	Option.Position = 13;
	Option.Key = "0";
	Option.Message = "              Exit";
	MenuOptions.AddItem(Option);

	Option.Position = 14;
	Option.Key = "CTRL + B";
	Option.Message = "              Exit Menu";
	MenuOptions.AddItem(Option);

	Option.Position = 1;
	Option.Key = "1";
	Option.Message = "Soldier";
	MenuOptions.AddItem(Option);
	
	Option.Position = 2;
	Option.Key = "2";
	Option.Message = "Shotgunner";
	MenuOptions.AddItem(Option);

	Option.Position = 3;
	Option.Key = "3";
	Option.Message = "Grenadier";
	MenuOptions.AddItem(Option);

	Option.Position = 4;
	Option.Key = "4";
	Option.Message = "Marksman";
	MenuOptions.AddItem(Option);

	Option.Position = 5;
	Option.Key = "5";
	Option.Message = "Engineer";
	MenuOptions.AddItem(Option);

	Option.Position = 6;
	Option.Key = "6";
	Option.Message = "Officer";
	MenuOptions.AddItem(Option);

	Option.Position = 7;
	Option.Key = "7";
	Option.Message = "Rocket Soldier";
	MenuOptions.AddItem(Option);

	Option.Position = 8;
	Option.Key = "8";
	Option.Message = "McFarland";
	MenuOptions.AddItem(Option);
}
if (GDICharMenu2)
{
	Option.Position = 0;
	Option.Key = "";
	Option.Message = "GDI Characters";
	MenuOptions.AddItem(Option);

	Option.Position = 13;
	Option.Key = "0";
	Option.Message = "              Previous Page";
	MenuOptions.AddItem(Option);

	Option.Position = 14;
	Option.Key = "CTRL + B";
	Option.Message = "              Exit Menu";
	MenuOptions.AddItem(Option);

	Option.Position = 1;
	Option.Key = "1";
	Option.Message = "Deadeye";
	MenuOptions.AddItem(Option);
	
	Option.Position = 2;
	Option.Key = "2";
	Option.Message = "Gunner";
	MenuOptions.AddItem(Option);

	Option.Position = 3;
	Option.Key = "3";
	Option.Message = "Patch";
	MenuOptions.AddItem(Option);

	Option.Position = 4;
	Option.Key = "4";
	Option.Message = "Havoc";
	MenuOptions.AddItem(Option);

	Option.Position = 5;
	Option.Key = "5";
	Option.Message = "Sydney";
	MenuOptions.AddItem(Option);

	Option.Position = 6;
	Option.Key = "6";
	Option.Message = "Mobius";
	MenuOptions.AddItem(Option);

	Option.Position = 7;
	Option.Key = "7";
	Option.Message = "Hotwire";
	MenuOptions.AddItem(Option);

	Option.Position = 8;
	Option.Key = "8";
	Option.Message = "Armoured Sydney";
	MenuOptions.AddItem(Option);
	
}

if (NodCharMenu1)
{
	Option.Position = 0;
	Option.Key = "";
	Option.Message = "Nod Characters";
	MenuOptions.AddItem(Option);

	Option.Position = 12;
	Option.Key = "9";
	Option.Message = "              Next Page";
	MenuOptions.AddItem(Option);

	Option.Position = 13;
	Option.Key = "0";
	Option.Message = "              Exit";
	MenuOptions.AddItem(Option);

	Option.Position = 14;
	Option.Key = "CTRL + B";
	Option.Message = "              Exit Menu";
	MenuOptions.AddItem(Option);

	Option.Position = 1;
	Option.Key = "1";
	Option.Message = "Soldier";
	MenuOptions.AddItem(Option);
	
	Option.Position = 2;
	Option.Key = "2";
	Option.Message = "Shotgunner";
	MenuOptions.AddItem(Option);

	Option.Position = 3;
	Option.Key = "3";
	Option.Message = "Flame Trooper";
	MenuOptions.AddItem(Option);

	Option.Position = 4;
	Option.Key = "4";
	Option.Message = "Marksman";
	MenuOptions.AddItem(Option);

	Option.Position = 5;
	Option.Key = "5";
	Option.Message = "Engineer";
	MenuOptions.AddItem(Option);

	Option.Position = 6;
	Option.Key = "6";
	Option.Message = "Officer";
	MenuOptions.AddItem(Option);

	Option.Position = 7;
	Option.Key = "7";
	Option.Message = "Rocket Soldier";
	MenuOptions.AddItem(Option);

	Option.Position = 8;
	Option.Key = "8";
	Option.Message = "Chemical Trooper";
	MenuOptions.AddItem(Option);
}
if (NodCharMenu2)
{
	Option.Position = 0;
	Option.Key = "";
	Option.Message = "Nod Characters";
	MenuOptions.AddItem(Option);

	Option.Position = 13;
	Option.Key = "0";
	Option.Message = "              Previous Page";
	MenuOptions.AddItem(Option);

	Option.Position = 14;
	Option.Key = "CTRL + B";
	Option.Message = "              Exit Menu";
	MenuOptions.AddItem(Option);

	Option.Position = 1;
	Option.Key = "1";
	Option.Message = "Black Hand Sniper";
	MenuOptions.AddItem(Option);
	
	Option.Position = 2;
	Option.Key = "2";
	Option.Message = "Stealth Black Hand";
	MenuOptions.AddItem(Option);

	Option.Position = 3;
	Option.Key = "3";
	Option.Message = "Laser Chaingunner";
	MenuOptions.AddItem(Option);

	Option.Position = 4;
	Option.Key = "4";
	Option.Message = "Sakura";
	MenuOptions.AddItem(Option);

	Option.Position = 5;
	Option.Key = "5";
	Option.Message = "Raveshaw";
	MenuOptions.AddItem(Option);

	Option.Position = 6;
	Option.Key = "6";
	Option.Message = "Mendoza";
	MenuOptions.AddItem(Option);

	Option.Position = 7;
	Option.Key = "7";
	Option.Message = "Technician";
	MenuOptions.AddItem(Option);

	Option.Position = 8;
	Option.Key = "8";
	Option.Message = "Mutant Raveshaw";
	MenuOptions.AddItem(Option);
	
}

	HudMovie.DisplayOptions(MenuOptions);
	HudMovie.HelpMenuVis(false);

}


function DoAction(string Key)
{

}

function CreateHudCompoenents()
{
	Super.CreateHudCompoenents();
	AdminHud = New class'Rx_CreativeMode_HUDC';
}

function UpdateHudCompoenents(float DeltaTime, Rx_HUD HUD)
{
	Super.UpdateHudCompoenents(DeltaTime, HUD);
	if(DrawTargetBox) AdminHud.Update(DeltaTime, HUD);
	if(Rx_Controller(PlayerOwner).Vet_Menu != none) Rx_Controller(PlayerOwner).Vet_Menu.UpdateTiles(DeltaTime, HUD);
}

function DrawHudCompoenents()
{
	Super.DrawHudCompoenents();	
	if(DrawTargetBox && bDrawFPSMenu) AdminHud.Draw();
	if(Rx_Controller(PlayerOwner).Vet_Menu != none) Rx_Controller(PlayerOwner).Vet_Menu.DrawTiles(self);
}

DefaultProperties
{
	DefaultTargettingRangex = 10000
	bDrawFPSMenu = true
}
