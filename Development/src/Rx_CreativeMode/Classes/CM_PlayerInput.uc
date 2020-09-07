class CM_PlayerInput extends Rx_PlayerInput;

function bool InputKey(int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE)
{
	local CM_Controller pc;
	local CM_ControllerNvN pcNvN;

	pc = CM_Controller(Player.Actor);
	pcNvN = CM_ControllerNvN(Player.Actor);

	if (Key == 'LeftMouseButton' && Event == IE_Pressed && pc.PActor != None)
	{
		pc.AttemptSpawn();

		return true;
	}

	if (Key == 'RightMouseButton' && Event == IE_Pressed && pc.PActor != None)
	{
		pc.ExitSpawnMode();

		return true;
	}

	if (Key == 'LeftMouseButton' && Event == IE_Pressed && pcNvN.PActor != None)
	{
		pcNvN.AttemptSpawn();

		return true;
	}

	if (Key == 'RightMouseButton' && Event == IE_Pressed && pcNvN.PActor != None)
	{
		pcNvN.ExitSpawnMode();

		return true;
	}

	return super.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
}