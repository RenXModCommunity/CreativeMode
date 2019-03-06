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

	if (!PlayerReplicationInfo.bAdmin)
		return;

	NewClass = class<Actor>(DynamicLoadObject(ClassName, class'Class'));

	if (NewClass != None)
	{
		if(NewClass == class'Renx_Game.Rx_Weapon_DeployedBeacon') 
		{
			For(i = 0; i < SpawnedActors.Length; i++)
				if (SpawnedActors[i].IsA('Rx_Weapon_DeployedBeacon'))
				{
					CTextMessage("You can only have one beacon spawned at once.", 'Red');
					break;
				}
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
	}
}

exec function SandboxKillOwned(optional string ClassName)
{
	ServerSandboxKillOwned(ClassName); 
	CTextMessage("Removed all your spawns.", 'Green');
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
		Receiver.AddVP(Rx_Game(`WorldInfoObject.Game).default.VPMilestones[Rx_PRI(PlayerReplicationInfo).VRank] - Rx_PRI(PlayerReplicationInfo).Veterancy_Points);
		CTextMessage("Promoted"@Receiver.GetHumanReadableName()$".");
	}
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
		foreach `WorldInfoObject.AllActors(class'Rx_Building_Team_Internals', BuildingInternals)
		{
			BuildingInternals.HealthLocked = !BuildingInternals.HealthLocked;
			isLocked = BuildingInternals.HealthLocked;
		}
	
		if (isLocked)
			CTextMessage("Locked building HP", 'Green');
		else
			CTextMessage("Unlocked building HP", 'Green');
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
}