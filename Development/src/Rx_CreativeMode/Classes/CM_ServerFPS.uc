class CM_ServerFPS extends ReplicationInfo;

var repnotify float ServerFPS;
var float PrivateServerFPS;
var float PrivateServerDeltaTime;
var repnotify float ServerDeltaTime;

replication
{
	if (bNetDirty || bNetInitial)
		ServerFPS, ServerDeltaTime;
}

simulated function PostBeginPlay()
{
	setTimer(1, true, 'CollectData');
}

function CollectData()
{	
	if (`WorldInfoObject.NetMode != NM_DedicatedServer)
		return;

	ServerFPS = PrivateServerFPS;
	ServerDeltaTime = PrivateServerDeltaTime;
}

function OnTick(float DeltaTime)
{
	CalcServerFPS(DeltaTime);
}

reliable server function CalcServerFPS(float DeltaTime)
{
	if(`WorldInfoObject.NetMode == NM_DedicatedServer)
	{
		PrivateServerFPS = 1 / DeltaTime;
		PrivateServerDeltaTime = DeltaTime;
	}
}
