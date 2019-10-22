class CM_GFxHud extends GFxMoviePlayer;

var GFxClikWidget VehScrollList;
var GFxClikWidget WepScrollList;
var GFxClikWidget InfScrollList;
var GFxClikWidget DefScrollList;
var GFxClikWidget GodButton;
var GFxClikWidget FlyButton;
var GFxClikWidget WalkButton;
var GFxClikWidget PromoteButton;
var GFxClikWidget LockHPButton;
var GFxClikWidget KillDefsButton;
var GFxClikWidget RestoreBuildsButton;
var GFxClikWidget ClearSpawnsButton;

var GameViewportClient VPC;
var CM_Controller PlayerOwner;
var CM_HUD CMHUD;

function Init(optional LocalPlayer LocPlay)
{
	//Start();
	Advance(0.f);

	PlayerOwner = CM_Controller(GetPC());
	CMHUD = CM_HUD(PlayerOwner.myHUD);
}

function TickHUD()
{
	if (!bMovieIsOpen)
	{
		return;
	}
}

event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if (InputEvent == IE_Pressed && ButtonName == 'Escape')
		SetVisible(false);

	if (InputEvent == IE_Pressed && ButtonName == 'B')
		SetVisible(false);

	return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
}

function SetVisible(bool NewVis)
{
	if (NewVis)
	{
		CMHUD.HudMovie.SideMenuVis(false);
		Start();
	}
	else
	{
		Close(false);
		VehScrollList.SetInt("selectedIndex", -1);
		WepScrollList.SetInt("selectedIndex", -1);
		InfScrollList.SetInt("selectedIndex", -1);
		DefScrollList.SetInt("selectedIndex", -1);
	}
}

function OnVehScrollListChange(GFxClikWidget.EventData ev) 
{
	local class<Rx_Vehicle> VehicleToSpawn;
	local name Package;

	if (VehScrollList.GetInt("selectedIndex") == -1) return;

	if (PlayerOwner != None)
	{
		VehicleToSpawn = CMHUD.Vehicles[VehScrollList.GetInt("selectedIndex")];
		Package = CMHUD.VehiclePackages[VehScrollList.GetInt("selectedIndex")];

		PlayerOwner.TogglePlaceVehicle(Package$"."$VehicleToSpawn.name);
		OnCommandRun();
	}
}

function OnInfScrollListChange(GFxClikWidget.EventData ev)
{
	local class<Rx_FamilyInfo> InfToGive;
	local name Package;

	if (InfScrollList.GetInt("selectedIndex") == -1) return;

	if (PlayerOwner != None)
	{
		InfToGive = CMHUD.Infantry[InfScrollList.GetInt("selectedIndex")];
		Package = CMHUD.InfantryPackages[InfScrollList.GetInt("selectedIndex")];

		PlayerOwner.GiveChar(Package$"."$InfToGive.name);
		OnCommandRun();
	}
}

function OnWepScrollListChange(GFxClikWidget.EventData ev) 
{
	local class<Rx_Weapon> WepToGive;
	local name Package;

	if (WepScrollList.GetInt("selectedIndex") == -1) return;

	if (PlayerOwner != None)
	{
		WepToGive = CMHUD.Weapons[WepScrollList.GetInt("selectedIndex")];
		Package = CMHUD.WeaponPackages[WepScrollList.GetInt("selectedIndex")];

		PlayerOwner.Gimme(Package$"."$WepToGive.name);
		OnCommandRun();
	}
}

function OnDefScrollListChange(GFxClikWidget.EventData ev) 
{
	if (PlayerOwner != None)
	{
		//PlayerOwner.TogglePlaceActor(CMHUD.Defenses[DefScrollList.GetInt("selectedIndex")]);
	}
}

function OnGodButtonPress(GFxClikWidget.EventData ev)
{
	if (PlayerOwner != None)
	{
		PlayerOwner.GiveGod();
		OnCommandRun();
	}
}

function OnFlyButtonPress(GFxClikWidget.EventData ev)
{
	if (PlayerOwner != None)
	{
		PlayerOwner.Fly();
		OnCommandRun();
	}
}

function OnWalkButtonPress(GFxClikWidget.EventData ev)
{
	if (PlayerOwner != None)
	{
		PlayerOwner.Walk();
		OnCommandRun();
	}
}

