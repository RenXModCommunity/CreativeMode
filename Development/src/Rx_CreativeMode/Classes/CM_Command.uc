class CM_Command extends Actor
abstract;

var const string OnSelfCastText, OnOtherCastText;
var const string CommandName;
var const bool bLogToRCON;

event OnSuccess(Rx_PRI Executor, optional Rx_PRI Receiver)
{
	local string RCONMessage;

	if (Receiver == None) RCONMessage = OnSelfCastText;

	else
	{
		RCONMessage = OnOtherCastText;
		RCONMessage = Repl(RCONMessage, "^receiver", Receiver.GetHumanReadableName());
	}

	RCONMessage = Repl(RCONMessage, "^executor", Executor.GetHumanReadableName());
	RCONMessage = Repl(RCONMessage, "^command", CommandName);
}

event OnFail(Rx_PRI Executor, optional Rx_PRI Receiver)
{
	if (Receiver == None)
	{
		Rx_Controller(Executor.Owner).CTextMessage("Failed to execute"@CommandName);
	}
	else
	{
		Rx_Controller(Executor.Owner).CTextMessage("Failed to execute"@CommandName@"on"@Receiver.GetHumanReadableName());
	}
}

function LogToRCON()
{

}

reliable server function Execute(Rx_PRI Executor, optional Rx_PRI Receiver)
{
	if (CanExecuteCommand(Executor))
	return;
	//Do something
}

function bool CanExecuteCommand(Rx_PRI Executor)
{
	if (`WorldInfoObject.NetMode == NM_Standalone)
		return true;

	return Executor.bAdmin;
}

DefaultProperties
{
	CommandName = "command"
	OnSelfCastText = "^executor executed: ^command."
	OnOtherCastText = "^executor executed: ^command on ^receiver."
}
