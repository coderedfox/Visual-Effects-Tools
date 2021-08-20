

	print "Starting Mikes_Everday_Tools www.mikeoakley.com "	
	try (if (renderers.current as string) == ((vray as string) + ":" + (vray as string)) then (Global RenderVray=true) else (Global RenderVray=false)) catch()
	
	try (if (renderers.current as string) == ((vray as string) + ":" + (vray as string)) then (Global RenderVray=true) else (Global RenderVray=false)) catch()
		
	rollout motools "Welcome to MOTools"
	(	
		label motools2 "Every day tools we all need"
		label motools3 "Version 131025"
		hyperLink motools4 "Help File @ mikeoakley.com" address:"http://www.mikeoakley.com/tips/mikes-everyday-tools/" align:#center

	)

	rollout copytools "Copy / Paste"
	(
		button copytools_Copy "Copy" offset: [-50,0]
			button copytools_NetCopy "Network Copy" offset: [20,-26] enabled:false
		button copytools_Paste "Paste" offset: [-50,0]
			button copytools_NetPaste "Network Paste" offset: [20,-26] enabled:false
		
		on copytools_Copy pressed do
		(
			if $ != undefined then 
			(
			savefolder = sysInfo.tempdir + "MikesEverydayTools\\"	
			savefilename = savefolder + "copytemp.max"
				
			makedir savefilename
			saveNodes $ savefilename
			)		
		)
			on copytools_Paste pressed do
		(
			savefilename = sysInfo.tempdir + "MikesEverydayTools\copytemp.max"
			mergemaxfile savefilename
		)
			
	)

	rollout cameratools "Camera Tools"
	(	
		--Picked Camera	
		fn camerafilter cam = superclassof cam== camera
		pickbutton cam_OC_Select "Select the Camera" width:140 filter:camerafilter	
		on cam_OC_Select picked cam do
		(
			if cam != undefined do
		(
		select cam
		cam_OC_Selected = 	cam
		cam_OC_Select.text = cam_OC_Selected.name
		CurrentCam = cam_OC_Select.text
		)
		)
		

		group "Overscan Camera"
		(		
			
			spinner cam_OC_Amount "OverScan amount %:" range:[0,100,20] type:#float enabled:false
			checkbox cam_OC_Animated "Animated Camera?" checked:false align:#center enabled:false
			button cam_OC_Button "Apply OverScan" enabled:false		
			
			--unlock controls
			on cam_OC_Select picked cam do
			(
				if cam != undefined do
				(
					cam_OC_Amount.enabled = true
					cam_OC_Animated.enabled = true
					cam_OC_Button.enabled = true
				)
			)	
			
			on cam_OC_Button pressed do
			(
				if cam != undefined do
				(
					cam_OC_New = copy cam_OC_Selected
					cam_OC_New.name = cam_OC_Selected.name + "_OverScan"
					if $ != undefined and cam_OC_Animated.state==false do
					(				
						--Generates new MM for Overscan
						OGLens= 0.5 * (GetRendApertureWidth() / tan(cam_OC_New.fov/2.0))
						LensDiff = OGLens * (cam_OC_Amount.value/100)	
						NewLens = OGLens - LensDiff		
						cam_OC_New.fov = 2.0* atan(GetRendApertureWidth()/NewLens*0.5)		
					)						
				)
				if $ != undefined and cam_OC_Animated.state==true do
				(
					with animate on
					for t = animationrange.start to animationrange.end do
					(
						at time t
						(
						cam_OC_New.fov=cam_OC_New.fov
						)
					)
					with animate on	
					for t = animationrange.start to animationrange.end do
					(
						at time t
						(
						OGLens= 0.5 * (GetRendApertureWidth() / tan(cam_OC_New.fov/2.0))
						LensDiff = OGLens * (cam_OC_Amount.value/100)	
						NewLens = OGLens - LensDiff		
						cam_OC_New.fov = 2.0* atan(GetRendApertureWidth()/NewLens*0.5)		
						)
					)					
					
				)				
				--Closes render window, applys change, openes it back up		
				renderSceneDialog.close()	
				renderWidth = renderWidth + (renderWidth*(cam_OC_Amount.value/100))
				renderHeight = renderHeight + (renderHeight*(cam_OC_Amount.value/100))	
				renderSceneDialog.open()
				select cam_OC_New	
				messagebox ("Your camera and render setting have be Over Scanned")	
			)		
		)
		
		group "Camera Name Fixer"
		(
			edittext cambase_show "Show"  enabled:false
			edittext cambase_shot "Shot"  enabled:false
			edittext cambase_scene "Scene"  enabled:false
			edittext cambase_version "Version"  enabled:false
			button cam_stanname_Button "Standardize name"  enabled:false
			on rename_them pressed do
			(
				base_name = "NOTCAMERA"
				rename_them.name = uniquename base_name.text
			)
		)
		
	)
	
	rollout sceneLayout "Scene Control and Layout"