function OnPromoteButtonPress(GFxClikWidget.EventData ev)
{
	if (PlayerOwner != None)
	{
		PlayerOwner.GivePromo();
		OnCommandRun();
	}
}

function OnLockHPButtonPress(GFxClikWidget.EventData ev)
{
	if (PlayerOwner != None)
	{
		PlayerOwner.LockHealth();
		OnCommandRun();
	}
}

function OnKillDefsButtonPress(GFxClikWidget.EventData ev)
{
	if (PlayerOwner != None)
	{
		PlayerOwner.DestroyDefences();
		OnCommandRun();
	}
}

function OnClearSpawnsButtonPress(GFxClikWidget.EventData ev)
{
	if (PlayerOwner != None)
	{
		PlayerOwner.SandboxKillOwned();
		OnCommandRun();
	}
}

function OnRestoreBuildsButtonPress(GFxClikWidget.EventData ev)
{
	if (PlayerOwner != None)
	{
		PlayerOwner.RestoreBuildings();
		OnCommandRun();
	}
}

function OnCommandRun()
{
	//if (PlayerOwner.CanExecuteCommands())
	//	SetVisible(false);
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local bool bWasHandled;

	`log(">> CM_GFxHud::WidgetInitialized"@`showvar(WidgetName));

	bWasHandled = false;

	switch (WidgetName)
	{
		case 'VehScrollList':
			if (VehScrollList == none || VehScrollList != Widget) {
				VehScrollList = GFxClikWidget(Widget);
			}
			SetUpDataProvider(VehScrollList);
			VehScrollList.AddEventListener('CLIK_listIndexChange', OnVehScrollListChange);
			bWasHandled = true;
		break;

		case 'WepScrollList':
			if (WepScrollList == none || WepScrollList != Widget) {
				WepScrollList = GFxClikWidget(Widget);
			}
			SetUpDataProvider(WepScrollList);
			WepScrollList.AddEventListener('CLIK_listIndexChange', OnWepScrollListChange);
			bWasHandled = true;
		break;

		case 'InfScrollList':
			if (InfScrollList == none || InfScrollList != Widget) {
				InfScrollList = GFxClikWidget(Widget);
			}
			SetUpDataProvider(InfScrollList);
			InfScrollList.AddEventListener('CLIK_listIndexChange', OnInfScrollListChange);
			bWasHandled = true;
		break;

		case 'DefScrollList':
			if (DefScrollList == none || DefScrollList != Widget) {
				DefScrollList = GFxClikWidget(Widget);
			}
			SetUpDataProvider(DefScrollList);
			DefScrollList.AddEventListener('CLIK_listIndexChange', OnDefScrollListChange);
			bWasHandled = true;
		break;

		case 'GodButton':
			if (GodButton == none || GodButton != Widget) {
				GodButton = GFxClikWidget(Widget);
			}
			GodButton.AddEventListener('CLIK_buttonClick', OnGodButtonPress);
			bWasHandled = true;
		break;

		case 'FlyButton':
			if (FlyButton == none || FlyButton != Widget) {
				FlyButton = GFxClikWidget(Widget);
			}
			FlyButton.AddEventListener('CLIK_buttonClick', OnFlyButtonPress);
			bWasHandled = true;
		break;

		case 'WalkButton':
			if (WalkButton == none || WalkButton != Widget) {
				WalkButton = GFxClikWidget(Widget);
			}
			WalkButton.AddEventListener('CLIK_buttonClick', OnWalkButtonPress);
			bWasHandled = true;
		break;

		case 'PromoteButton':
			if (PromoteButton == none || PromoteButton != Widget) {
				PromoteButton = GFxClikWidget(Widget);
			}
			PromoteButton.AddEventListener('CLIK_buttonClick', OnPromoteButtonPress);
			bWasHandled = true;
		break;
		case 'LockHPButton':
			if (LockHPButton == none || LockHPButton != Widget) {
				LockHPButton = GFxClikWidget(Widget);
			}
			LockHPButton.AddEventListener('CLIK_buttonClick', OnLockHPButtonPress);
			bWasHandled = true;
		break;

		case 'KillDefsButton':
			if (KillDefsButton == none || KillDefsButton != Widget) {
				KillDefsButton = GFxClikWidget(Widget);
			}
			KillDefsButton.AddEventListener('CLIK_buttonClick', OnKillDefsButtonPress);
			bWasHandled = true;
		break;

		case 'ClearSpawnsButton':
			if (ClearSpawnsButton == none || ClearSpawnsButton != Widget) {
				ClearSpawnsButton = GFxClikWidget(Widget);
			}
			ClearSpawnsButton.AddEventListener('CLIK_buttonClick', OnClearSpawnsButtonPress);
			bWasHandled = true;
		break;
		case 'RestoreBuildsButton':
			if (RestoreBuildsButton == none || RestoreBuildsButton != Widget) {
				RestoreBuildsButton = GFxClikWidget(Widget);
			}
			RestoreBuildsButton.AddEventListener('CLIK_buttonClick', OnRestoreBuildsButtonPress);
			bWasHandled = true;
		break;
	}

	return bWasHandled;
}

