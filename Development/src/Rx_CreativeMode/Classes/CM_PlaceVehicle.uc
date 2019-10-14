class CM_PlaceVehicle extends Actor;

var private vector2D AS2DRotPlane;
var private float ASCurrentAngle;
var private int StartingYaw;
var Material Mat;
var class<Rx_Vehicle> MyVehicle;
var SkeletalMeshComponent MySVehicleMesh;

simulated function SetVehicle(class<Rx_Vehicle> Vehicle)
{
	MyVehicle = Vehicle;
	MySVehicleMesh.SetSkeletalMesh(Vehicle.default.Mesh.SkeletalMesh);
	`log(Vehicle.default.Mesh.SkeletalMesh);
}

simulated function class<Rx_Vehicle> GetVehicle()
{
	return MyVehicle;
}

simulated function SetMaterials()
{
	local int i;

	For(i = 0; i < 6; i++)
	{
		MySVehicleMesh.SetMaterial(i, Mat);
	}
}

simulated function AdjustRotation(float X, float Y) // Borrowed from airstrike stuffs. Move mouse in a circle for best results.
{
	local rotator r;
	AS2DRotPlane.X += X * 0.001f;
	AS2DRotPlane.Y += Y * 0.001f;

	ASCurrentAngle = Atan2(AS2DRotPlane.Y, AS2DRotPlane.X);

	// push X and Y back on to circle
	AS2DRotPlane.X = Cos(ASCurrentAngle);
	AS2DRotPlane.Y = Sin(ASCurrentAngle);

	ASCurrentAngle *= RadToDeg;
	ASCurrentAngle -= 90.f;
	r.Yaw = StartingYaw - (ASCurrentAngle * DegToUnrRot);
	SetRotation(r);
}

DefaultProperties
{
	Begin Object Class=SkeletalMeshComponent Name=SVehicleMesh
		RBChannel=RBCC_Vehicle
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE,Vehicle=TRUE)
		BlockActors=true
		BlockZeroExtent=true
		BlockRigidBody=true
		BlockNonzeroExtent=true
		CollideActors=true
		bForceDiscardRootMotion=true
		bUseSingleBodyPhysics=1
		bNotifyRigidBodyCollision=true
		ScriptRigidBodyCollisionThreshold=250.0
	End Object
	MySVehicleMesh = SVehicleMesh
	Components.Add(SVehicleMesh)

	Mat = Material'Rx_CreativeModeContent.Materials.M_Holo'

	RemoteRole          = ROLE_SimulatedProxy
	bBlocksNavigation   = false
	bBlocksTeleport     = false
	BlockRigidBody      = false
	bCollideActors      = true
	bBlockActors        = false
	bStatic             = false
	bWorldGeometry      = true
	bMovable            = true
	bAlwaysRelevant     = true
	bGameRelevant       = true
	bOnlyDirtyReplication = True
	
	NetUpdateFrequency = 10.0
}