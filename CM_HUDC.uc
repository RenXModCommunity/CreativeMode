class CM_HUDC extends Rx_Hud_Component;

var CM_ServerFPS ServerFPS;

function Update(float DeltaTime, Rx_HUD HUD) 
{
	local CM_ServerFPS thisClass;
	super.Update(DeltaTime, HUD);
	
	if (ServerFPS == None)
	{
		// Find our controller.
		foreach RenxHud.PlayerOwner.AllActors(class'CM_ServerFPS', thisClass)
		{
			ServerFPS = thisClass;
			break;
		}
	}

	if (ServerFPS == None)
		return;
}

function Draw()
{
	DrawServerFPS();
}

simulated function DrawServerFPS()
{
	local float X, Y;
	local string hudMessage, fpsMessage;
	
	if (RenxHud.PlayerOwner != None && RenxHud.PlayerOwner.PlayerReplicationInfo != None && !RenxHud.PlayerOwner.PlayerReplicationInfo.bAdmin)
		return;
	
	X = RenxHud.Canvas.SizeX*0.005;
	Y = RenxHud.Canvas.SizeY*0.60;
	Canvas.SetPos(X,Y);
	Canvas.SetDrawColor(255,0,0,200);
	Canvas.Font = Font'RenXHud.Font.RadioCommand_Medium';
	
	if (ServerFPS == None)
	
		Canvas.DrawText("Admin HUD Loading...");
	else
	{
		hudMessage = "[Admin Info]\n";
		fpsMessage = ServerFPS.ServerFPS == 0 ? "Running As Client Or No Data!" : string(ServerFPS.ServerFPS);
		hudMessage $= "SFPS: " $ fpsMessage $ " | Delta Time: " $ ServerFPS.ServerDeltaTime $ "\n";
		Canvas.DrawText(hudMessage);
	}
}
