class Rx_CreativeMode extends Rx_Mutator;

var private CM_ServerFPS SystemMutator;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetTimer(1600.0f, true, nameof(Broadcast));
	SetTimer(300.0f, true, nameof(Broadcast2));
}

function Broadcast()
{
    `WorldInfoObject.Game.Broadcast(None, "This server is running Creative Mode, created by Sarah & Cynthia, made with love! <3", 'SSay');
}

function Broadcast2()
{
    `WorldInfoObject.Game.Broadcast(None, "Press B to open the Creative Mode menu", 'SSay');
}

function bool CheckReplacement(Actor Other)
{ 	
	if (Other.IsA('Rx_TeamInfo'))
	{
		Rx_Game(`WorldInfoObject.Game).HudClass = class'CM_HUD';
		Rx_Game(`WorldInfoObject.Game).PlayerControllerClass = class'CM_Controller';
	}

	return true;
}

function InitMutator(string Options, out string ErrorMessage)
{
    SystemMutator = Spawn(class'CM_ServerFPS');
}

simulated function Tick(float DeltaTime)
{
    if (SystemMutator != None)
        SystemMutator.OnTick(DeltaTime);
}
