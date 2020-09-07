class CM_ControllerNvN extends S_Controller
config(CreativeMode);

//Identical to CM_Controller besides NvN specific classes

var config bool PlayersCanSpawn;

var config float SpawnCooldown;

var privatewrite array<Actor> SpawnedActors;

var privatewrite bool SpawnDisabled;

var privatewrite CM_PlaceVehicle PActor;

// Helper & misc. functions

event PlayerTick(float DeltaTime)
{
	local vector ViewPoint;
	local rotator desiredRot;

	super.PlayerTick(DeltaTime);

	// Find where we are looking and move the PActor with it.
	ViewPoint = GetHUDAim();
	ViewPoint.Z += 150;

	// Always set the PActor to 0,0,0 rotation, so it will always be level with a flat surface.
	desiredRot.Roll = 0;
	desiredRot.Yaw = 0;
	desiredRot.Pitch = 0;

	if (PActor != None)
	{
		PActor.SetLocation(ViewPoint);
		PActor.SetRotation(desiredRot);
	}
}

function AddToKeyString(coerce string KeyInput)
{
	Super.AddToKeyString(KeyInput);

	if (KeyInput ~= "B")
	{
		CM_HUDNvN(myHUD).ToggleMenu();
	}
}

function Rx_PRI FindPlayerPRI(optional string PlayerName)
{
	local Rx_PRI PlayerPRI;
	local string errorMessage;

	if (Len(PlayerName) == 0)
	{
		return Rx_PRI(PlayerReplicationInfo);
	}

	PlayerPRI = ParsePlayer(PlayerName, errorMessage);
	
	if (PlayerPRI == None)
   	{
   		CTextMessage(errorMessage, 'Red');
   		return None;
   	}
}

function AccessDenied()
{
	CTextMessage("Access denied", 'Red');
}

function TooRecent()
{
	CTextMessage("Your last command was too recent", 'Red');
}

function ResetSpawnTimer()
{
	SpawnDisabled = false;
}

