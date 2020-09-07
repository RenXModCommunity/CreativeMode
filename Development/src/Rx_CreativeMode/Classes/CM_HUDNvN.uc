class CM_HUDNvN extends S_HUD;

//Identical to CM_HUD besides NvN specific classes

var int DefaultTargettingRangex, pageNum;
var privatewrite CM_HUDC AdminHud;
var bool OpenMenu;

var bool bDrawFPSMenu;
var privatewrite array<Object> CurrentList;

var privatewrite array<class<Rx_Vehicle> > Vehicles;
var privatewrite array<name> VehiclePackages;

var privatewrite array<class<Rx_Weapon> > Weapons;
var privatewrite array<name> WeaponPackages;

var privatewrite array<class<Rx_FamilyInfo> > Infantry;
var privatewrite array<name> InfantryPackages;

var privatewrite array<class<Rx_Defence> > Defenses;
var privatewrite array<name> DefensePackages;

var const array<class<Rx_Vehicle> > OmittedVehicles;
var const array<class<Rx_Weapon> > OmittedWeapons;
var const array<class<Rx_FamilyInfo> > OmittedInfantry;
var const array<class<Rx_Defence> > OmittedDefenses;

var privatewrite array<string> AllClasses;

var CM_GFxHudNvN CMMovie;

simulated event PostBeginPlay()
{
	local string Result;
	local string s;
	local int i;

	super.PostBeginPlay();

	Result = WorldInfo.ConsoleCommand("GETALL Class NetIndex", False);
    ParseStringIntoArray(Result, AllClasses, ") Class ", False);

    AllClasses.Remove(0, 1);

    ForEach AllClasses(s, i)
    {
        AllClasses[i] = Left(AllClasses[i], InStr(AllClasses[i], ".NetIndex ="));
    }

    PopulateVehicleMenu();

    PopulateWeaponMenu();

    PopulateInfantryMenu();

    PopulateDefenseMenu();

    CMMovie = new class'CM_GFxHudNvN';
    CMMovie.Init();
    CMMovie.CMHUD = self;
}

event PostRender()
{
	Super.PostRender();

	if (CMMovie != None && OpenMenu)
		CMMovie.TickHud();
}

function PopulateVehicleMenu()
{
	local array<string> Pieces;
    local string s;
    local int i;
    local class<Rx_Vehicle> NewClass;
    local class<Rx_Vehicle> V;

    Pieces = AllClasses;

    ForEach Pieces(s, i)
    {
        NewClass = class<Rx_Vehicle>(DynamicLoadObject(s, class'Class'));

        if (NewClass == None)
        	continue;

        VehiclePackages.AddItem(NewClass.GetPackageName());

        if (!ClassIsChildOf(NewClass, class'Renx_Game.Rx_Defence'))
        Vehicles.AddItem(NewClass);
        `log(">> CM_Hud: Added"@NewClass@"to the Vehicles list");
    }

    ForEach OmittedVehicles(V, i)
    {
    	i = Vehicles.Find(V);

    	if (i != -1)
    		Vehicles.Remove(i, 1);
    		VehiclePackages.Remove(i, 1);
    }
}

function PopulateWeaponMenu()
{
    local array<string> Pieces;
    local string s;
    local int i;
    local class<Rx_Weapon> NewClass;
    local class<Rx_Weapon> W;

    Pieces = AllClasses;
    Weapons.Length = 0;

	ForEach Pieces(s, i)
    {
        NewClass = class<Rx_Weapon>(DynamicLoadObject(s, class'Class'));

        if (NewClass == None)
        	continue;

        WeaponPackages.AddItem(NewClass.GetPackageName());

        //`log(NewClass);

        Weapons.AddItem(NewClass);
        `log(">> CM_Hud: Added"@NewClass@"to the Weapons list");
    }

    ForEach OmittedWeapons(W, i)
    {
    	i = Weapons.Find(W);

    	if (i != -1)
    		Weapons.Remove(i, 1);
    		WeaponPackages.Remove(i, 1);
    }
}

function PopulateInfantryMenu()
{
    local array<string> Pieces;
    local string s;
    local int i;
    local class<Rx_FamilyInfo> NewClass;
    local class<Rx_FamilyInfo> F;

    Pieces = AllClasses;

	ForEach Pieces(s, i)
    {
        NewClass = class<Rx_FamilyInfo>(DynamicLoadObject(s, class'Class'));

        if (NewClass == None)
        	continue;

        InfantryPackages.AddItem(NewClass.GetPackageName());

        Infantry.AddItem(NewClass);
		`log(">> CM_Hud: Added"@NewClass@"to the Infatry list");
    }

    ForEach OmittedInfantry(F, i)
    {
    	i = Infantry.Find(F);

    	if (i != -1)
    		Infantry.Remove(i, 1);
    		InfantryPackages.Remove(i, 1);
    }
}

