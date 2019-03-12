class Rx_CreativeTool_Controller extends Rx_Controller;

var privatewrite array<Actor> SpawnedActors;

function AddToKeyString (coerce string KeyInput)
{
	Super.AddToKeyString(KeyInput);

	if ((KeyInput ~= "B") && Rx_PlayerInput(PlayerInput).bCntrlPressed)
		Rx_CreativeTool_HUD(myHUD).ToggleMenu();

	Rx_CreativeTool_HUD(myHUD).ButtonPressed(KeyInput);
}

exec function Gimme(string Weapon)
{
	ServerGimme(Weapon);
}

reliable server function Weapon ServerGimme(string WeaponClassStr)
{
	local Weapon Weap;
	local class<Weapon> WeaponClass;

	if (!PlayerReplicationInfo.bAdmin)
		return None;
		
	WeaponClass = class<Weapon>(DynamicLoadObject(WeaponClassStr, class'Weapon'));
	Weap = Weapon(Pawn.FindInventoryType(WeaponClass));

	if (Weap != None)
		return Weap;

	if (Len(WeaponClass.default.ItemName) > 0)
		CTextMessage("Adding"@WeaponClass.default.ItemName@"to your inventory", 'Green');
	else
		CTextMessage("Trying to add"@WeaponClassStr@"to your inventory", 'Green');
	
	return Weapon(Pawn.CreateInventory(WeaponClass));
}

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

	if (!PlayerReplicationInfo.bAdmin) AccessDenied();

	NewClass = class<Actor>(DynamicLoadObject(ClassName, class'Class'));

	if (NewClass != None)
	{
		if(NewClass == class'Renx_Game.Rx_Weapon_DeployedBeacon') 
			For(i = 0; i < SpawnedActors.Length; i++)
				if (SpawnedActors[i].IsA('Rx_Weapon_DeployedBeacon'))
				{
					CTextMessage("You can only have one beacon spawned at once", 'Red');
					break;
				}

		if (Pawn != None)
			SpawnLoc = Pawn.Location;
		else
			SpawnLoc = Location;

			A = Spawn(NewClass,self,,SpawnLoc + 72 * Vector(Rotation) + vect(0.0,0.0,1.0) * 15);
			SpawnedActors.additem(A);

		if(A.IsA('Rx_Weapon_DeployedActor'))
		{
			Rx_Weapon_DeployedActor(A).InstigatorController = self;
			Rx_Weapon_DeployedActor(A).TeamNum = GetTeamNum();	
		}
		else if(A.IsA('UTVehicle'))
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

exec function GiveCreds(optional string PlayerName)
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

   		ServerGiveCreds(PlayerPRI);
	}
	else 
		ServerGiveCreds(Rx_PRI(PlayerReplicationInfo));
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

reliable server function ServerGivePromo(Rx_PRI Receiver)
{
	if (PlayerReplicationInfo.bAdmin)
	{
		Receiver.AddVP(Rx_Game(`WorldInfoObject.Game).default.VPMilestones[Receiver.VRank] - Receiver.Veterancy_Points);
		CTextMessage("Promoted"@Receiver.GetHumanReadableName());
		`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"promoted"@Receiver.GetHumanReadableName(), 'SSay');
	}

	else AccessDenied();
}

exec function LockHealth()
{
	ServerLockHealth();
}

reliable server function ServerLockHealth()
{
	local Rx_Building_Team_Internals BuildingInternals;
	local bool isLocked;

	if (PlayerReplicationInfo.bAdmin)
	{	
		ForEach `WorldInfoObject.AllActors(class'Rx_Building_Team_Internals', BuildingInternals)
		{
			BuildingInternals.HealthLocked = !BuildingInternals.HealthLocked;
			isLocked = BuildingInternals.HealthLocked;
		}
	
		if (isLocked)
		{
			CTextMessage("Locked building HP", 'Green');
			`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"locked building HP", 'SSay');
		}
		else
		{
			CTextMessage("Unlocked building HP", 'Green');
			`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"unlocked building HP", 'SSay');
		}
	}

	else AccessDenied();
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

reliable server function ServerGiveGod(Rx_PRI Receiver)
{
	local Rx_Controller C;

	if (PlayerReplicationInfo.bAdmin)
	{
		if (Rx_Controller(Receiver.Owner) != None)
			C = Rx_Controller(Receiver.Owner);

		C.bGodMode = !C.bGodMode;

		if (Receiver == Rx_PRI(C.PlayerReplicationInfo))
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
   			`WorldInfoObject.Game.Broadcast(None, GetHumanReadableName()@"set"@C.GetHumanReadableName()@"to god mode", 'SSay');
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

state PlayerFlying
{
	ignores SeePlayer, HearNoise, Bump;
	
		function PlayerMove(float DeltaTime)
		{
			local vector X,Y,Z;
	
			GetAxes(Rotation,X,Y,Z);
	
			Pawn.Acceleration = PlayerInput.aForward*X + PlayerInput.aStrafe*Y + PlayerInput.aUp*vect(0,0,1);;
			Pawn.Acceleration = (Pawn.AccelRate + 300) * Normal(Pawn.Acceleration);
	
			if ( bCheatFlying && (Pawn.Acceleration == vect(0,0,0)) )
				Pawn.Velocity = vect(0,0,0);
			// Update rotation.
			UpdateRotation( DeltaTime );
	
			if ( Role < ROLE_Authority ) // then save this move and replicate it
				ReplicateMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
			else
				ProcessMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
		}
	
		event BeginState(Name PreviousStateName)
		{
			Pawn.SetPhysics(PHYS_Flying);
		}
}

exec function SCheats(optional bool bForce)
{
	if ((CheatManager == None) && (WorldInfo.Game != None) && PlayerReplicationInfo.bAdmin)
	{
		CheatManager = new(Self) CheatClass;
		CheatManager.InitCheatManager();
	}
}

exec function SFly()
{
	AddCheats(true);
	CheatManager.Fly();
}