function bool CanExecuteCommands()
{
	if (`WorldInfoObject.NetMode == NM_Standalone)
		return true;

	return PlayerReplicationInfo.bAdmin;
}

exec function ToggleFPS()
{
	CM_HUDNvN(myHUD).bDrawFPSMenu = !CM_HUDNvN(myHUD).bDrawFPSMenu;
}

exec function RepopMenu()
{
	CM_HUDNvN(MyHUD).PopulateWeaponMenu();
	CM_HUDNvN(MyHUD).CMMovie.RepopMenu();

	S();
}

reliable server function S()
{
	WorldInfo.ConsoleCommand("GETALL Class NetIndex", true);
}

// Weapon Commands

exec function Gimme(coerce string Weap)
{
	ServerGimme(Weap);
}

// Spawn Commands

exec function SandboxSpawn(string ClassName) 
{ 
	ServerSandboxSpawn(ClassName);
}

exec function SandboxKillAll(optional string ClassName)
{
	ServerSandboxKillAll(ClassName); 
} 

exec function SandboxKillOwned(optional string ClassName)
{
	ServerSandboxKillOwned(ClassName); 
	CTextMessage("Removed all your spawns", 'Green');
} 

exec function DestroyThis() 
{ 
	ClientDestroyThis();
}

exec function DestroyAll(string ClassName) 
{ 
	ServerDestroyAll(ClassName);
}

exec function ReplaceThis(string NewClass) 
{ 
	ClientReplace(NewClass);
}

exec function ReplaceAll(string ClassName, string NewClass) 
{ 
	ServerReplaceAll(ClassName, NewClass);
}

// Money Commands

exec function GiveCreds(optional string PlayerName)
{
	ServerGiveCreds(FindPlayerPRI(PlayerName));
}

// VP Commands

exec function GivePromo(optional string PlayerName)
{
	local string errorMessage;
	local Rx_PRI PlayerPRI;

	if (Len(PlayerName) > 0)
	{
		PlayerPRI = ParsePlayer(PlayerName, errorMessage);
	
		if (PlayerPRI == None)
   		{
   		    CTextMessage(errorMessage, 'Red');
   		    return;
   		}

   		ServerGivePromo(PlayerPRI);
	}
	else 
	{
		ServerGivePromo(Rx_PRI(PlayerReplicationInfo));
	}
}

// Building Commands

exec function LockHealth()
{
	ServerLockHealth();
}

// Character Commands

state PlayerFlying
{
	ignores SeePlayer, HearNoise, Bump;
	
		function PlayerMove(float DeltaTime)
		{
			local vector X,Y,Z;

			if (Pawn.AirSpeed != 1000) Pawn.AirSpeed = 1000;
	
			GetAxes(Rotation,X,Y,Z);
	
			Pawn.Acceleration = PlayerInput.aForward*X + PlayerInput.aStrafe*Y + PlayerInput.aUp*vect(0,0,1);;
			Pawn.Acceleration = (Pawn.AccelRate + 2500) * Normal(Pawn.Acceleration);
	
			if (bCheatFlying && (Pawn.Acceleration == vect(0,0,0)))
				Pawn.Velocity = vect(0,0,0);
			// Update rotation.
			UpdateRotation(DeltaTime);
	
			if (Role < ROLE_Authority) // then save this move and replicate it
				ReplicateMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
			else
				ProcessMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
		}
	
		event BeginState(Name PreviousStateName)
		{
			Pawn.SetPhysics(PHYS_Flying);
			Pawn.AirSpeed = 1000;
		}
}

exec function GiveChar(coerce string Character)
{
	ServerGiveChar(Character);
}

exec function GiveRefill(optional string PlayerName)
{
	local string errorMessage;
	local Rx_PRI PlayerPRI;

	if (Len(PlayerName) > 0)
	{
		PlayerPRI = ParsePlayer(PlayerName, errorMessage);
	
		if (PlayerPRI == None)
   		{
   		    CTextMessage(errorMessage, 'Red');
   		    return;
   		}

   		ServerGiveRefill(PlayerPRI);
	}
	else 
		ServerGiveRefill(Rx_PRI(PlayerReplicationInfo));
}

exec function Fly(optional string PlayerName)
{
	local string errorMessage;
	local Rx_PRI PlayerPRI;

	if (Len(PlayerName) > 0)
	{
		PlayerPRI = ParsePlayer(PlayerName, errorMessage);
	
		if (PlayerPRI == None)
   		{
   		    CTextMessage(errorMessage, 'Red');
   		    return;
   		}

   		ServerFly(PlayerPRI);
	}
	else 
	{
		ServerFly(Rx_PRI(PlayerReplicationInfo));
	}
}

exec function Walk(optional string PlayerName)
{
	local string errorMessage;
	local Rx_PRI PlayerPRI;

	if (Len(PlayerName) > 0)
	{
		PlayerPRI = ParsePlayer(PlayerName, errorMessage);
	
		if (PlayerPRI == None)
   		{
   		    CTextMessage(errorMessage, 'Red');
   		    return;
   		}

   		ServerWalk(PlayerPRI);
	}
	else 
	{
		ServerWalk(Rx_PRI(PlayerReplicationInfo));
	}
}

exec function GiveGod(optional string PlayerName)
{
	local string errorMessage;
	local Rx_PRI PlayerPRI;

	if (Len(PlayerName) > 0)
	{
		PlayerPRI = ParsePlayer(PlayerName, errorMessage);
	
		if (PlayerPRI == None)
   		{
   		    CTextMessage(errorMessage, 'Red');
   		    return;
   		}

   		ServerGiveGod(PlayerPRI);
	}
	else 
		ServerGiveGod(Rx_PRI(PlayerReplicationInfo));
}

exec function DestroyDefences()
{
   	ServerDestroyDefences();
}

exec function RestoreBuildings()
{
   	ServerRestoreBuildings();
}

exec function TogglePlayerSpawns()
{
   	ServerTogglePlayerSpawns();
}

exec function InfiniteAmmo()
{
	ClientInfiniteAmmo();
}

exec function TogglePlaceVehicle(coerce string InVehicle)
{
	local class<Rx_Vehicle> VehicleToPlace;

	VehicleToPlace = class<Rx_Vehicle>(DynamicLoadObject(InVehicle, class'Class'));

	if (VehicleToPlace == None)
		return;

	if (PActor == None)
	{
		// Init our PActor, set the mesh and materials.
		PActor = spawn(class'CM_PlaceVehicle', self);
		PActor.SetVehicle(VehicleToPlace);
		PActor.SetMaterials();
	}
	else
	{
		// PBActor not needed anymore, destroy, set to none and clear vars.
		PActor.Destroy(); 
		PActor = none;
	}
}

exec function AttemptSpawn(optional bool ExitSpawnMode = false)
{
	ServerAttemptActorSpawn(PActor.GetVehicle(), PActor.Location, PActor.Rotation);

	if (ExitSpawnMode)
	{
		PActor.Destroy(); 
		PActor = none;
	}
}

exec function ExitSpawnMode()
{
	PActor.Destroy(); 
	PActor = none;
}

/////////////////////////////////////////////////////////
////////////////////Server Functions/////////////////////
/////////////////////////////////////////////////////////

reliable server function ServerTogglePlayerSpawns()
{
	local CM_ControllerNvN CMC;

	if (!CanExecuteCommands())
	{
		AccessDenied();
		return;
	}


	foreach WorldInfo.AllControllers(class'CM_ControllerNvN', CMC)
	{
		CMC.PlayersCanSpawn = !CMC.PlayersCanSpawn;
	}
	SaveConfig();

	if (PlayersCanSpawn)
	{
   		CTextMessage("Player spawns enabled");
   		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"enabled player spawns", 'SSay');
   		`logRxPub(GetHumanReadableName()@"enabled player spawns");
	}
   	else
   	{
   		CTextMessage("Player spawns disabled");
   		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"disabled player spawns", 'SSay');
   		`logRxPub(GetHumanReadableName()@"disabled player spawns");
   	}
}

reliable server function ServerGimme(string WeaponClassStr)
{
	local class<Weapon> WeaponClass;

	if (!PlayersCanSpawn && !CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	if (SpawnDisabled && !CanExecuteCommands())
	{
		TooRecent();
		return;
	}

	WeaponClass = class<Weapon>(DynamicLoadObject(WeaponClassStr, class'Class'));

	SpawnDisabled = true;
	SetTimer(SpawnCooldown, false, 'ResetSpawnTimer');

	Pawn.CreateInventory(WeaponClass);

	`logRxPub(GetHumanReadableName()@"gave himself a"@WeaponClass);
}