function PopulateDefenseMenu()
{
    local array<string> Pieces;
    local string s;
    local int i;
    local class<Rx_Defence> NewClass;
    local class<Rx_Defence> D;

    Pieces = AllClasses;

	ForEach Pieces(s, i)
    {
        NewClass = class<Rx_Defence>(DynamicLoadObject(s, class'Class'));

        if (NewClass == None)
        	continue;

        DefensePackages.AddItem(NewClass.GetPackageName());

        Defenses.AddItem(NewClass);
        `log(">> CM_Hud: Added"@NewClass@"to the Defenses list");
    }

    ForEach OmittedDefenses(D, i)
    {
    	i = Defenses.Find(D);

    	if (i != -1)
    		Defenses.Remove(i, 1);
    		DefensePackages.Remove(i, 1);
    }
}

function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType, optional float LifeTime = 60)
{
	local string cName, fMsg, rMsg;
	local int MessageType; // 0 = global, 1 = team, 2 = EVA, 3 = Radio

	if (Len(Msg) == 0)
		return;
	
	if ( bMessageBeep )
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
	
	if (MsgType == 'Say') 
	{
		if (PRI == None)
			fMsg = "<font color='" $HostColor$"'>" $cName$"</font>: <font color='#FFFFFF'>"$CleanHTMLMessage(Msg)$"</font>";
		else if (PRI.Team.GetTeamNum() == TEAM_GDI)
			fMsg = "<font color='" $GDIColor $"'>" $cName $"</font>: " $ CleanHTMLMessage(Msg);
		else if (PRI.Team.GetTeamNum() == TEAM_NOD)
			fMsg = "<font color='" $NodColor $"'>" $cName $"</font>: " $ CleanHTMLMessage(Msg);
		PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = cName $": "$ Msg;
		MessageType = 0;
	}
	else if (MsgType == 'SSay') 
	{
		if (PRI == None)
			fMsg = "<font color='" $"#C67EF9"$"'>" $"Creative"$"</font>: <font color='#FFFFFF'>"$CleanHTMLMessage(Msg)$"</font>";
		else if (PRI.Team.GetTeamNum() == TEAM_GDI)
			fMsg = "<font color='" $GDIColor $"'>" $cName $"</font>: " $ CleanHTMLMessage(Msg);
		else if (PRI.Team.GetTeamNum() == TEAM_NOD)
			fMsg = "<font color='" $NodColor $"'>" $cName $"</font>: " $ CleanHTMLMessage(Msg);
		PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = cName $": "$ Msg;
		MessageType = 0;
	}
	else if (MsgType == 'TeamSay') {
		if (PRI.GetTeamNum() == TEAM_GDI)
		{
			fMsg = "<font color='" $GDIColor $"'>" $ cName $": "$ CleanHTMLMessage(Msg) $"</font>";
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
			MessageType = 1;
		}
		else if (PRI.GetTeamNum() == TEAM_NOD)
		{
			fMsg = "<font color='" $NodColor $"'>" $ cName $": "$ CleanHTMLMessage(Msg) $"</font>";
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
			MessageType = 1;
		}
	}
	else if (MsgType == 'Radio') {
		Msg = ParseRadioMessage(Msg);

		if (Rx_PRI(PRI).bGetIsCommander()) {
			fMsg = "<font color='" $CommandTextColor $"'>" $ "[Commander]" $ cName $": "$ Msg $"</font>"; 
		}
		else {
			fMsg = "<font color='" $RadioColor $"'>" $ cName $": "$ Msg $"</font>"; 
		}

		fMsg = HighlightStructureNames(fMsg); 
		//PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = cName $ ": "$ Msg;
		MessageType = 3;
	}
	else if (MsgType == 'Commander') 
		{
			if (Left(Caps(msg), 2) == "/C") 
			{
				msg = Right(msg, Len(msg)-2);
				Rx_Controller(PlayerOwner).CTextMessage(msg,'Pink', 120.0,,true);
			}
			else if (Left(Caps(msg), 2) == "/R") 
			{
				msg = Right(msg, Len(msg)-2);
				Rx_Controller(PlayerOwner).CTextMessage(msg,'Pink', 360.0,,true);
			}
			fMsg = "<b><font color='" $CommandTextColor $"'>" $ "[Commander]"$ cName $": "$ CleanHTMLMessage(Msg) $"</font></b>";
			//PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
			MessageType = 1;
		}
	else if (MsgType == 'System') {
		if(InStr(Msg, "entered the game") >= 0)
			return;
		fMsg = Msg;
		PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = Msg;
		MessageType = 0;
	}
	else if (MsgType == 'PM') {
		if (PRI != None)
			fMsg = "<font color='"$PrivateFromColor$"'>Private from "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		else
			fMsg = "<font color='"$HostColor$"'>Private from "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		PrivateChatMessageLog $= "\n" $ fMsg;
		rMsg = "Private from "$ cName $": "$ Msg;
		MessageType = 0;
	}
	else if (MsgType == 'PM_Loopback') {
		fMsg = "<font color='"$PrivateToColor$"'>Private to "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		PrivateChatMessageLog $= "\n" $ fMsg;
		rMsg = "Private to "$ cName $": "$ Msg;
		MessageType = 0;
	}
	else if (MsgType == 'CTEXT')
		MessageType = 4;
	else if (MsgType == 'AdminMsg' || MsgType == 'PM_AdminMsg') {
		MessageType = 5;
		// TODO: This should go through to the HUD somewhere
		fMsg = "<font color='#FFFFFF' size='20'>" $ Msg $ "</font>";
	}
	else if (MsgType == 'AdminWarn' || MsgType == 'PM_AdminWarn') {
		MessageType = 5;
		fMsg = "<font color='#E67451' size='25'>You received a Warning from an Admin</font><br><br><font color='#E67451' size='20'>" $ Msg $ "</font>";
	}
	else
		MessageType = 2;

	// Add to currently active GUI | Edit by Yosh : Don't bother spamming the non-HUD chat logs with radio messages... it's pretty pointless for them to be there. 

	if(HudMovie != none && HudMovie.bMovieIsOpen)
	{
		if (MessageType == 0) {
			HudMovie.AddChatMessage(fMsg, rMsg);
		}
		else if (MessageType == 1) {
			HudMovie.AddChatMessage(fMsg, rMsg);
		}
		else if (MessageType == 2) {
			HudMovie.AddEVAMessage(Msg);
		}
		else if (MessageType == 3) {
			HudMovie.AddRadioMessage(fMsg, rMsg);
		}
		else if (MessageType == 4) {
			HudMovie.AddCTextMessage(Msg,LifeTime);	
		}
		else if (MessageType == 5) {
			HudMovie.PushAdminMessage(fMsg);
		}
	}	
	else
	{
		if(MsgType == 'System' 
			|| MsgType == 'CTEXT' 
			|| MsgType == 'AdminWarn' 
			|| MsgType == 'Radio'
			|| MessageType == 2) // these types are invalid and should not be registered in scoreboard/pause menu
			return;

		if (Scoreboard != none && Scoreboard.bMovieIsOpen) 
		{
			if (PlayerOwner.WorldInfo.GRI.bMatchIsOver) 
			{
				Scoreboard.AddChatMessage(fMsg, rMsg);
			}
		}		
		if (RxPauseMenuMovie != none && RxPauseMenuMovie.bMovieIsOpen) {
			if (RxPauseMenuMovie.ChatView != none) 
			{
				RxPauseMenuMovie.ChatView.AddChatMessage(fMsg, rMsg, MsgType=='PM' || MsgType=='PM_Loopback');
			}
			if(Rx_GRI(PlayerOwner.WorldInfo.GRI).bMatchIsOver)
			{
				LastEndScoreboardChats $= fMsg $ "\n";
			}
		}

	}
}


function ToggleMenu()
{
	OpenMenu = !OpenMenu;
	if (CMMovie != None)
		CMMovie.SetVisible(OpenMenu);
}

function DoAction(string Key)
{

}

function CreateHudCompoenents()
{
	Super.CreateHudCompoenents();
	AdminHud = New class'CM_HUDC';
}

function UpdateHudCompoenents(float DeltaTime, Rx_HUD HUD)
{
	Super.UpdateHudCompoenents(DeltaTime, HUD);
	if (DrawTargetBox) AdminHud.Update(DeltaTime, HUD);
	if (Rx_Controller(PlayerOwner).Vet_Menu != none) Rx_Controller(PlayerOwner).Vet_Menu.UpdateTiles(DeltaTime, HUD);
}

function DrawHudCompoenents()
{
	Super.DrawHudCompoenents();	
	if (DrawTargetBox && bDrawFPSMenu) AdminHud.Draw();
	if (Rx_Controller(PlayerOwner).Vet_Menu != none) Rx_Controller(PlayerOwner).Vet_Menu.DrawTiles(self);
}

DefaultProperties
{
	DefaultTargettingRangex = 10000
	bDrawFPSMenu = true

	OmittedWeapons.Add(class'Rx_Weapon')
	OmittedWeapons.Add(class'Rx_Weapon_Airstrike')
	OmittedWeapons.Add(class'Rx_Weapon_AutoRifle')
	OmittedWeapons.Add(class'Rx_Weapon_Beacon')
	OmittedWeapons.Add(class'Rx_Weapon_Chaingun')
	OmittedWeapons.Add(class'Rx_Weapon_Charged')
	OmittedWeapons.Add(class'Rx_Weapon_Deployable')
	OmittedWeapons.Add(class'Rx_Weapon_MarksmanRifle')
	OmittedWeapons.Add(class'Rx_Weapon_RechargeableGrenade')
	OmittedWeapons.Add(class'Rx_Weapon_Reloadable')
	OmittedWeapons.Add(class'Rx_Weapon_Scoped')
	OmittedWeapons.Add(class'Rx_Weapon_SMG')
	OmittedWeapons.Add(class'Rx_Weapon_SMG_Silenced')
	OmittedWeapons.Add(class'Rx_Weapon_SniperRifle')
	OmittedWeapons.Add(class'Rx_Weapon_VoltAutoRifle')
	OmittedWeapons.Add(class'Rx_BeamWeapon')
	OmittedWeapons.Add(class'Rx_WeaponAbility')
	OmittedWeapons.Add(class'Rx_WeaponAbility_Attached')
	OmittedWeapons.Add(class'Rx_WeaponAbility_TiberiumGrenade')
	OmittedWeapons.Add(class'Rx_WeaponAbility_TacRifleGrenade')

	OmittedVehicles.Add(class'Rx_Vehicle')
	OmittedVehicles.Add(class'Rx_Vehicle_Harvester')
	OmittedVehicles.Add(class'Rx_Vehicle_Harvester_GDI')
	OmittedVehicles.Add(class'Rx_Vehicle_Harvester_Nod')
	OmittedVehicles.Add(class'Rx_Vehicle_Treaded')
	OmittedVehicles.Add(class'Rx_Vehicle_Air')
	OmittedVehicles.Add(class'Rx_Defence')
	OmittedVehicles.Add(class'Rx_Defence_Emplacement')
	OmittedVehicles.Add(class'Rx_Vehicle_Walker')
	OmittedVehicles.Add(class'Rx_Vehicle_Air_Jet')
	OmittedVehicles.Add(class'Rx_Vehicle_Chinook')
	OmittedVehicles.Add(class'Rx_Vehicle_Deployable')

	OmittedInfantry.Add(class'Rx_FamilyInfo')
	OmittedInfantry.Add(class'Rx_FamilyInfo_GDI')
	OmittedInfantry.Add(class'Rx_FamilyInfo_Nod')

	OmittedDefenses.Add(class'Rx_Defence')
}
