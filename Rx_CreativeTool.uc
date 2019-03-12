class Rx_CreativeTool extends Rx_Mutator;

var private Rx_CreativeTool_ServerFPS SystemMutator;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetTimer(180.0f, true, nameof(Broadcast));
}

function Broadcast()
{
    `WorldInfoObject.Game.Broadcast(None, "This server is running in Creative mode, created by Sarah, made with love! <3", 'SSay');
}

function bool CheckReplacement(Actor Other)
{ 	
	if (Other.IsA('Rx_TeamInfo'))
	{
		Rx_Game(`WorldInfoObject.Game).HudClass = class'Rx_CreativeTool_HUD';
		Rx_Game(`WorldInfoObject.Game).PlayerControllerClass = class'Rx_CreativeTool_Controller';
	}

	return true;
}

function InitMutator(string Options, out string ErrorMessage)
{
    SystemMutator = spawn(class'Rx_CreativeTool_ServerFPS');
}

simulated function Tick(float DeltaTime)
{
    if (SystemMutator != None)
        SystemMutator.OnTick(DeltaTime);
}