reliable client function ClientInfiniteAmmo()
{
    local Rx_Weapon Wp;

	if (!CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

    ForEach `WorldInfoObject.AllActors(class'Rx_Weapon', Wp)
    {
		Wp.ShotCost[0] = 0;
		Wp.ShotCost[1] = 0;
		Wp.bHasInfiniteAmmo = true;
		Wp.MaxSpread = 0.01;
    }
    `log("INFINTE AMMO ACTIVE");
}

reliable server function ServerSandboxSpawn(string ClassName)
{
	local class<Actor> NewClass;
	local vector SpawnLoc;
	local Actor A;
	local int i;

	if (!PlayersCanSpawn && !CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	if (SpawnDisabled && !CanExecuteCommands())
	{
		TooRecent();
		return;
	}

	NewClass = class<Actor>(DynamicLoadObject(ClassName, class'Class'));

	if (ClassIsChildOf(NewClass, class'Renx_Game.Rx_Sentinel') || ClassIsChildOf(NewClass, class'Renx_Game.Rx_Defence') && !CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	if (NewClass != None)
	{
		SpawnDisabled = true;
		SetTimer(SpawnCooldown, false, 'ResetSpawnTimer');

		if (ClassIsChildOf(NewClass, class'Renx_Game.Rx_Weapon_DeployedBeacon')) 
			For (i = 0; i < SpawnedActors.Length; i++)
				if (Rx_Weapon_DeployedBeacon(SpawnedActors[i]) != None)
				{
					CTextMessage("You can only have one beacon spawned at once", 'Red');
					break;
				}

		if (Pawn != None)
			SpawnLoc = Pawn.Location;
		else
			SpawnLoc = Location;

		A = Spawn(NewClass,,,SpawnLoc + 500 * Vector(Rotation) + vect(0.0,0.0,1.0) * 15);
		SpawnedActors.AddItem(A);

		if (A.IsA('Rx_Weapon_DeployedActor'))
		{
			Rx_Weapon_DeployedActor(A).InstigatorController = self;
			Rx_Weapon_DeployedActor(A).TeamNum = GetTeamNum();	
		}

		else if (A.IsA('UTVehicle'))
			UTVehicle(A).SetTeamNum(GetTeamNum());

		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"spawned a"@A.GetHumanReadableName(), 'SSay');
		`logRxPub(GetHumanReadableName()@"spawned a"@A.GetHumanReadableName());
	}
	else
	{
		CTextMessage("Failed to spawn:"@ClassName);
	}
}

reliable client function ClientReplace(string NewClass)
{
	local Actor B;

	if (!CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	B = Rx_HUD(myHUD).TargetingBox.TargetedActor;
	ServerReplace(NewClass, B);
}

reliable server function ServerReplace(string NewClass, Actor Target)
{
	local class<Actor> ReplacementClass;

	if (!CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	ReplacementClass = class<Actor>(DynamicLoadObject(NewClass, class'Class'));
	`log(`showvar(ReplacementClass));

	if (ReplacementClass != None)
	{
        	Target.Destroy();
			ReplaceWith(Target, NewClass);

			`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"replaced a"@Target.GetHumanReadableName(), 'SSay');
			`logRxPub(GetHumanReadableName()@"replaced a"@Target.GetHumanReadableName()@"with a"@ReplacementClass);
	}
	else
	CTextMessage("Failed to replace class with:"@NewClass);
}

reliable server function ServerReplaceAll(string ClassName, string NewClass)
{
	local Actor B;
	local class<Actor> ClassToReplace;
	local class<Actor> ReplacementClass;

	if (!CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	ClassToReplace = class<Actor>(DynamicLoadObject(ClassName, class'Class'));
	`log(`showvar(ClassToReplace));

	ReplacementClass = class<Actor>(DynamicLoadObject(NewClass, class'Class'));
	`log(`showvar(ReplacementClass));

	if (ClassToReplace != None && ReplacementClass != None)
	{
		ForEach `WorldInfoObject.AllActors(ClassToReplace, B)
		{
        	B.Destroy();
        	//B.Destroyed();
			ReplaceWith(B, NewClass);

		}
		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"replaced all"@B.GetHumanReadableName()@"s", 'SSay');
		`logRxPub(GetHumanReadableName()@"replaced all"@B.GetHumanReadableName()@"with"@ReplacementClass);
	}
	else
	CTextMessage("Failed to replace:"@ClassName);
}

reliable client function ClientDestroyThis()
{
	local Actor B;

	if (!CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	B = Rx_HUD(myHUD).TargetingBox.TargetedActor;

    ServerDestroyThis(B);
}

reliable server function ServerDestroyThis(Actor Target)
{
	if (!CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

    Target.Destroy();
    //B.Destroyed();
	`logRxPub(GetHumanReadableName()@"removed a"@Target.GetHumanReadableName());
	CTextMessage("Removed:"@Target.GetHumanReadableName());
}

reliable server function ServerDestroyAll(string ClassName)
{
	local Actor B;
	local class<Actor> ClassToDestroy;

	if (!CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	ClassToDestroy = class<Actor>(DynamicLoadObject(ClassName, class'Class'));
	`log(`showvar(ClassToDestroy));


	if (ClassToDestroy != None)
	{
		ForEach `WorldInfoObject.AllActors(ClassToDestroy, B)
		{
        	B.Destroy();
        	//B.Destroyed();

			`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"removed all"@B.GetHumanReadableName()@"s", 'SSay');
			`logRxPub(GetHumanReadableName()@"removed all"@B.GetHumanReadableName()@"s");
		}
	}
	else
	CTextMessage("Failed to remove:"@ClassName);
}

reliable server function ServerSandboxKillOwned(optional string ClassName)
{
	local Actor A;

	ForEach SpawnedActors(A) 
	{
		if (ClassName == "")
		{
			A.Destroy(); 
		}
		else if(A.IsA(name(ClassName)))
		{
			A.Destroy();
		}
	}
}

reliable server function ServerSandboxKillAll(optional string ClassName)
{
	local CM_ControllerNvN CMC;

	if (!CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	foreach WorldInfo.AllControllers(class'CM_ControllerNvN', CMC)
	{
		CMC.ServerSandboxKillOwned(ClassName);
	}

	CTextMessage("Removed all spawns", 'Green');
	`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"removed all spawns", 'SSay');
	`logRxPub(GetHumanReadableName()@"removed all spawns");
}

reliable server function ServerGiveCreds(Rx_PRI Receiver, optional float Credits = 25000.0)
{
	if (!CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	Receiver.AddCredits(Credits);

	if (Receiver == Rx_PRI(PlayerReplicationInfo))
		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"gave themself credits", 'SSay');
	else
		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"gave"@Receiver.GetHumanReadableName()@"credits", 'SSay');
}

reliable server function ServerGivePromo(Rx_PRI Receiver)
{
	if (!CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	Receiver.AddVP(Rx_Game(`WorldInfoObject.Game).default.VPMilestones[FMax(2, Receiver.VRank)] - Receiver.Veterancy_Points);
	CTextMessage("Promoted"@Receiver.GetHumanReadableName());
	`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"promoted"@Receiver.GetHumanReadableName(), 'SSay');
	`logRxPub(GetHumanReadableName()@"promoted"@Receiver.GetHumanReadableName());
}


reliable server function ServerLockHealth()
{
	local Rx_Building_Team_Internals BuildingInternals;
	local bool isLocked;
	local string tempS;

	if (!CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	ForEach `WorldInfoObject.AllActors(class'Rx_Building_Team_Internals', BuildingInternals)
	{
		BuildingInternals.HealthLocked = !BuildingInternals.HealthLocked;
		isLocked = BuildingInternals.HealthLocked;
	}

	if (isLocked) tempS = "locked";
	else tempS = "unlocked";

	CTextMessage("Building HP is now" @ tempS, 'Green');
	`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@tempS@"building HP", 'SSay');
	`logRxPub(GetHumanReadableName()@tempS@"building HP");
}

reliable server function ServerGiveChar(string Character)
{
	local class<Rx_FamilyInfo> FamClass;

	if (!PlayersCanSpawn && !CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	if (SpawnDisabled && !CanExecuteCommands())
	{
		TooRecent();
		return;
	}

	SpawnDisabled = true;
	SetTimer(SpawnCooldown, false, 'ResetSpawnTimer');

	FamClass = class<Rx_FamilyInfo>(DynamicLoadObject(Character, class'Class'));

	CTextMessage("Attempting to set you to"@Character, 'Green');
	
	Rx_PRI(PlayerReplicationInfo).SetChar(FamClass, Pawn, true);
}

reliable server function ServerFly(Rx_PRI Receiver)
{
	local Rx_Controller C;

	if (Receiver != Rx_PRI(PlayerReplicationInfo) && !CanExecuteCommands() || !PlayersCanSpawn && !CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	C = Rx_Controller(Receiver.Owner);

	if (C.Pawn != None && C.Pawn.CheatFly())
	{
		C.CTextMessage("Fly mode activated", 'Green');
		C.bCheatFlying = true;
		C.GotoState('PlayerFlying');
	}
}

reliable server function ServerWalk(Rx_PRI Receiver)
{
	local Rx_Controller C;

	if (Receiver != Rx_PRI(PlayerReplicationInfo) && !CanExecuteCommands() || !PlayersCanSpawn && !CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	C = Rx_Controller(Receiver.Owner);

	if (C.Pawn != None && C.Pawn.CheatWalk())
	{
		C.CTextMessage("Fly mode deactivated", 'Green');
		C.bCheatFlying = false;
		C.Restart(false);
	}
}

reliable server function ServerGiveGod(Rx_PRI Receiver)
{
	local Rx_Controller C;

	if (Receiver != Rx_PRI(PlayerReplicationInfo) && !CanExecuteCommands() || !PlayersCanSpawn && !CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	if (Rx_Controller(Receiver.Owner) != None)
		C = Rx_Controller(Receiver.Owner);

	C.bGodMode = !C.bGodMode;

	if (Receiver == Rx_PRI(PlayerReplicationInfo))
	{
		if (C.bGodMode)
		{
   			C.CTextMessage("You are now a god");
   			`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"gave themself god mode", 'SSay');
   			`logRxPub(GetHumanReadableName()@"gave themself god mode");
		}
   		else
   		{
   			C.CTextMessage("You are no longer a god");
   			`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"removed their own god mode", 'SSay');
   			`logRxPub(GetHumanReadableName()@"removed their own god mode");
   		}

   		return;
   	}

	if (C.bGodMode)
	{
   		CTextMessage(C.GetHumanReadableName()@"is now a god");
   		C.CTextMessage("You are now a god");
   		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"gave"@C.GetHumanReadableName()@"god mode", 'SSay');
   		`logRxPub(GetHumanReadableName()@"gave"@C.GetHumanReadableName()@"god mode");
	}
   	else
   	{
   		CTextMessage(C.GetHumanReadableName()@"is no longer a god");
   		C.CTextMessage("You are no longer a god");
   		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"disabled"@C.GetHumanReadableName()$"'s god mode", 'SSay');
   		`logRxPub(GetHumanReadableName()@"disabled"@C.GetHumanReadableName()$"'s god mode");
   	}
}

reliable server function ServerDestroyDefences()
{
	local Rx_Defence Def;
	local Rx_Building_Defense AdvDef;
	local Rx_Defence_Controller DefCon;

	if (!CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	ForEach `WorldInfoObject.AllActors(class'Rx_Defence', Def)
		Def.Destroy();

	ForEach `WorldInfoObject.AllActors(class'Rx_Defence_Controller', DefCon)
		DefCon.Destroy();

	ForEach `WorldInfoObject.AllActors(class'Rx_Building_Defense', AdvDef)
		Rx_Building_Team_Internals(AdvDef.BuildingInternals).PowerLost(true);

	CTextMessage("Disabled all defences", 'Green');
	`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"disabled base defences", 'SSay');	
	`logRxPub(GetHumanReadableName()@"disabled base defences");	
}

