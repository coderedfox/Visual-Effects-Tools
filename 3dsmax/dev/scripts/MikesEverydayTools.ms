--encryptScript "MikesEverydayTools.ms"
--Show vrayextratex?
--Getpropnames	


rollout motools "Welcome to Mike's Tools"
(	
	--label motools1 "Welcome to Mike's Tools"
	label motools2 "Every day tools we all need"
	label motools3 "Version 131021"
	hyperLink motools4 "Help File @ mikeoakley.com" address:"http://www.mikeoakley.com/tips/mikes-everyday-tools/" align:#center
	--button motools2_load "load ini"
	
	--on motools2_load pressed do
	--(
		--load file ini if any
		--MikesEverydayToolsPath = sysInfo.tempdir + "MikesEverydayTools.ini"
	--)
	
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
	cam_OC_Select.text = cam_OC_Selected.name --renames button		
	CurrentCam = cam_OC_Select.text
	)
	)
	
	/*	Overscan Camera	*/	
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
	
	/*	Camera Name Fixer	*/	
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

rollout geotools "Geo Tools"
(	
	group "Random Wire Colors"
	(
		label geo1 "Select Objects to be re-colored" align:#center
		button geo_RanC_Button "Random Color"
		--checkbox  geo_RanC_obj "Include Geo" checked:true align:#left
		--checkbox  geo_RanC_cam "Include Camera" checked:false align:#center
		--checkbox  geo_RanC_helpers "Include Helpers" checked:false align:#right
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

rollout cartoolsBAD "TPS Car (Turbo Preset Setup) DISABLED"
(
	label cartoolsBAD "This REQUIRES Vray" align:#center
)
rollout cartools "TPS Car (Turbo Preset Setup)"
(
	label cartools2 "This is a simple and fast way to create" align:#center
	label cartools3 "a basic shader/elements for a Vehicle" align:#center
	group "Elements"
	(
		button  cartools_AutoElements_Button "Create Vray TPS Car Elements"
		checkbox cartools_removeall "Clear All Render Elements First?" checked:true align:#center
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
			button cartools_AutoMaterial_Button "Create Vray TPS Car Materials"
			
			checkbox cartools_Applyto "Apply to Selection?" checked:false align:#center 
			checkbox cartools_AutoApply "Auto Apply to Names?" checked:false align:#center
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
			FFXtools_LightingPoint.size = 20
			FFXtools_LightingPoint.box = true
			FFXlayer.addNode FFXtools_LightingPoint
						
			FFXtools_LightingPointTarget = Point ()
			FFXtools_LightingPointTarget.name = "con_FFXLightingTarget"
			FFXtools_LightingPointTarget.pos = [0,0,0] 
			FFXtools_LightingPointTarget.size = 20
			FFXtools_LightingPointTarget.box = true
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

				

try (closeRolloutFloater theNewFloater) catch()
theNewFloater = newRolloutFloater "Mike's Everyday Tools" 300 600
addRollout motools theNewFloater rolledUp:false
addRollout copytools theNewFloater rolledUp:false
addRollout cameratools theNewFloater rolledUp:true
addRollout geotools theNewFloater rolledUp:true
addRollout FFXtools theNewFloater rolledUp:true
if classof renderers.current != vr then (addRollout cartools theNewFloater rolledUp:true) else  (addRollout cartoolsBAD theNewFloater rolledUp:true)


