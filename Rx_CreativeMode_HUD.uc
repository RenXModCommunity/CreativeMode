class Rx_CreativeMode_HUD extends Rx_HUD;

var int DefaultTargettingRangex, pageNum;
var privatewrite Rx_CreativeMode_HUDC AdminHud;
var privatewrite bool OpenMenu;
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

	if (!OpenMenu) return;

	PC = Rx_CreativeMode_Controller(PlayerOwner);

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
		break;
	}
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
	} 
	else
	{
		Option.Position = 1;
		Option.Key = "";
		Option.Message = "You're not admin :(";
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