reliable server function ServerRestoreBuildings()
{
	local Rx_Building_Team_Internals BuildingInternals;
	local Rx_Building_Refinery_GDI_Internals GDI_Ref;
	local Rx_Building_Refinery_Nod_Internals Nod_Ref;


	if (!CanExecuteCommands())
	{
		AccessDenied();
		return;
	}

	Rx_Game(WorldInfo.Game).GetVehicleManager().bGDIRefDestroyed=false;
	Rx_Game(WorldInfo.Game).GetVehicleManager().bNodRefDestroyed=false;
	Rx_Game(WorldInfo.Game).GetVehicleManager().bNodIsUsingAirdrops=false;
	Rx_Game(WorldInfo.Game).GetVehicleManager().bGDIIsUsingAirdrops=false;
	Rx_Game(WorldInfo.Game).GetVehicleManager().NodAdditionalAirdropProductionDelay=0;
	Rx_Game(WorldInfo.Game).GetVehicleManager().GDIAdditionalAirdropProductionDelay=0;

	ForEach `WorldInfoObject.AllActors(class'Rx_Building_Refinery_GDI_Internals', GDI_Ref)
	{
		if(GDI_Ref.IsDestroyed())
		{
			Rx_Game(WorldInfo.Game).GetVehicleManager().QueueHarvester(TEAM_GDI, false);
		}
	}

	ForEach `WorldInfoObject.AllActors(class'Rx_Building_Refinery_Nod_Internals', Nod_Ref)
	{
		if(Nod_Ref.IsDestroyed())
		{
			Rx_Game(WorldInfo.Game).GetVehicleManager().QueueHarvester(TEAM_Nod, false);
		}
	}

	ForEach `WorldInfoObject.AllActors(class'Rx_Building_Team_Internals', BuildingInternals)
	{
		BuildingInternals.Health=BuildingInternals.TrueHealthMax;
		BuildingInternals.Armor=BuildingInternals.TrueHealthMax;

        BuildingInternals.DamageLodLevel = BuildingInternals.GetBuildingHealthLod();
		BuildingInternals.ChangeDamageLodLevel(BuildingInternals.GetBuildingHealthLod());

		if(BuildingInternals.IsDestroyed() || BuildingInternals.bNoPower)
		{
			BuildingInternals.bDestroyed=false;
			BuildingInternals.PowerRestore();
		}
	}


	CTextMessage("Buildings restored", 'Green');
	`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"restored all buildings.", 'SSay');
	`logRxPub(GetHumanReadableName()@"restored all buildings.");
}

reliable server function bool ServerAttemptActorSpawn(class<Rx_Vehicle> VehicleToSpawn, Vector VLocation, Rotator VRotation)
{
	local Actor ThisActor;

	if (!PlayersCanSpawn && !CanExecuteCommands())
	{
		AccessDenied();
		return false;
	}

	if (SpawnDisabled && !CanExecuteCommands())
	{
		TooRecent();
		return false;
	}

	if (ClassIsChildOf(VehicleToSpawn, class'Renx_Game.Rx_Defence') && !CanExecuteCommands())
	{
		AccessDenied();
		return false;
	}

	SpawnDisabled = true;
	SetTimer(SpawnCooldown, false, 'ResetSpawnTimer');

	ThisActor = spawn(VehicleToSpawn, None,,VLocation,VRotation);
	SpawnedActors.AddItem(ThisActor);
	UTVehicle(ThisActor).Mesh.WakeRigidBody();
	UTVehicle(ThisActor).SetTeamNum(GetTeamNum());

	`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"spawned a"@ThisActor.GetHumanReadableName(), 'SSay');
	`logRxPub(GetHumanReadableName()@"spawned a"@ThisActor.GetHumanReadableName());

	return true;
}

reliable server function bool ServerGiveRefill(Rx_PRI Receiver)
{
	if (Receiver != Rx_PRI(PlayerReplicationInfo) && !CanExecuteCommands() || !PlayersCanSpawn && !CanExecuteCommands())
	{
		AccessDenied();
		return false;
	}

	if (SpawnDisabled && !CanExecuteCommands())
	{
		TooRecent();
		return false;
	}

	SpawnDisabled = true;
	SetTimer(SpawnCooldown, false, 'ResetSpawnTimer');

	Rx_Game(WorldInfo.Game).GetPurchaseSystem().PerformRefill(Rx_Controller(Receiver.Owner));

	`WorldInfoObject.Game.Broadcast(None, Receiver.Owner.GetHumanReadableName()@"got refilled.", 'SSay');
	`logRxPub(Receiver.Owner.GetHumanReadableName()@"got refilled by"@GetHumanReadableName());

	return true;
}

reliable server function bool ReplaceWith(actor Other, string aClassName)
{
    local Actor A;
    local class<Actor> aClass;
    local PickupFactory OldFactory, NewFactory;

    if ( aClassName == "" )
        return true;

    aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
    if ( aClass != None )
    {
        A = Spawn(aClass,Other.Owner,,Other.Location, Other.Rotation);
        if (A != None)
        {
            OldFactory = PickupFactory(Other);
            NewFactory = PickupFactory(A);
            if (OldFactory != None && NewFactory != None)
            {
                OldFactory.ReplacementFactory = NewFactory;
                NewFactory.OriginalFactory = OldFactory;
            }
        }
    }
    return ( A != None );
}

DefaultProperties
{
	InputClass = class'Rx_CreativeMode.CM_PlayerInput'
}