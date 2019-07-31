class Rx_CreativeMode_Controller extends Rx_Controller;

var privatewrite array<Actor> SpawnedActors;

// Helper & misc. functions

function AddToKeyString(coerce string KeyInput)
{
	Super.AddToKeyString(KeyInput);

	if (KeyInput ~= "B" && Rx_PlayerInput(PlayerInput).bCntrlPressed)
		Rx_CreativeMode_HUD(myHUD).ToggleMenu();

	Rx_CreativeMode_HUD(myHUD).ButtonPressed(KeyInput);
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

exec function ToggleFPS()
{
	Rx_CreativeMode_HUD(myHUD).bDrawFPSMenu = !Rx_CreativeMode_HUD(myHUD).bDrawFPSMenu;
}

// Weapon Commands

exec function Gimme(string Weap)
{
	ServerGimme(Weap);
}

reliable server function ServerGimme(string WeaponClassStr)
{
	local class<Weapon> WeaponClass;

	WeaponClass = class<Weapon>(DynamicLoadObject(WeaponClassStr, class'Class'));

	Pawn.CreateInventory(WeaponClass);
}

// Spawn Commands

exec function SandboxSpawn(string ClassName) 
{ 
	ServerSandboxSpawn(ClassName);
}

reliable server function ServerSandboxSpawn(string ClassName)
{
	local class<Actor> NewClass;
	local vector SpawnLoc;
	local Actor A;
	local int i;

	if (!PlayerReplicationInfo.bAdmin)
	{
		AccessDenied();
		return;
	}

	NewClass = class<Actor>(DynamicLoadObject(ClassName, class'Class'));

	if (NewClass != None)
	{
		if (NewClass == class'Renx_Game.Rx_Weapon_DeployedBeacon') 
			For (i = 0; i < SpawnedActors.Length; i++)
				if (SpawnedActors[i].IsA('Rx_Weapon_DeployedBeacon'))
				{
					CTextMessage("You can only have one beacon spawned at once", 'Red');
					break;
				}

		if (Pawn != None)
			SpawnLoc = Pawn.Location;
		else
			SpawnLoc = Location;

		A = Spawn(NewClass,,,SpawnLoc + 72 * Vector(Rotation) + vect(0.0,0.0,1.0) * 15);
		SpawnedActors.AddItem(A);

		if (A.IsA('Rx_Weapon_DeployedActor'))
		{
			Rx_Weapon_DeployedActor(A).InstigatorController = self;
			Rx_Weapon_DeployedActor(A).TeamNum = GetTeamNum();	
		}
		else if (A.IsA('UTVehicle'))
			UTVehicle(A).SetTeamNum(GetTeamNum());

		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"spawned a"@A.GetHumanReadableName(), 'SSay');
	}
}

exec function SandboxKillOwned(optional string ClassName)
{
	ServerSandboxKillOwned(ClassName); 
	CTextMessage("Removed all your spawns", 'Green');
} 

reliable server function ServerSandboxKillOwned(optional string ClassName)
{
	local Actor A;

	ForEach SpawnedActors(A) 
	{
		if (ClassName == "") A.Destroy();
		else if(A.IsA(name(ClassName))) A.Destroy();
	}
}

// Money Commands

exec function GiveCreds(optional string PlayerName)
{
	ServerGiveCreds(FindPlayerPRI(PlayerName));
}

reliable server function ServerGiveCreds(Rx_PRI Receiver, optional float Credits = 25000.0)
{
	if (PlayerReplicationInfo.bAdmin)
		Receiver.AddCredits(Credits);
	else
	{
		AccessDenied();
		return;
	}

	if (Receiver == Rx_PRI(PlayerReplicationInfo))
		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"gave themself credits", 'SSay');
	else
		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"gave"@Receiver.GetHumanReadableName()@"credits", 'SSay');
}

// VP Commands

exec function GivePromo(optional string PlayerName)
{
	ServerGivePromo(FindPlayerPRI(PlayerName));
}