(
	group "Create Master Node"
		(
			button CreateMasterNode_button "Create Scene Master Node"
			on CreateMasterNode_button pressed do
				(
					MasterLayer = LayerManager.newLayerFromName "MasterNode"									
					
					MOMaster_Node = Point ()
					MOMaster_Node.name = "MasterNode"
					MOMaster_Node.pos = [0,0,0] 
					MOMaster_Node.size = 50
					MOMaster_Node.box = true
					MOMaster_Node.constantscreensize = true
					MOMaster_Node.wirecolor = red
					MasterLayer.addNode MOMaster_Node
					
					fn theRootNode node = if isvalidnode node do (while node.parent != undefined do node = node.parent; node)					
					for i=1 to objects.count do
					(	
						TopNodeToLink = theRootNode objects[i]
						try(TopNodeToLink.parent = MOMaster_Node) catch ()
					)
				)
		)
		
	group "Correct Names"
		(
			button CorrectNames_button "Correct Selected Names"
			on CorrectNames_button pressed do
				(
					if $ != undefined do
					(
						for i in 1 to selection.count do
						(	
							if (superclassof selection[i]==GeometryClass and matchPattern selection[i].name pattern:"geo_*" !=true) do (selection[i].name = "geo_" + selection[i].name)
							if superclassof selection[i]==camera and matchPattern selection[i].name pattern:"cam_*" !=true do (selection[i].name = "cam_" + selection[i].name)
							if superclassof selection[i]==helper and matchPattern selection[i].name pattern:"con_*" !=true do (selection[i].name = "con_" + selection[i].name)
							if superclassof selection[i]==shape and matchPattern selection[i].name pattern:"con_*" !=true do (selection[i].name = "con_" + selection[i].name)
							if superclassof selection[i]==light and matchPattern selection[i].name pattern:"lgt_*" !=true do (selection[i].name = "lgt_" + selection[i].name)
							if superclassof selection[i]==SpacewarpObject and matchPattern selection[i].name pattern:"fx_*" !=true do (selection[i].name = "fx_" + selection[i].name)
							
						)
						messagebox "All selected items have tried to be renamed" title:"Correct Selected Names" beep:true			
					)					
				)
		)	
		
	group "Transform Locks"
	(
		button Geo_Lock "Lock" offset:[-115,0]
		button Geo_UnLock "Unlock" offset:[-65,-26]
		checkbox Geo_Locks_pos "Move" offset:[100,-22] checked:true  
		checkbox Geo_Locks_rot "Rotate" offset:[150,-20] checked:true
		checkbox Geo_Locks_scale "Scale" offset:[210,-20] checked:true 
		
		on Geo_Lock pressed do
		(
			if selection !=undefined do
			(
				local GeoTransLockArray = #{1,2,3,4,5,6,7,8,9}				
				if Geo_Locks_pos.checked==true do (append GeoTransLockArray 1;append GeoTransLockArray 2;append GeoTransLockArray 3)
				if Geo_Locks_rot.checked==true do (append GeoTransLockArray 4;append GeoTransLockArray 5;append GeoTransLockArray 6)
				if Geo_Locks_scale.checked==true do (append GeoTransLockArray 7;append GeoTransLockArray 8;append GeoTransLockArray 9)					
				setTransformLockFlags selection GeoTransLockArray
			)
		)
			
		on Geo_UnLock pressed do
		(
			if selection !=undefined do
			(
				local GeoTransLockArray = #{1,2,3,4,5,6,7,8,9}				
				if Geo_Locks_pos.checked==true do (deleteItem GeoTransLockArray 1;deleteItem GeoTransLockArray 2;deleteItem GeoTransLockArray 3)
				if Geo_Locks_rot.checked==true do (deleteItem GeoTransLockArray 4;deleteItem GeoTransLockArray 5;deleteItem GeoTransLockArray 6)
			if Geo_Locks_scale.checked==true do (deleteItem GeoTransLockArray 7;deleteItem GeoTransLockArray 8;deleteItem GeoTransLockArray 9)
				setTransformLockFlags selection GeoTransLockArray
			)
		)			
	)
)

	rollout geotools "Geo Tools"
	(	
		group "Random Wire Colors"
		(
			label geo1 "Select Objects to be re-colored" align:#center
			button geo_RanC_Button "Random Color"
			on geo_RanC_Button pressed do
			(
				if selection.count == 0 then messagebox "No objects selected !" title:"Warning" beep:true
				for i in 1 to selection.count do
				(
					objects[i].wirecolor = color (random 50 220)  (random 50 220) (random 50 220)
				)				
			)			
		)

		group "Random Object Selection"
		(
			spinner geo_RanSel_Amount "Select amount %:" range:[0,100,50] type:#integer
			button geo_RanSel_Button "Random Select"
			on geo_RanSel_Button pressed do
			(
				if selection.count == 0 then messagebox "No objects selected !" title:"Warning" beep:true
				for i in 1 to selection.count do
				(
					if (random 0 100 >= geo_RanSel_Amount.value) do (deselect(objects[i]))
				)
			)		
		)
	)


	--Check for Vray

	rollout cartools "TPS Car (Turbo Preset Setup) VRAY"
	(
	
		label cartools2 "This is a simple and fast way to create" align:#center
		label cartools3 "a basic shader/elements for a Vehicle" align:#center
				
		group "Elements"
		(

			button  cartools_AutoElements_Button "Create Vray TPS Car Elements" enabled:RenderVray
			checkbox cartools_removeall "Clear All Render Elements First?" checked:true align:#center enabled:RenderVray
			on cartools_AutoElements_Button pressed do	(
			
			cartools_RenderElements = maxOps.GetCurRenderElementMgr()
				
			if cartools_removeall.state==true do
			(
				cartools_RenderElements.removeallrenderelements()
			)
				renderSceneDialog.close()	
				--create AO maeterial
				cartools_AOMaterial = VrayDirt()
				cartools_AOMaterial.name = "AO"
				cartools_AOMaterial.radius = 200.00
				cartools_AOMaterial.occluded_color = blue
				cartools_AOMaterial.unoccluded_color = red
				cartools_AOMaterial.radius = 200.00	
				
				--create fall off material
				cartools_UpDownMaterial = falloff()
				cartools_UpDownMaterial.name = "UpDownPass"
				cartools_UpDownMaterial.color1 = red
				cartools_UpDownMaterial.color2 = blue
				cartools_UpDownMaterial.direction = 9		
					
				--create Render Elements
				cartools_RenderElements.addrenderelement (VRayDiffuseFilter())
				cartools_RenderElements.addrenderelement (VRayLighting())
				cartools_RenderElements.addrenderelement (VRayNormals())
				cartools_RenderElements.addrenderelement (VRayReflection())
				cartools_RenderElements.addrenderelement (VRayRefraction())
				cartools_RenderElements.addrenderelement (VRayShadows())
				cartools_RenderElements.addrenderelement (VRaySpecular())
				cartools_RenderElements.addrenderelement (VRayNormals())
				cartools_RenderElements.addrenderelement (VRayZDepth invert_zdepth:false)
				cartools_RenderElements.addrenderelement (VRayZDepth elementname:((VRayZDepth as string)+ "_Invert") invert_zdepth:true)
				cartools_RenderElements.addrenderelement (VrayExtraTex elementname:"AO" texture:cartools_AOMaterial)
				cartools_RenderElements.addrenderelement (VrayExtraTex elementname:"UpDown" texture:cartools_UpDownMaterial)
				cartools_RenderElements.addrenderelement (MultiMatteElement elementname:("MultiMatte_1_2_3") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:1 G_gbufID:2 B_gbufID:3)
				cartools_RenderElements.addrenderelement (MultiMatteElement elementname:("MultiMatte_4_5_6") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:4 G_gbufID:5 B_gbufID:6)
				cartools_RenderElements.addrenderelement (MultiMatteElement elementname:("MultiMatte_7_8_9") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:7 G_gbufID:8 B_gbufID:9)
				cartools_RenderElements.addrenderelement (MultiMatteElement elementname:("MultiMatte_10_11_12") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:10 G_gbufID:11 B_gbufID:12)
				cartools_RenderElements.addrenderelement (MultiMatteElement elementname:("MultiMatte_13_14_15") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:13 G_gbufID:14 B_gbufID:15)
				renderSceneDialog.open()
					
				if cartools_removeall.state==true do (messagebox ("Render elements have been cleared and rebuilt"))
				if cartools_removeall.state==false do (messagebox ("Render elements have been Added")) 	

				)
			)
			group "Materials"
			(
				button cartools_AutoMaterial_Button "Create Vray TPS Car Materials" enabled:RenderVray
				
				checkbox cartools_Applyto "Apply to Selection?" checked:false align:#center enabled:RenderVray
				checkbox cartools_AutoApply "Auto Apply to Names?" checked:false align:#center enabled:RenderVray
				on cartools_AutoMaterial_Button pressed do
				(
					cartools_StandardVrayCar = multimaterial()
					cartools_StandardVrayCar.name = "TPSVrayCar"
					cartools_StandardVrayCar.numsubs = 15
				
					cartools_StandardVrayCar[1] = VrayCarPaintMtl default: standard name:"Paint" effectsChannel:1 base_color:red
					cartools_StandardVrayCar[2] = VrayMtl default: standard name:"Plastic Paint" effectsChannel:2 Diffuse:gray Reflection:gray
					cartools_StandardVrayCar[3] = VrayMtl default: standard name:"Chrome" effectsChannel:3 Diffuse:white Reflection:white 
					cartools_StandardVrayCar[4] = VrayMtl default: standard name:"Dark Plastic" effectsChannel:4 Diffuse:gray Reflection:gray
					cartools_StandardVrayCar[5] = VrayMtl default: standard name:"Dark Rubber" effectsChannel:5 Diffuse:black Reflection:gray
					cartools_StandardVrayCar[6] = VrayMtl default: standard name:"License Plate" effectsChannel:6 Diffuse:green
					cartools_StandardVrayCar[7] = VrayMtl default: standard name:"Windows" effectsChannel:7 Diffuse:black Refraction:white Refraction_ior:1.61
					cartools_StandardVrayCar[8] = VrayMtl default: standard name:"Mirrors" effectsChannel:8 Diffuse:black Reflection:white
					cartools_StandardVrayCar[9] = VrayMtl default: standard name:"Internal" effectsChannel:9 Diffuse:yellow
					cartools_StandardVrayCar[10] = VrayMtl default: standard name:"Head Light" effectsChannel:10 Diffuse:white
					cartools_StandardVrayCar[11] = VrayMtl default: standard name:"Running Lights" effectsChannel:11 Diffuse:orange
					cartools_StandardVrayCar[12] = VrayMtl default: standard name:"Break Light" effectsChannel:12 Diffuse:red
					cartools_StandardVrayCar[13] = VrayMtl default: standard name:"Tires" effectsChannel:13 Diffuse:black Reflection:gray
					cartools_StandardVrayCar[14] = VrayMtl default: standard name:"Rims" effectsChannel:14 Diffuse:gray Reflection:gray
					cartools_StandardVrayCar[15] = VrayMtl default: standard name:"Break" effectsChannel:15 Diffuse:brown			
					setMeditMaterial 1 cartools_StandardVrayCar
					
					cartools_StandardColorCar = multimaterial()
					cartools_StandardColorCar.name = "TPSColorCar"
					cartools_StandardColorCar.numsubs = 16
					
					cartools_StandardColorCar[1] = Standardmaterial default: standard name:"Paint" effectsChannel:1 Diffuse:(color 255 0 0)
					cartools_StandardColorCar[2] = Standardmaterial default: standard name:"Plastic Paint" effectsChannel:2 Diffuse:(color 255 127 0)
					cartools_StandardColorCar[3] = Standardmaterial default: standard name:"Chrome" effectsChannel:3 Diffuse:(color 255 255 0)
					cartools_StandardColorCar[4] = Standardmaterial default: standard name:"Dark Plastic" effectsChannel:4 Diffuse:(color 127 255 0)
					cartools_StandardColorCar[5] = Standardmaterial default: standard name:"Dark Rubber" effectsChannel:5 Diffuse:(color 0 255 0)
					cartools_StandardColorCar[6] = Standardmaterial default: standard name:"License Plate" effectsChannel:6 Diffuse:(color 0 255 127)
					cartools_StandardColorCar[7] = Standardmaterial default: standard name:"Windows" effectsChannel:7 Diffuse:(color 0 255 255)
					cartools_StandardColorCar[8] = Standardmaterial default: standard name:"Mirrors" effectsChannel:8 Diffuse:(color 0 127 255)
					cartools_StandardColorCar[9] = Standardmaterial default: standard name:"Internal" effectsChannel:9 Diffuse:(color 0 0 255)
					cartools_StandardColorCar[10] = Standardmaterial default: standard name:"Head Light" effectsChannel:10 Diffuse:(color 127 0 255)
					cartools_StandardColorCar[11] = Standardmaterial default: standard name:"Running Lights" effectsChannel:11 Diffuse:(color 127 0 127)
					cartools_StandardColorCar[12] = Standardmaterial default: standard name:"Break Light" effectsChannel:12 Diffuse:(color 127 127 0)
					cartools_StandardColorCar[13] = Standardmaterial default: standard name:"Tires" effectsChannel:13 Diffuse:(color 0 0 127)
					cartools_StandardColorCar[14] = Standardmaterial default: standard name:"Rims" effectsChannel:14 Diffuse:(color 127 255 127 )
					cartools_StandardColorCar[15] = Standardmaterial default: standard name:"Break" effectsChannel:15 Diffuse:(color 127 127 255)		
					cartools_StandardColorCar[16] = Standardmaterial default: standard name:"NoMaterialYet" effectsChannel:0 Diffuse:(color 10 10 10)	
					setMeditMaterial 2 cartools_StandardColorCar
					
					if cartools_Applyto.state==true do
					(
						for i in 1 to selection.count do
						(
							objects[i].material = cartools_StandardColorCar
							--auto name
							if cartools_AutoApply.state==true do 
							(
								for i in $*body* do (i.material = cartools_StandardColorCar[1])
								for i in $*plastic* do (i.material = cartools_StandardColorCar[2])
								for i in $*chrome* do (i.material = cartools_StandardColorCar[3])
								for i in $*license* do (i.material = cartools_StandardColorCar[6])
								for i in $*winow* do (i.material = cartools_StandardColorCar[7])
								for i in $*mirror* do (i.material = cartools_StandardColorCar[8])
								for i in $*light* do (i.material = cartools_StandardColorCar[10])
								for i in $*blinker* do (i.material = cartools_StandardColorCar[11])
								for i in $*break* do (i.material = cartools_StandardColorCar[12])
								for i in $*tire* do (i.material = cartools_StandardColorCar[13])
								for i in $*rim* do (i.material = cartools_StandardColorCar[14])
							)
						)	
					)	
				)			
			)
			
	group "Correct Object Pivots"
		(
			button Initilize_button "RE_Center"

			on Initilize_button pressed do
				(
					WorldAlignPivot $
					$.pivot = [0,0,0]
				)			
		)
	
	group "Create Car Rig"
	(
		button cartools_CreateRig " Create Car Rig"
		on cartools_CreateRig pressed do
			(	
				if TPSConLayer == undefined do
				(
					TPSConLayer = LayerManager.newLayerFromName "con_veh_TPS"
				)
				
				CarPointMaster = Point ()
				CarPointMaster.name = "con_veh_TPSCar_Master"
				CarPointMaster.pos = [0,0,0] 
				CarPointMaster.size = 50
				CarPointMaster.box = true
				CarPointMaster.wirecolor = White					
				TPSConLayer.addNode CarPointMaster
				
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
				TPSConLayer.addNode CarSplineMain
				
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
				TPSConLayer.addNode CarSplineBody
				
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
				TPSConLayer.addNode CarSplineFAxle
				
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
				TPSConLayer.addNode CarSplineRAxle

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
				TPSConLayer.addNode CarSplineSteer
				
				CarSplineTireFR = circle pos:[0,0,0]
				CarSplineTireFR.name= "con_veh_TPSCar_TireFR"
				CarSplineTireFR.radius = 15
				CarSplineTireFR.rotation = quat 0 -0.707107 0 0.707107
				CarSplineTireFR.pos = [-32,-66,13]
				TPSConLayer.addNode CarSplineTireFR
				
				CarSplineTireFL = circle pos:[0,0,0]
				CarSplineTireFL.name= "con_veh_TPSCar_TireFL"
				CarSplineTireFL.radius = 15
				CarSplineTireFL.rotation = quat 0 -0.707107 0 0.707107
				CarSplineTireFL.pos = [32,-66,13]
				TPSConLayer.addNode CarSplineTireFL
				
				CarSplineTireRR = circle pos:[0,0,0]
				CarSplineTireRR.name= "con_veh_TPSCar_TireRR"
				CarSplineTireRR.radius = 15
				CarSplineTireRR.rotation = quat 0 -0.707107 0 0.707107
				CarSplineTireRR.pos = [-32,47,13]
				TPSConLayer.addNode CarSplineTireRR
				
				CarSplineTireRL = circle pos:[0,0,0]
				CarSplineTireRL.name= "con_veh_TPSCar_TireRL"
				CarSplineTireRL.radius = 15
				CarSplineTireRL.rotation = quat 0 -0.707107 0 0.707107
				CarSplineTireRL.pos =[32,47,13]
				TPSConLayer.addNode CarSplineTireRL
				
				CarSplineMain.parent = CarPointMaster
				CarSplineBody.parent = CarSplineMain
				CarSplineFAxle.parent = CarSplineBody
				CarSplineRAxle.parent = CarSplineBody
				CarSplineSteer.parent = CarSplineBody
				
				CarSplineTireFR.parent = CarSplineMain
				CarSplineTireFL.parent = CarSplineMain
				CarSplineTireRR.parent = CarSplineMain
				CarSplineTireRL.parent = CarSplineMain
			)
		)
		
		
	group "Turn Table"
		(
			button cartools_TurnTable_Button "Create Turn Table" 
			on cartools_TurnTable_Button pressed do
			(			
				--create rig
				animationRange = interval 1 600
				TPS_TurnTable_Path = circle pos:[0,0,165]	
				TPS_TurnTable_Path.name= "con_TPS_TurnTable_Path"	
				TPS_TurnTable_Path.radius = 400	
				TPS_TurnTable_cam = Targetcamera fov:45
				TPS_TurnTable_cam.target= Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
					TPSPC = Path_Constraint ()	
				TPS_TurnTable_cam.position.controller = TPSPC	
				TPSPC.path = TPS_TurnTable_Path
				
				--create LightsRig
				TPS_TurnTable_StandardColor = Standardmaterial()
				TPS_TurnTable_StandardColor.name = "TPSTurnTable"
				
				TPS_TurnTable_GradientRamp = Gradient_Ramp ()
				TPS_TurnTable_GradientRamp.name = "TPSHorizon"
				TPS_TurnTable_GradientRamp.coordinates.mappingType = 1
				TPS_TurnTable_GradientRamp.coordinates.mapping = 0
				TPS_TurnTable_GradientRamp.coordinates.W_Angle = 90
				--TPS_TurnTable_GradientRamp.gradient_ramp.flag__1= color [0,0,0]	
				
				TPS_TurnTable_StandardColor.diffuseMap = TPS_TurnTable_GradientRamp

				setMeditMaterial 3 TPS_TurnTable_StandardColor
			)
			
		)

	)

	rollout FFXtools "Fume FX Tools"
	(
		group "File Managment"	
		(
			--dropdownlist FFX_FM_List "PreSets" items:#("1/2", "1/4", "1/8", "1/16")
			button FFX_FFX_Button " Set FFX" pos: [20,25] 
			radiobuttons FFX_FM_locations1 labels:#("Local", "Network") pos: [90,25] 
			button FFX_WAVE_Button "Set Wave" pos: [20,50] 
			radiobuttons FFX_FM_locations2 labels:#("Local", "Network") pos: [90,50] 
			button FFX_NSIM_Button "Set N-Sim" pos: [20,75] 
			radiobuttons FFX_FM_locations3 labels:#("Local", "Network") pos: [90,75] 
			

			button FFX_Copy2Network_Button "Copy to Network" pos: [40,100] enabled:false
			button FFX_Copy2Local_Button "Copy to Local" pos: [190,100] enabled:false
					
			on FFX_FFX_Button pressed do
			(
				FFXMainPath = sysInfo.tempdir + "FumeFX\\FumeFX_" + getFilenameFile maxFilename;
				makeDir FFXMainPath
				
				if (FFX_FM_locations1.state == 1) then 
					(
						FFXPath = FFXMainPath + "\\FFX"
						makeDir FFXPath
					) else ()
			)				
					
			on FFX_WAVE_Button pressed do
			(
				FFXMainPath = sysInfo.tempdir + "FumeFX\\FumeFX_" + getFilenameFile maxFilename;
				makeDir FFXMainPath
				if (FFX_FM_locations2.state == 1) then 
					(
						FFXPath = FFXMainPath + "\\Wave"
						makeDir FFXPath
					) else ()
				)
				
			on FFX_NSIM_Button pressed do
			(
				FFXMainPath = sysInfo.tempdir + "FumeFX\\FumeFX_" + getFilenameFile maxFilename;
				makeDir FFXMainPath
				if (FFX_FM_locations1.state == 1) then 
					(
						FFXPath = FFXMainPath + "\\NSim"
						makeDir FFXPath
					) else ()
			)
			
			on FFX_Copy2Network_Button pressed do
			(
			
			)
			
			on FFX_Copy2Local_Button pressed do
			(
			
			)
			
		)
		
		group "lighting system"	
		(
			button FFXtools_Lighting_Button "Create FFX_Lighting"
			on FFXtools_Lighting_Button pressed do
			(
				
				FFXlayer = LayerManager.newLayerFromName "FFX_Lighting"
				FFXlayer = LayerManager.getLayerFromName "FFX_Lighting"
				
				FFXtools_LightingPoint = Point ()
				FFXtools_LightingPoint.name = "con_FFXLighting"
				FFXtools_LightingPoint.pos = [0,0,100] 
				FFXtools_LightingPoint.size = 50
				FFXtools_LightingPoint.box = true
				FFXtools_LightingPoint.wirecolor = White
				FFXlayer.addNode FFXtools_LightingPoint
							
				FFXtools_LightingPointTarget = Point ()
				FFXtools_LightingPointTarget.name = "con_FFXLightingTarget"
				FFXtools_LightingPointTarget.pos = [0,0,0] 
				FFXtools_LightingPointTarget.size = 20
				--FFXtools_LightingPointTarget.box = true
				FFXtools_LightingPointTarget.wirecolor = gray
				FFXlayer.addNode FFXtools_LightingPointTarget
				FFXtools_LightingPointTarget.parent = FFXtools_LightingPoint
				
				--FFXlayer.addnode FFXtools_LightingPoint
				
				FFXtools_LightinglightRED = targetSpot ()
				FFXtools_LightinglightRED.name = "FFXLighting_RED"
				FFXtools_LightinglightRED.rgb = RED
				FFXtools_LightinglightRED.baseObject.castShadows = true
				FFXtools_LightinglightRED.multiplier = 1.0		
				FFXtools_LightinglightRED.pos = [100,0,100] 
				FFXtools_LightinglightRED.target= (targetObject pos:FFXtools_LightingPointTarget.pos)
				FFXtools_LightinglightRED.parent = FFXtools_LightingPoint
				FFXtools_LightinglightRED.target.parent = FFXtools_LightingPointTarget
				FFXtools_LightinglightRED.wirecolor = red
				FFXlayer.addNode FFXtools_LightinglightRED
				FFXlayer.addNode FFXtools_LightinglightRED.target
							
				FFXtools_LightinglightGREEN = targetSpot ()
				FFXtools_LightinglightGREEN.name = "FFXLighting_GREEN"
				FFXtools_LightinglightGREEN.rgb = GREEN
				FFXtools_LightinglightGREEN.baseObject.castShadows = true
				FFXtools_LightinglightGREEN.multiplier = 1.0		
				FFXtools_LightinglightGREEN.pos = [-48,87,100] 
				FFXtools_LightinglightGREEN.target= (targetObject pos:FFXtools_LightingPointTarget.pos)
				FFXtools_LightinglightGREEN.parent = FFXtools_LightingPoint
				FFXtools_LightinglightGREEN.target.parent = FFXtools_LightingPointTarget
				FFXtools_LightinglightGREEN.wirecolor = green
				FFXlayer.addNode FFXtools_LightinglightGREEN
				FFXlayer.addNode FFXtools_LightinglightGREEN.target
				
				FFXtools_LightinglightBLUE = targetSpot ()
				FFXtools_LightinglightBLUE.name = "FFXLighting_BLUE"
				FFXtools_LightinglightBLUE.rgb = BLUE
				FFXtools_LightinglightBLUE.baseObject.castShadows = true
				FFXtools_LightinglightBLUE.multiplier = 1.0		
				FFXtools_LightinglightBLUE.pos = [-53,-84,100] 
				FFXtools_LightinglightBLUE.target= (targetObject pos:FFXtools_LightingPointTarget.pos)
				FFXtools_LightinglightBLUE.parent = FFXtools_LightingPoint
				FFXtools_LightinglightBLUE.target.parent = FFXtools_LightingPointTarget
				FFXtools_LightinglightBLUE.wirecolor = Blue
				FFXlayer.addNode FFXtools_LightinglightBLUE
				FFXlayer.addNode FFXtools_LightinglightBLUE.target
			)	
		)
	)
	
		
	
	rollout MOSettings "Settings"
	(		
		label MOSettings_lab1 "MikesEverydayTools.ini" align:#left
		Button MOSettings_INIFile "Not Found" tooltip:""  align:#left
		label MOSettings_lab2 "Network CopyPaste folder" align:#left 
		Button MOSettings_CopyPaste "Set network CopyPaste folder" align:#left enabled:false 
		label MOSettings_lab3 "Network FFX Folder" align:#left 
		Button MOSettings_FFX "Set Network FFX Folder" align:#left enabled:false
		
		on MOSettings_INIFile pressed do
		(
			MOSettings_LoadFile = getOpenFileName filename:"MikesEverydayTools.ini "types:"MikesEverydayTools(*.ini)" caption:"Looking for MikesEverydayTools.ini"
			MOSettings_INIFile.text = MOSettings_LoadFile
			MOSettings_INIFile.tooltip = MOSettings_LoadFile
			
			MOSettings_CopyPaste.enabled = true
			MOSettings_FFX.enabled = true
			
			MOSettings_CopyPastePath = getINISetting MOSettings_LoadFile "Network Copy/Paste" "Path"
			MOSettings_CopyPaste.text = MOSettings_CopyPastePath
			MOSettings_CopyPaste.tooltip = MOSettings_CopyPastePath
			
			MOSettings_FumeFXPath = getINISetting MOSettings_LoadFile "Network FumeFX" "Path"
			MOSettings_FFX.text = MOSettings_FumeFXPath
			MOSettings_FFX.tooltip = MOSettings_FumeFXPath
			
		)		
		
		on MOSettings_CopyPaste pressed do
		(
			MOSettings_CopyPastePath = getSavePath caption:"Set network CopyPaste folder"
			if MOSettings_CopyPastePath != undefined do
			(
				MOSettings_CopyPasteFile = setINISetting MOSettings_LoadFile "Network Copy/Paste" "Path" MOSettings_CopyPastePath			
				MOSettings_CopyPaste.text = MOSettings_CopyPastePath
				MOSettings_CopyPaste.tooltip = MOSettings_CopyPastePath
			)		
		)
		
			on MOSettings_FFX pressed do
		(
			MOSettings_FFXPath = getSavePath caption:"Set Network FFX Folder."
			if MOSettings_FFXPath != undefined do
			(
				MOSettings_FFXPathFile = setINISetting MOSettings_LoadFile "Network Copy/Paste" "Path" MOSettings_FFXPath			
				MOSettings_FFX.text = MOSettings_FFXPath
				MOSettings_FFX.tooltip = MOSettings_FFXPath
			)				
		)

	--setINISetting MOSettings_LoadFile "MOTools" "NetworkCopyPaste" MOSettings_CopyPaste.text
		--MOSettings_FFXFile = getINISetting MOSettings_LoadFile "FumeFX" "SetWave"	
	)
	
	try (closeRolloutFloater theNewFloater) catch()	
	
	theNewFloater = newRolloutFloater "Mike's Everyday Tools" 300 800
	addRollout motools theNewFloater rolledUp:false
	addRollout copytools theNewFloater rolledUp:false
	addRollout cameratools theNewFloater rolledUp:true
	addRollout sceneLayout theNewFloater rolledUp:true
	addRollout geotools theNewFloater rolledUp:true
	addRollout FFXtools theNewFloater rolledUp:true
	addRollout cartools theNewFloater rolledUp:true
	addRollout MOSettings theNewFloater rolledUp:true