function RepopMenu()
{
	SetUpDataProvider(WepScrollList);
}

function SetUpDataProvider(GFxObject Widget)
{
	local int i;
	local GFxObject DataProvider;
	local GFxObject TempObj;
	local class<Rx_Vehicle> V;
	local class<Rx_Weapon> W;
	local class<Rx_FamilyInfo> F;
	local class<Rx_Defence> D;

	DataProvider = CreateObject("scaleform.clik.data.DataProvider");

	switch (Widget) 
	{
		case (VehScrollList):
			if (CMHUD == None)
			{
				TempObj = CreateObject("Object");
				TempObj.SetString("mapName", "");
				for (i=0; i<6; i++)
					DataProvider.SetElementObject(i, TempObj);
			}
			else
			{
				ForEach CMHUD.Vehicles(V, i)
				{
					TempObj = CreateObject("Object");
					TempObj.SetString("mapName", ""$V);

					DataProvider.SetElementObject(i, TempObj);
				}
			}
			VehScrollList.Setint("selectedIndex", -1);
		break;

		case (WepScrollList):
			if (CMHUD == None)
			{
				TempObj = CreateObject("Object");
				TempObj.SetString("mapName", "");
				for (i=0; i<6; i++)
					DataProvider.SetElementObject(i, TempObj);
			}
			else
			{
				ForEach CMHUD.Weapons(W, i)
				{
					TempObj = CreateObject("Object");
					TempObj.SetString("mapName", ""$W);

					DataProvider.SetElementObject(i, TempObj);
				}
			}
			WepScrollList.Setint("selectedIndex", -1);
		break;

		case (InfScrollList):
			if (CMHUD == None)
			{
				TempObj = CreateObject("Object");
				TempObj.SetString("mapName", "");
				for (i=0; i<6; i++)
					DataProvider.SetElementObject(i, TempObj);
			}
			else
			{
				ForEach CMHUD.Infantry(F, i)
				{
					TempObj = CreateObject("Object");
					TempObj.SetString("mapName", ""$F);

					DataProvider.SetElementObject(i, TempObj);
				}
			}
			InfScrollList.Setint("selectedIndex", -1);
		break;

		case (DefScrollList):
			if (CMHUD == None)
			{
				TempObj = CreateObject("Object");
				TempObj.SetString("mapName", "");
				for (i=0; i<6; i++)
					DataProvider.SetElementObject(i, TempObj);
			}
			else
			{
				ForEach CMHUD.Defenses(D, i)
				{
					TempObj = CreateObject("Object");
					TempObj.SetString("mapName", ""$D);

					DataProvider.SetElementObject(i, TempObj);
				}
			}
			DefScrollList.Setint("selectedIndex", -1);
		break;
	}

	Widget.SetObject("dataProvider", DataProvider);
}

DefaultProperties
{
	//SoundThemes(0)=(ThemeName=default,Theme=UISoundTheme'renxfrontend.Sounds.SoundTheme')
	bDisplayWithHudOff = false
	MovieInfo = SwfMovie'CMHud.CMHud'
	TimingMode = TM_Real
	Priority = 1000
	bCaptureInput = true
	bIgnoreMouseInput = false
	bShowHardwareMouseCursor = true

	WidgetBindings.Add((WidgetName="VehScrollList",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="InfScrollList",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="WepScrollList",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="DefScrollList",WidgetClass=class'GFxClikWidget')))
	WidgetBindings.Add((WidgetName="GodButton",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="FlyButton",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="WalkButton",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="PromoteButton",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="LockHPButton",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="KillDefsButton",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="ClearSpawnsButton",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="RestoreBuildsButton",WidgetClass=class'GFxClikWidget'))
}
