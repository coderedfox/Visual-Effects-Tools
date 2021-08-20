	TPSConLayer = LayerManager.newLayerFromName "con_veh_TPS"
	TPSConLayer.current = true

	CarPointMaster = Point ()
	CarPointMaster.name = "con_veh_TPSCar_Master"
	CarPointMaster.pos = [0,0,0] 
	CarPointMaster.size = 50
	CarPointMaster.box = true
	CarPointMaster.wirecolor = White
	
	CarSplineMain = SplineShape pos:[0,0,0]
	CarSplineMain.name= "con_veh_TPSCar_Main"
	addNewSpline CarSplineMain
	addKnot CarSplineMain 1 #corner #line [40,110,0]
	addKnot CarSplineMain 1 #corner #line [40,-85,0]
	addKnot CarSplineMain 1 #corner #line [70,-85,0]
	addKnot CarSplineMain 1 #corner #line [0,-170,0]
	addKnot CarSplineMain 1 #corner #line [-70,-85,0]
	addKnot CarSplineMain 1 #corner #line [-40,-85,0]
	addKnot CarSplineMain 1 #corner #line [-40,110,0]
	close CarSplineMain 1
	updateShape CarSplineMain
	
	CarSplineBody = SplineShape pos:[0,0,0]
	CarSplineBody.name= "con_veh_TPSCar_Body"
	addNewSpline CarSplineBody
	addKnot CarSplineBody 1 #corner #line [0,100,42]
	addKnot CarSplineBody 1 #corner #line [0,62,45]
	addKnot CarSplineBody 1 #corner #line [0,40,62]
	addKnot CarSplineBody 1 #corner #line [0,-20,62]
	addKnot CarSplineBody 1 #corner #line [0,-50,45]
	addKnot CarSplineBody 1 #corner #line [0,-115,35]
	addKnot CarSplineBody 1 #corner #line [0,-115,7]
	addKnot CarSplineBody 1 #corner #line [0,-83.372,7]
	--addKnot CarSplineBody 1 #corner #line [0,-66,-4]
	addKnot CarSplineBody 1 #corner #line [0,-50.375,7]
	addKnot CarSplineBody 1 #corner #line [0,31.523,7]
	--addKnot CarSplineBody 1 #corner #line [0,50,-4]
	addKnot CarSplineBody 1 #corner #line [0,63.996,7]
	addKnot CarSplineBody 1 #corner #line [0,100,10]
	close CarSplineBody 1
	updateShape CarSplineBody
	
	CarSplineFAxle = SplineShape pos:[0,-120,13]
	CarSplineFAxle.name= "con_veh_TPSCar_FAxle"
	addNewSpline CarSplineFAxle
	addKnot CarSplineFAxle 1 #corner #line [0,-120,-5]
	addKnot CarSplineFAxle 1 #corner #line [-8,-120,7]
	addKnot CarSplineFAxle 1 #corner #line [-4,-120,7]	
	addKnot CarSplineFAxle 1 #corner #line [-4,-120,19]
	addKnot CarSplineFAxle 1 #corner #line [-8,-120,19]
	addKnot CarSplineFAxle 1 #corner #line [0,-120,30]	
	addKnot CarSplineFAxle 1 #corner #line [8,-120,19]
	addKnot CarSplineFAxle 1 #corner #line [4,-120,19]
	addKnot CarSplineFAxle 1 #corner #line [4,-120,7]
	addKnot CarSplineFAxle 1 #corner #line [4,-120,7]	
	addKnot CarSplineFAxle 1 #corner #line [8,-120,7]	
	close CarSplineFAxle 1
	updateShape CarSplineFAxle
	
	CarSplineRAxle = SplineShape pos:[0,110,13]
	CarSplineRAxle.name= "con_veh_TPSCar_RAxle"
	addNewSpline CarSplineRAxle
	addKnot CarSplineRAxle 1 #corner #line [0,110,-5]
	addKnot CarSplineRAxle 1 #corner #line [-8,110,7]
	addKnot CarSplineRAxle 1 #corner #line [-4,110,7]	
	addKnot CarSplineRAxle 1 #corner #line [-4,110,19]
	addKnot CarSplineRAxle 1 #corner #line [-8,110,19]
	addKnot CarSplineRAxle 1 #corner #line [0,110,30]	
	addKnot CarSplineRAxle 1 #corner #line [8,110,19]
	addKnot CarSplineRAxle 1 #corner #line [4,110,19]
	addKnot CarSplineRAxle 1 #corner #line [4,110,7]
	addKnot CarSplineRAxle 1 #corner #line [4,110,7]	
	addKnot CarSplineRAxle 1 #corner #line [8,110,7]	
	close CarSplineRAxle 1
	updateShape CarSplineRAxle

	CarSplineSteer = SplineShape pos:[0,-130,0]
	CarSplineSteer.name= "con_veh_TPSCar_Steer"
	addNewSpline CarSplineSteer
	addKnot CarSplineSteer 1 #corner #line [-32,-130,0]
	addKnot CarSplineSteer 1 #corner #line [-12,-122,0]
	addKnot CarSplineSteer 1 #corner #line [-12,-126,0]
	addKnot CarSplineSteer 1 #corner #line [12,-126,0]
	addKnot CarSplineSteer 1 #corner #line [12,-122,0]
	addKnot CarSplineSteer 1 #corner #line [32,-130,0]	
	addKnot CarSplineSteer 1 #corner #line [12,-138,0]
	addKnot CarSplineSteer 1 #corner #line [12,-134,0]
	addKnot CarSplineSteer 1 #corner #line [-12,-134,0]	
	addKnot CarSplineSteer 1 #corner #line [-12,-138,0]	
	close CarSplineSteer 1
	updateShape CarSplineSteer
	
	CarSplineTireFR = circle pos:[0,0,0]
	CarSplineTireFR.name= "con_veh_TPSCar_TireFR"
	CarSplineTireFR.radius = 15
	CarSplineTireFR.rotation = quat 0 -0.707107 0 0.707107
	CarSplineTireFR.pos = [-32,-66,13]
	
	CarSplineTireFL = circle pos:[0,0,0]
	CarSplineTireFL.name= "con_veh_TPSCar_TireFL"
	CarSplineTireFL.radius = 15
	CarSplineTireFL.rotation = quat 0 -0.707107 0 0.707107
	CarSplineTireFL.pos = [32,-66,13]
	
	CarSplineTireRR = circle pos:[0,0,0]
	CarSplineTireRR.name= "con_veh_TPSCar_TireRR"
	CarSplineTireRR.radius = 15
	CarSplineTireRR.rotation = quat 0 -0.707107 0 0.707107
	CarSplineTireRR.pos = [-32,47,13]
	
	CarSplineTireRL = circle pos:[0,0,0]
	CarSplineTireRL.name= "con_veh_TPSCar_TireRL"
	CarSplineTireRL.radius = 15
	CarSplineTireRL.rotation = quat 0 -0.707107 0 0.707107
	CarSplineTireRL.pos =[32,47,13]
	
	CarSplineMain.parent = CarPointMaster
	CarSplineBody.parent = CarSplineMain
	CarSplineFAxle.parent = CarSplineBody
	CarSplineRAxle.parent = CarSplineBody
	CarSplineSteer.parent = CarSplineBody
	
	CarSplineTireFR.parent = CarSplineMain
	CarSplineTireFL.parent = CarSplineMain
	CarSplineTireRR.parent = CarSplineMain
	CarSplineTireRL.parent = CarSplineMain
	
	
	
	