reliable server function ServerGivePromo(Rx_PRI Receiver)
{
	if (PlayerReplicationInfo.bAdmin)
	{
		Receiver.AddVP(Rx_Game(`WorldInfoObject.Game).default.VPMilestones[FMax(2, Receiver.VRank)] - Receiver.Veterancy_Points);
		CTextMessage("Promoted"@Receiver.GetHumanReadableName());
		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"promoted"@Receiver.GetHumanReadableName(), 'SSay');
	}

	else AccessDenied();
}

// Building Commands

exec function LockHealth()
{
	ServerLockHealth();
}

reliable server function ServerLockHealth()
{
	local Rx_Building_Team_Internals BuildingInternals;
	local bool isLocked;
	local string tempS;

	if (PlayerReplicationInfo.bAdmin)
	{	
		ForEach `WorldInfoObject.AllActors(class'Rx_Building_Team_Internals', BuildingInternals)
		{
			BuildingInternals.HealthLocked = !BuildingInternals.HealthLocked;
			isLocked = BuildingInternals.HealthLocked;
		}

		if (isLocked) tempS = "locked";
		else tempS = "unlocked";

		CTextMessage("Building HP is now" @ tempS, 'Green');
		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@tempS@"building HP", 'SSay');
	}

	else AccessDenied();
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

exec function GiveChar(string Character)
{
	ServerGiveChar(Character);
}

reliable server function ServerGiveChar(string Character)
{
	local class<Rx_FamilyInfo> FamClass;

	if (PlayerReplicationInfo.bAdmin)
	{	
		FamClass = class<Rx_FamilyInfo>(DynamicLoadObject(Character, class'Class'));

		CTextMessage("Attempting to set you to"@Character, 'Green');
	
		Rx_PRI(PlayerReplicationInfo).SetChar(FamClass, Pawn, true);
	}

	else AccessDenied();
}

exec function Fly(optional string PlayerName)
{
	ServerFly(FindPlayerPRI(PlayerName));
}

reliable server function ServerFly(Rx_PRI Receiver)
{
	local Rx_Controller C;

	if (!PlayerReplicationInfo.bAdmin)
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

exec function Walk(optional string PlayerName)
{
	ServerWalk(FindPlayerPRI(PlayerName));
}

reliable server function ServerWalk(Rx_PRI Receiver)
{
	local Rx_Controller C;

	if (!PlayerReplicationInfo.bAdmin)
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

exec function GiveGod(optional string PlayerName)
{
	ServerGiveGod(FindPlayerPRI(PlayerName));
}

reliable server function ServerGiveGod(Rx_PRI Receiver)
{
	local Rx_Controller C;

	if (PlayerReplicationInfo.bAdmin)
	{
		if (Rx_Controller(Receiver.Owner) != None)
			C = Rx_Controller(Receiver.Owner);

		C.bGodMode = !C.bGodMode;

		if (Receiver == Rx_PRI(PlayerReplicationInfo))
		{
			if (C.bGodMode)
			{
   				C.CTextMessage("You are now a god");
   				`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"gave themself god mode", 'SSay');
			}
   			else
   			{
   				C.CTextMessage("You are no longer a god");
   				`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"removed their own god mode", 'SSay');
   			}

   			return;
   		}

		if (C.bGodMode)
		{
   			CTextMessage(C.GetHumanReadableName()@"is now a god");
   			C.CTextMessage("You are now a god");
   			`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"gave"@C.GetHumanReadableName()@"god mode", 'SSay');
		}
   		else
   		{
   			CTextMessage(C.GetHumanReadableName()@"is no longer a god");
   			C.CTextMessage("You are no longer a god");
   			`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"disabled"@C.GetHumanReadableName()$"'s god mode", 'SSay');
   		}
	}

	else AccessDenied();
}

exec function DestroyDefences()
{
   	ServerDestroyDefences();
}

reliable server function ServerDestroyDefences()
{
	local Rx_Defence Def;
	local Rx_Building_Defense AdvDef;
	local Rx_Defence_Controller DefCon;

	if (PlayerReplicationInfo.bAdmin)
	{
		ForEach `WorldInfoObject.AllActors(class'Rx_Defence', Def)
			Def.Destroy();

		ForEach `WorldInfoObject.AllActors(class'Rx_Defence_Controller', DefCon)
			DefCon.Destroy();

		ForEach `WorldInfoObject.AllActors(class'Rx_Building_Defense', AdvDef)
			Rx_Building_Team_Internals(AdvDef.BuildingInternals).PowerLost();

		CTextMessage("Disabled all defences", 'Green');
		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"disabled base defences", 'SSay');		
	}

	else AccessDenied();
}

function AccessDenied()
{
	CTextMessage("Access denied", 'Red');
}
