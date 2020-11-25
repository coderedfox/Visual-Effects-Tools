macroScript MOTools
category:"MOTools"
buttonText:"MOTools"
toolTip:"MOTools : Every day tools we all need"
icon: #("motools",1)

(
	try (closeRolloutFloater MOTools) catch()	
	/* Globals */
	
	Global MOTools_Version = ("Version : "+ "20150130")
	Global MOTools_RenderElementsMgr = maxOps.GetCurRenderElementMgr()
	Global MOTools_copytools_NetCopyLoc = ""
	Global MOTools_copytools_NetMtlCopyLoc = ""
	Global MOTools_CheckforVray VrayTrue = "false"
	Global MOTools_CheckforMtlEditor MtlEditorType = MatEditor.mode
	Global MOTools_startframe = animationrange.start
	Global MOTools_endframe = animationrange.end
	Global MOTools_ColorsRandom = ()
	
	
	/* Functions Start  include "MOTools_Functions.ms" */
	fn MOTools_CheckforVray VrayTrue = (if (renderers.current as string) == ((vray as string) + ":" + (vray as string)) then (True) else (false));

	fn MOTools_GetPathFumeLocal location = ("C:\\Temp\\FumeFX_Cache\\FumeFX_" + getFilenameFile maxFilename + "\\default");

	fn MOTools_GetPathFumeNetwork location = (maxfilepath + "\\FumeFX_Cache\\" + getFilenameFile maxFilename +"\\default");	
	
	fn MOTools_ColorsRandom color = (
		color (random 10 250) (random 10 250) (random 10 250)
	)	
		
	fn MOTools_ColorsRandomBWs color = (
		RandomColorVar = (random 50 205);
		color (RandomColorVar) (RandomColorVar) (RandomColorVar)
	)

	fn MOTools_ColorsRandomPastels color = (
		color (random 150 250)  (random 150 250) (random 150 250)
	)
		
	fn MOTools_ColorsRandomHighs color = (
		color (random 200 250)  (random 1 50) (random 1 50);
		if ((random 1 100) > 33) then (color (random 1 50)  (random 200 250) (random 1 50)) else (color (random 1 50)  (random 1 50) (random 200 250));			
	)	
	
	fn MOTools_ColorsRandomReds color = (
		color (random 50 220) (25) (25)
	)

	fn MOTools_ColorsRandomGreens color = (
		color (25) (random 50 220) (25)
	)
	
	fn MOTools_ColorsRandomBlues color = (
		color (25) (25) (random 50 220)
	)
	
	fn MOTools_MultiMaterialBasic create amount = (	
		MOTools_MultiMaterialBasic = multimaterial()
		MOTools_MultiMaterialBasic.name = ("Basic_MMaterial"+(random 1 100 as string))
		
		MOTools_MultiMaterialBasic.numsubs = amount
		for i = 1 to amount do
		(
			MOTools_MultiMaterialBasic[i] = Standardmaterial()
			MOTools_MultiMaterialBasic[i].name = (i as string)
			MOTools_MultiMaterialBasic[i].diffuse = (MOTools_ColorsRandom color)
			if i <= 15 then (MOTools_MultiMaterialBasic[i].effectsChannel = i) else (MOTools_MultiMaterialBasic[i].effectsChannel = 15)
		)
		
		defaultMaterial = MOTools_MultiMaterialBasic
	)
	
	fn MOTools_MultiMaterialVray create amount= (	
		MOTools_MultiMaterialVray = multimaterial()
		MOTools_MultiMaterialVray.name = "Vray_MMaterial"
		MOTools_MultiMaterialVray.numsubs = amount
		
		for i = 1 to amount do
		(
			MOTools_MultiMaterialVray[i] = VrayMtl()
			MOTools_MultiMaterialVray[i].name = (i as string)
			MOTools_MultiMaterialVray[i].diffuse = (MOTools_ColorsRandom color)
			--MOTools_MultiMaterialVray[i].effectsChannel = i
			MOTools_MultiMaterialVray[i].override_effect_id = on
			MOTools_MultiMaterialVray[i].effect_id = i

		)
		
		defaultMaterial = MOTools_MultiMaterialVray
	)
	
	fn MOTools_MultiMaterialCars create = (
		
		MOTools_MultiMaterialVray_windowComposite = CompositeTexturemap ()
		MOTools_MultiMaterialVray_windowComposite.name = "WaterSpots"
		MOTools_MultiMaterialVray_windowComposite.layerName = #("WaterSpots")
		MOTools_MultiMaterialVray_windowComposite.blendMode[1] = 9
		
		MOTools_MultiMaterialVray_waterspots = Splat ()
		MOTools_MultiMaterialVray_waterspots.coords.coordType= 2	
		MOTools_MultiMaterialVray_waterspots.coordinates.mapChannel = 11
		MOTools_MultiMaterialVray_waterspots.name = "WaterSpots"
		MOTools_MultiMaterialVray_waterspots.size = 0.025
		MOTools_MultiMaterialVray_waterspots.iterations = 2
		MOTools_MultiMaterialVray_waterspots.threshold = 0.2
		MOTools_MultiMaterialVray_waterspots.color1 = (color 250 250 250)	
		MOTools_MultiMaterialVray_waterspots.color2 = (color 125 125 125)

		
		MOTools_MultiMaterialVray_PaintComposite = CompositeTexturemap ()
		MOTools_MultiMaterialVray_PaintComposite.name = "Dirt&Grime"
		MOTools_MultiMaterialVray_PaintComposite.layerName = #("WaterSpots","Mud","Dust")
		MOTools_MultiMaterialVray_PaintComposite.mapList = #(MOTools_MultiMaterialVray_waterspots)
		MOTools_MultiMaterialVray_PaintComposite.blendMode[1] = 9
		MOTools_MultiMaterialVray_PaintComposite.blendMode[2] = 9
		MOTools_MultiMaterialVray_PaintComposite.blendMode[3] = 9	
		
			
		MOTools_MultiMaterialVray_StandardVrayCar = multimaterial()
		MOTools_MultiMaterialVray_StandardVrayCar.name = ("MOCarsVrayCar_" + random 1000 9000 as string)
		MOTools_MultiMaterialVray_StandardVrayCar.numsubs = 16	
		
		MOCars_BaseColor = MOtools_mocar_RandomPaintColor RandomPaintColor	
		
		MOTools_MultiMaterialVray_StandardVrayCar[1] = VrayCarPaintMtl default: standard name:"Paint" effectsChannel:1 base_color:MOCars_BaseColor flake_color:MOCars_BaseColor texmap_coat_glossiness:MOTools_MultiMaterialVray_PaintComposite base_glossiness:(random 0.3 0.6) base_reflection:(random 0.3 0.5) flake_glossiness:(random 0.3 0.5)
		MOTools_MultiMaterialVray_StandardVrayCar[2] = VrayMtl default: standard name:"Plastic Paint" effectsChannel:2 Diffuse:gray Reflection:gray
		MOTools_MultiMaterialVray_StandardVrayCar[3] = VrayMtl default: standard name:"Chrome" effectsChannel:3 Diffuse:(color 250 250 250) Reflection:(color 250 250 250)
				
		MOTools_MultiMaterialVray_StandardVrayCar[4] = VrayMtl default: standard name:"Dark Plastic" effectsChannel:4 Diffuse:(color 15 15 15) Reflection:(color 5 5 5)
		MOTools_MultiMaterialVray_StandardVrayCar[5] = VrayMtl default: standard name:"Dark Rubber" effectsChannel:5 Diffuse:black Reflection:(color 5 5 5) reflection_glossiness:0.6
		MOTools_MultiMaterialVray_StandardVrayCar[6] = VrayMtl default: standard name:"License Plate" effectsChannel:6 Diffuse:green
		

		
		MOTools_MultiMaterialVray_StandardVrayCar[7] = VrayMtl default: standard name:"Windows" effectsChannel:7 Diffuse:black Reflection:gray texmap_reflection:MOTools_MultiMaterialVray_windowComposite reflection_fresnel:on reflection_affectAlpha:0 Refraction:white Refraction_ior:1.61 refraction_affectAlpha:2 refraction_affectShadows:on
		
		MOTools_MultiMaterialVray_StandardVrayCar[8] = VrayMtl default: standard name:"Mirrors" effectsChannel:8 Diffuse:black Reflection:(color 250 250 250)
		MOTools_MultiMaterialVray_StandardVrayCar[9] = VrayMtl default: standard name:"Internal" effectsChannel:9 Diffuse:brown
				
		MOTools_MultiMaterialVray_StandardVrayCar[10] = VrayMtl default: standard name:"Lights Plastic" effectsChannel:10 Diffuse:(color 250 250 250) Reflection:(color 250 250 250) texmap_reflection:MOTools_MultiMaterialVray_windowComposite reflection_fresnel:on reflection_affectAlpha:0 Refraction:(color 250 250 250) Refraction_ior:1.61 refraction_affectAlpha:2 refraction_affectShadows:on				
		MOTools_MultiMaterialVray_StandardVrayCar[11] = VrayMtl default: standard name:"Running Lights" effectsChannel:11 Diffuse:orange Reflection:(color 250 250 250) texmap_reflection:MOTools_MultiMaterialVray_windowComposite reflection_fresnel:on reflection_affectAlpha:0 Refraction:(color 250 250 250) Refraction_ior:1.61 refraction_affectAlpha:2 refraction_affectShadows:on refraction_glossiness:0.7 refraction_fogColor:orange 				
		MOTools_MultiMaterialVray_StandardVrayCar[12] = VrayMtl default: standard name:"Break Light" effectsChannel:12 Diffuse:red Reflection:(color 250 250 250) texmap_reflection:MOTools_MultiMaterialVray_windowComposite reflection_fresnel:on reflection_affectAlpha:0 Refraction:(color 250 250 250) Refraction_ior:1.61 refraction_affectAlpha:2 refraction_affectShadows:on refraction_glossiness:0.7 refraction_fogColor:red
					
		MOTools_MultiMaterialVray_StandardVrayCar[13] = VrayMtl default: standard name:"Tires" effectsChannel:13 Diffuse:black Reflection:(color 5 5 5) reflection_glossiness:0.43
		MOTools_MultiMaterialVray_StandardVrayCar[14] = VrayMtl default: standard name:"Rims" effectsChannel:14 Diffuse:gray Reflection:gray
		MOTools_MultiMaterialVray_StandardVrayCar[15] = VrayMtl default: standard name:"Breaks" effectsChannel:15 Diffuse:brown
		
		MOTools_MultiMaterialVray_StandardVrayCar[16] = VrayMtl default: standard name:"NoMaterialYet" effectsChannel:0 Diffuse:(color 255 0 255)
		
		VrayMaterial = MOTools_MultiMaterialVray_StandardVrayCar
	)
	
	fn MOTools_RenderElements CreateElements = (	

		--create AO maeterial
		MOTools_RenderElements_AOMaterial = VrayDirt()
		MOTools_RenderElements_AOMaterial.name = "AO"
		MOTools_RenderElements_AOMaterial.radius = 200.00
		MOTools_RenderElements_AOMaterial.occluded_color = blue
		MOTools_RenderElements_AOMaterial.unoccluded_color = red
		MOTools_RenderElements_AOMaterial.radius = 200.00	
									
		--create fall off material
		MOTools_RenderElements_UpDownMaterial = falloff()
		MOTools_RenderElements_UpDownMaterial.name = "UpDown"
		MOTools_RenderElements_UpDownMaterial.type = 0
		MOTools_RenderElements_UpDownMaterial.color1 = red
		MOTools_RenderElements_UpDownMaterial.color2 = blue
		MOTools_RenderElements_UpDownMaterial.direction = 9		
										
		--create Render Elements
		MOTools_RenderElementsMgr.addrenderelement (VRayDiffuseFilter())
		MOTools_RenderElementsMgr.addrenderelement (VRayLighting())
		MOTools_RenderElementsMgr.addrenderelement (VRayReflection())
		MOTools_RenderElementsMgr.addrenderelement (VRayRefraction())
		MOTools_RenderElementsMgr.addrenderelement (VRayShadows())
		MOTools_RenderElementsMgr.addrenderelement (VRaySpecular())
		MOTools_RenderElementsMgr.addrenderelement (VRayNormals())
		MOTools_RenderElementsMgr.addrenderelement (VRayZDepth invert_zdepth:false clamp_zdepth:false filterOn:true)
		MOTools_RenderElementsMgr.addrenderelement (VRayZDepth elementname:("VRayZDepth_Invert") invert_zdepth:true clamp_zdepth:false filterOn:false)
		MOTools_RenderElementsMgr.addrenderelement (VrayExtraTex elementname:("AO") texture:MOTools_RenderElements_AOMaterial)
		MOTools_RenderElementsMgr.addrenderelement (VrayExtraTex elementname:("UpDown") texture:MOTools_RenderElements_UpDownMaterial)
		MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("MatMatte_010203") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:1 G_gbufID:2 B_gbufID:3)
		MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("MatMatte_040506") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:4 G_gbufID:5 B_gbufID:6)
		MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("MatMatte_070809") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:7 G_gbufID:8 B_gbufID:9)
		MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("MatMatte_101112") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:10 G_gbufID:11 B_gbufID:12)
		MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("MatMatte_131415") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:13 G_gbufID:14 B_gbufID:15)
		MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("GeoMatte_010203") MatID:false R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:1 G_gbufID:2 B_gbufID:3)
		MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("GeoMatte_040506") MatID:false R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:4 G_gbufID:5 B_gbufID:6)
		MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("GeoMatte_070809") MatID:false R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:7 G_gbufID:8 B_gbufID:9)
		MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("GeoMatte_101112") MatID:false R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:10 G_gbufID:11 B_gbufID:12)
		MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("GeoMatte_131415") MatID:false R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:13 G_gbufID:14 B_gbufID:15)
	)	

	fn MOtools_mocar_RandomPaintColor RandomPaintColor = (
		
			MOCars_RandColor = random 1 100
			MOCars_SubColorArray = #(1,2,3,4,5,6,7)
			MOCars_BaseColor = color 0 0 0		

			if (MOCars_RandColor > 0 and MOCars_RandColor<=20) then (MOCars_SubColorArray = #(color 240 240 240,color 245 245 245,color 250 250 250,color 255 255 255))
			if (MOCars_RandColor > 20 and MOCars_RandColor<=37) then (	MOCars_SubColorArray = #(color 50 50 50,color 41 41 41,color 31 31 31,color 21 21 21,color 11 11 11))				
			if (MOCars_RandColor > 37 and MOCars_RandColor<=54) then (MOCars_SubColorArray = #(color 130 130 130 ,color 131 131 131,color 132 132 132 ,color 133 133 133 ,color 134 134 134))
			if (MOCars_RandColor > 54 and MOCars_RandColor<=67) then (MOCars_SubColorArray = #(color 57 134 190,color 47 91 152,color 53 68 135,color 54 67 111))
			if (MOCars_RandColor > 67 and MOCars_RandColor<=79) then (MOCars_SubColorArray = #(color 177 181 190,color 87 96 103))
			if (MOCars_RandColor > 79 and MOCars_RandColor<=90) then (	MOCars_SubColorArray = #(color 203 47 112,color 212 49 50,color 197 49 47,color 129 48 57))				
			if (MOCars_RandColor > 90 and MOCars_RandColor<=95) then (MOCars_SubColorArray = #(color 222 207 164,color 92 57 51))
			if (MOCars_RandColor > 95 and MOCars_RandColor<=98) then (MOCars_SubColorArray = #(color 15 154 99,color 31 106 86,color 15 112 101))				
			if (MOCars_RandColor > 98) then (MOCars_SubColorArray = #(color 155 125 63,color 235 186 23))
			
		--create a new material
		MOCars_BaseColor = random 1 MOCars_SubColorArray.count
		NewMOCars_BaseColor = MOCars_SubColorArray[MOCars_BaseColor]
	)	

	
		
-- Welcome Rollout ----------------------------------------------------------------------------------------------------------------------------------------------------- */
	rollout motools_welcome "Welcome to MOTools" 
	(	
		label motools1 "***BETA***"
		label motools2 "Every day tools we all need"
		label motools3 MOTools_Version
		hyperLink motools4 "Help File @ mikeoakley.com" address:"http://www.mikeoakley.com/tips/mikes-everyday-tools/" align:#center

	)	

	/* Copy / Paste Rollout ----------------------------------------------------------------------------------------------------------------------------------------------------- */
	rollout motools_copytools "Copy / Paste"
	(

			button copytools_Copy "Copy" offset: [-110,0]
			button copytools_MtlCopy "Mtl Copy" offset: [-50,-26] enabled:false		
			button copytools_NetCopy "Net Copy" offset: [15,-26] enabled:false
			button copytools_NetMtlCopy "Net Mtl Copy" offset: [90,-26] enabled:false

			button copytools_Paste "Paste" offset: [-110,0] tooltip:"Local Paste between Max's"
			button copytools_MtlPaste "Mtl Paste" offset: [-50,-26]	enabled:false	
			button copytools_NetPaste "Net Paste" offset: [15,-26] enabled:false
			button copytools_NetMtlPaste "Net Mtl Paste" offset: [90,-26] enabled:false
			
			--All COPY
			on copytools_Copy pressed do
			(
				if $ != undefined do 
				(
				saveNodes $ MOTCopyLocation
				)		
			)
			
			on copytools_MtlCopy pressed do ()		
			on copytools_NetCopy pressed do ()
			on copytools_NetMtlCopy pressed do ()		
			
			-- All PASTE
			on copytools_Paste pressed do
			(
				mergemaxfile MOTCopyLocation
			)
			on copytools_MtlPaste pressed do ()
			on copytools_NetPaste pressed do ()
			on copytools_NetMtlPaste pressed do ()		
				
	)

	/* Scene Control and LayoutTools Rollout ----------------------------------------------------------------------------------------------------------------------------------- */
	rollout motools_scenelayout "Scene/Object Control"
	(
		group "Node Control" 
		(
			button CreateMasterNode_button "Create Master Node" pos: [10,25] tooltip:"Creates a master node for all scene objects" across:2
			button SelectInstances_button "Select Instances" 
		)
		
		
		group "Correct Names"
		(
			button CorrectNames_button "Correct Selected Names"
		)	
			
		group "Transform Locks"
		(
			button Geo_Lock "Lock" offset:[-115,0] tooltip:"Locks all checked Position, Rotation, Scale"
			button Geo_UnLock "Unlock" offset:[-65,-26] tooltip:"Unlocks all checked Position, Rotation, Scale"
			checkbox Geo_Locks_pos "Move" offset:[100,-22] checked:true  
			checkbox Geo_Locks_rot "Rotate" offset:[150,-20] checked:true
			checkbox Geo_Locks_scale "Scale" offset:[210,-20] checked:true 
		)
		
			group "Correct Selected Object Pivots"
		(
			button Initilize_button "Zero out all pivots" tooltip:"Moves all selected obj to 0,0,0 for rigging purpose"
		)	

		on Initilize_button pressed do
		(
			if $ !=undefined then
			(
				for obj in $ do
				(
					WorldAlignPivot obj
					obj.pivot = [0,0,0]
				)
			) else (messagebox ("You need to select some Objects"))
		)	
		
		on SelectInstances_button pressed do
		(
			try(
				instances = #()
				InstanceMgr.GetInstances $ &instances
				Select instances
			) catch (
				messagebox "Currently only work by selecting one object" title:"Correct Selected Names" beep:true		
			)
		)
		
		on CreateMasterNode_button pressed do
		(
			MasterLayer = LayerManager.newLayerFromName "MasterNode"
			MasterLayer = LayerManager.getLayerFromName "MasterNode"
			MasterLayer.current = true					
				
			MOMaster_Node = Point ()
			MOMaster_Node.name = "MasterNode"
			MOMaster_Node.pos = [0,0,0] 
			MOMaster_Node.size = 50
			MOMaster_Node.box = true
			MOMaster_Node.constantscreensize = true
			MOMaster_Node.wirecolor = red
						
			fn theRootNode node = if isvalidnode node do (while node.parent != undefined do node = node.parent; node)					
			for i=1 to objects.count do
			(	
				TopNodeToLink = theRootNode objects[i]
				try(TopNodeToLink.parent = MOMaster_Node) catch ()
			)
		)
		
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

	rollout motools_animationtools "Animation"
	(
		group "Animation Keys"
		(
			button removeallanimation_button "Remove all animation at frame"
		)
		
		on removeallanimation_button pressed do
		(
			if selection !=undefined do
			(
				for obj in selection do
				(
					deleteKeys obj #allKeys
				)
			)			
		)		
		
		group "Bake to Node"
		(
			spinner startframe "Start: " range:[-1000,10000,MOTools_startframe] type:#integer fieldwidth:50 across:3
			spinner endframe "End: " range:[-1000,10000,MOTools_endframe] type:#integer fieldwidth:50
			button geo_baketoNode_button "Bake to Node" tooltip:"Copies all Position, Rotation, Scale for an object and bakes it to a node" 
		
			on geo_baketoNode_button pressed do
			(
				if selection !=undefined do
				(
					for obj in selection do
					(
						motools_bakenode = point ()
						motools_bakenode.name = (obj.name as string + "_BAKEDNODE")
						motools_bakenode.Box = on
						at time startframe.value
						(
							motools_bakenode.scale = obj.scale
							motools_bakenode.rotation = obj.rotation
							motools_bakenode.pos = obj.pos
						)				
						
						with animate on
						for t = startframe.value to endframe.value do
						(
							at time t
							(
								motools_bakenode.scale = obj.scale
								motools_bakenode.rotation = obj.rotation
								motools_bakenode.pos = obj.pos
							)						
						)	
					)
				)
			)
		)
		
		group "Turn Table"
		(
			button cartools_TurnTable_Button "Create Turn Table" across:2 tooltip:"Creates a simple turn table"
			dropdownlist cartools_TurnTable_dropdown "" items:#("Current frame range","5 sec","10 sec","15 sec","30 sec","One Minute") 
			on cartools_TurnTable_Button pressed do
			(

					if (cartools_TurnTable_dropdown.selection == 1) do (animationRange = interval animationRange.start animationRange.end)
					if (cartools_TurnTable_dropdown.selection == 2) do (animationRange = interval animationRange.start (animationRange.start + 120))
					if (cartools_TurnTable_dropdown.selection == 3) do (animationRange = interval animationRange.start (animationRange.start + 240))
					if (cartools_TurnTable_dropdown.selection == 4) do (animationRange = interval animationRange.start (animationRange.start + 360))
					if (cartools_TurnTable_dropdown.selection == 5) do (animationRange = interval animationRange.start (animationRange.start + 720))
					if (cartools_TurnTable_dropdown.selection == 6) do (animationRange = interval animationRange.start (animationRange.start + 1440))
						
				
					MoToolsTurnTable = LayerManager.newLayerFromName "MoTools_TurnTable"
					MoToolsTurnTable = LayerManager.getLayerFromName "MoTools_TurnTable"
					MoToolsTurnTable.current = true			
					
					--create rig
					MoTools_TurnTable_Path = circle pos:[0,0,165]	
					MoTools_TurnTable_Path.name= "con_MoTools_TurnTable_Path"	
					MoTools_TurnTable_Path.radius = 400

					
					MoTools_TurnTable_cam = Targetcamera fov:45
					MoTools_TurnTable_cam.name = "camera_TurnTable"
					MoTools_TurnTable_cam.target= Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
					MoToolsPC = Path_Constraint ()	
					MoTools_TurnTable_cam.position.controller = MoToolsPC	
					MoToolsPC.path = MoTools_TurnTable_Path
					
					MoTools_TurnTable_Ground = VRayPlane ()
					MoTools_TurnTable_Ground.name= "con_MoTools_TurnTable_Ground"	
					MoTools_TurnTable_Ground.wirecolor = gray		
					
					--create Lightsmtl
					MoTools_TurnTable_GradientRamp = Gradient_Ramp ()
					MoTools_TurnTable_GradientRamp.name = "MoToolsHorizon"
					MoTools_TurnTable_GradientRamp.coordinates.mappingType = 1
					MoTools_TurnTable_GradientRamp.coordinates.mapping = 0
					MoTools_TurnTable_GradientRamp.coordinates.W_Angle = 90				
					MoTools_TurnTable_GradientRamp.gradient_ramp.flag__1.color = [15,15,15]
					MoTools_TurnTable_GradientRamp.gradient_ramp.flag__3.color = [5,5,5]
					MoTools_TurnTable_GradientRamp.gradient_ramp.flag__2.color = [200,200,200]
					
					--create Lightsmtl
					MoTools_TurnTable_DomLight = VRayLight()
					MoTools_TurnTable_DomLight.name = "MoToolsTurnTable_DomeLight"
					MoTools_TurnTable_DomLight.type = 1
					MoTools_TurnTable_DomLight.multiplier = 1.25
					MoTools_TurnTable_DomLight.dome_spherical = on
					MoTools_TurnTable_DomLight.texmap = MoTools_TurnTable_GradientRamp	
				
			)			
		)
		
	)
	
	rollout motools_shapetools "Shapes"
	(
		group "Rebuild Line"
		(
			pickbutton shape_Select "Select the shape" width:140
		)
		
		
		on shape_Select picked OldSpline do
		(
			CountofVert = numKnots OldSpline
			newSpline = splineShape()
			newSpline.name = "MOTools New Spline"
			addnewSpline newSpline
			for i = 1 to CountofVert do
			(	
				print i
				knotpos = getKnotPoint $ 1 i
				
				addknot newSpline 1 #corner #line knotpos
			)
			close newSpline 1
			updateShape newSpline
			newSpline			
		)
		
		
		
	)

	/* Camera Tools Rollout ----------------------------------------------------------------------------------------------------------------------------------------------------- */
	rollout motools_cameratools "Camera"
	(	
		--Picked Camera	
		fn camerafilter cam = superclassof cam== camera
		pickbutton cam_OC_Select "Select the Camera" width:140 filter:camerafilter	

		group "Overscan Camera"
		(			
				spinner cam_OC_Amount "OverScan amount %:" range:[0,100,20] type:#float enabled:false
				checkbox cam_OC_Animated "Animated Camera?" checked:false align:#center enabled:false
				button cam_OC_Button "Apply OverScan" enabled:false tooltip:"This will copy and overscan your selected free camera"	
		)
		
		group "Camera Effect" 
		(
			button cam_FX_Button01 "Apply" tooltip:"Apply selected actions" offset:[-110,0] enabled:false
			dropdownlist cam_FX_dropdown "" items:#("Action (very shaky)","Documentry (slowing floating movement)","Combat (quick motions)","Ocean (I'm on a boat MOFO)") offset:[45,-26] width:150
			spinner cam_FX_spinner "%:" range:[0,100,50] type:#integer offset:[50,-26] width:50 enabled:false
		)	
		
		group "Camera Name Fixer"
		(
			edittext cambase_show "Show" enabled:false
			edittext cambase_shot "Shot"  enabled:false
			edittext cambase_scene "Scene"  enabled:false
			edittext cambase_version "Version"  enabled:false
			button cam_stanname_Button "Standardize name"  enabled:false

			
		on cam_OC_Select picked cam do
		(
				if cam != undefined do
				(
					select cam
					global cam_OC_Selected = cam
					cam_OC_Select.text = cam_OC_Selected.name
					CurrentCam = cam_OC_Select.text
					
					cam_OC_Amount.enabled = true
					cam_OC_Animated.enabled = true
					cam_OC_Button.enabled = true
					cam_FX_Button01.enabled = true
				)
			)
		)
			
		on cam_OC_Button pressed do
		(
			try
			(
				if cam_OC_Select != undefined do
				(
					print (cam_OC_Select.name)
					cam_OC_New = copy cam_OC_Select
					cam_OC_New.name = cam_OC_Select.name + "_OverScan"
					
					if cam_OC_Animated.state==false do
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
				--select cam_OC_New	
				messagebox ("Your camera and render setting have be Over Scanned")	
				) catch (messagebox ("This only works with free cameras"))
		)		
		
		on rename_them pressed do
		(
			base_name = "NOTCAMERA"
			rename_them.name = uniquename base_name.text
		)
		
		on cam_FX_Button01 pressed do
		(
			
			CameraActionNode = point ()
			CameraActionNode.name = "con_" + (cam_OC_Selected.name as string) + "_ShakyCamNode"
			CameraActionNode.rotation = cam_OC_Selected.rotation
			
			CameraActionNodePosController = noise_position ()		
			CameraActionNode.pos.controller = position_list ()		
			CameraActionNode.pos.controller.Available.controller = CameraActionNodePosController 
					
			CameraActionNodeRotController = noise_rotation ()		
			CameraActionNode.rotation.controller = rotation_list ()		
			CameraActionNode.rotation.controller.Available.controller = CameraActionNodeRotController 
			
			CameraActionNodePosController.seed = (random 1000 9000)
			CameraActionNodeRotController.seed = (random 1000 9000)
		
			
			if (cam_FX_dropdown.selection == 1) do
			(			
				CameraActionNodePosController.frequency = 0.001
				CameraActionNodePosController.fractal = true
				CameraActionNodePosController.roughness = 0.5
				CameraActionNodePosController.noise_strength = [40,40,40]
			
				CameraActionNodeRotController.frequency = 0.001
				CameraActionNodeRotController.fractal = true
				CameraActionNodeRotController.roughness = 0.5
				CameraActionNodeRotController.noise_strength = [0.2,0.2,0.2]			
			)
			
			if (cam_FX_dropdown.selection == 2) do
			(			
				CameraActionNodePosController.frequency = 0.001
				CameraActionNodePosController.fractal = false
				CameraActionNodePosController.roughness = 0.4
				CameraActionNodePosController.noise_strength = [40,40,40]
			
				CameraActionNodeRotController.frequency = 0.001
				CameraActionNodeRotController.fractal = false
				CameraActionNodeRotController.roughness = 0.5
				CameraActionNodeRotController.noise_strength = [0.2,0.2,0.2]			
			)	
			
			
			
			-- parents cam to node
			CameraActionNode.pos = cam_OC_Selected.pos
			cam_OC_Selected.parent = CameraActionNode
					
		)
		
	)

	/* Fume FX Tools Rollout --------------------------------------------------------------------------------------------------------------------------------------------------- */
	rollout motools_ffxtools "Fume FX"
	(
			group ""	
			(			
				--dropdownlist FFX_FM_List "PreSets" items:#("1/2", "1/4", "1/8", "1/16")
				pickbutton FFX_default_Pick "Pick Your Fume" Offset:[0,0] across:2
				button FFX_Autopath_Button "Auto Create all Folders" enabled:false 
				
				button FFX_default_Button " Set default" enabled:false across:2
				radiobuttons FFX_default_locations labels:#("Local", "Network")
				
				button FFX_Wavelet_Button "Set Wavelet" enabled:false across:2
				radiobuttons FFX_wavelet_locations labels:#("Local", "Network")
				
				button FFX_Retimer_Button "Set Retimer" enabled:false across:2
				radiobuttons FFX_retimer_locations labels:#("Local", "Network")

				dropdownlist FFX_autofume_dropdown "" items:#("1 Sim Default","2 Sim Wavelet (Requires Default)","3 Sim Default and Wavelet") across:2
				button FFX_autofume_Button "Start Local Simulation" enabled:false
				
				button FFX_CopyLocal2Network_Button "Copy Local --> Network" enabled:false across:2
				button FFX_CopyNetwork2Local_Button "Copy Network --> Local" enabled:false			
				
				
				
						
				on FFX_default_Pick picked Fume do
				(
					if Fume != undefined do
						(
							FFXDefaltLoc = Fume.getPath #default
							FFXWaveletLoc = Fume.getPath #wavelet
							FFXRetimerLoc = Fume.getPath #default
							
							setINISetting MOToolINI "MOTools_FumeFX" "LocalDefaultPath" FFXDefaltLoc
							setINISetting MOToolINI "MOTools_FumeFX" "LocalWavePath" FFXWaveLoc
							setINISetting MOToolINI "MOTools_FumeFX" "LocalNSimPath" FFXNSimLoc
							
							FFX_default_Pick.text = fume.name
							FFX_Autopath_Button.enabled = true
							
							FFX_default_Button.enabled = true
							FFX_wavelet_Button.enabled = true
							FFX_retimer_Button.enabled = true
							FFX_autofume_Button.enabled = true
						)
				)	
				
				on FFX_Autopath_Button pressed do
				(
					makeDir (MOTools_GetPathFumeLocal location + "\\default")
					makeDir (MOTools_GetPathFumeNetwork location + "\\default")
					FFX_default_Pick.object.SetPath (MOTools_GetPathFumeLocal location + "\\default\\"  + FFX_default_Pick.object.name + "_default.fxd") #default
					
					
					makeDir (MOTools_GetPathFumeLocal location + "\\wavelet")
					makeDir (MOTools_GetPathFumeNetwork location + "\\wavelet")
					FFX_default_Pick.object.SetPath (MOTools_GetPathFumeLocal location + "\\wavelet"  + FFX_default_Pick.object.name + "_wavelet.fxd") #wavelet
					
					makeDir (MOTools_GetPathFumeLocal location + "\\retimer")
					makeDir (MOTools_GetPathFumeNetwork location + "\\retimer")
					FFX_default_Pick.object.SetPath (MOTools_GetPathFumeLocal location + "\\retimer"  + FFX_default_Pick.object.name + "_retimer.fxd") #retimer
					
					makeDir (MOTools_GetPathFumeLocal location + "\\preview")
					makeDir (MOTools_GetPathFumeNetwork location + "\\preview")
					FFX_default_Pick.object.SetPath (MOTools_GetPathFumeLocal location + "\\retimer"  + FFX_default_Pick.object.name + ".avi") #preview
					
				)
				
				on FFX_default_Button pressed do
				(
					if (FFX_default_locations.state == 1) then
					(
						makeDir ("C:\\Temp\\FumeFX_Cache\\FumeFX_" + getFilenameFile maxFilename + "\\default")
						FFX_default_Pick.object.SetPath ("C:\\Temp\\FumeFX_Cache\\FumeFX_" + getFilenameFile maxFilename + "\\default\\"  + FFX_default_Pick.object.name + "_default.fxd") #default

					) else 
					(
						makeDir (maxfilepath + "\\FumeFX_Cache\\" + getFilenameFile maxFilename +"\\default")
						FFX_default_Pick.object.SetPath (maxfilepath + "\\FumeFX_Cache\\" + getFilenameFile maxFilename +"\\default\\"  + FFX_default_Pick.object.name + "_default.fxd") #default

					)
				)				
						
				on FFX_wavelet_Button pressed do
				(
					if (FFX_wavelet_locations.state == 1) then
					(
						makeDir ("C:\\Temp\\FumeFX_Cache\\FumeFX_" + getFilenameFile maxFilename + "\\wavelet\\"  + FFX_default_Pick.object.name + "_wavelet.fxd")
						FFX_default_Pick.object.SetPath ("C:\\Temp\\FumeFX_Cache\\FumeFX_" + getFilenameFile maxFilename + "\\wavelet\\"  + FFX_default_Pick.object.name + "_wavelet.fxd") #wavelet
					) else 
					(
						makeDir (maxfilepath + "\\FumeFX_Cache\\" + getFilenameFile maxFilename +"\\wavelet\\"  + FFX_default_Pick.object.name + "_wavelet.fxd")
						FFX_default_Pick.object.SetPath (maxfilepath + "\\FumeFX_Cache\\" + getFilenameFile maxFilename +"\\wavelet\\"  + FFX_default_Pick.object.name + "_wavelet.fxd") #wavelet
					)
				)
					
				on FFX_Retimer_Button pressed do
				(
					if (FFX_retimer_locations.state == 1) then
					(
						makeDir ("C:\\Temp\\FumeFX_Cache\\FumeFX_" + getFilenameFile maxFilename + "\\retimer")
						FFX_default_Pick.object.SetPath ("C:\\Temp\\FumeFX_Cache\\FumeFX_" + getFilenameFile maxFilename + "\\retimer"  + FFX_default_Pick.object.name + "_retimer.fxd") #retimer
						print ("FumeFX retimer : " + FFX_default_Pick.object.name + " path is set to : " + "C:\\Temp\\FumeFX_Cache\\FumeFX_" + getFilenameFile maxFilename + "\\retimer" )
					) else 
					(
						makeDir (maxfilepath + "\\FumeFX_Cache\\" + getFilenameFile maxFilename +"\\retimer")
						FFX_default_Pick.object.SetPath (maxfilepath + "\\FumeFX_Cache\\" + getFilenameFile maxFilename +"\\retimer"  + FFX_default_Pick.object.name + "_retimer.fxd") #retimer
						print ("FumeFX retimer : " + FFX_default_Pick.object.name + " path is set to : " + maxfilepath + "\\FumeFX_Cache\\" + getFilenameFile maxFilename +"\\retimer" )
					)
				)

				on FFX_autofume_Button pressed do
				(
					
					if  FFX_autofume_dropdown.selection == 1 then 
						(
							FFX_default_Pick.object.selectedcache = 0;
							FFX_default_Pick.object.runsimulation 0;
							print "Auto Fume Default : Done"
						)
						
						
					if (FFX_autofume_dropdown.selection == 2 and FFX_default_Pick.object.ExtraDetailType == 2) then 
						(
							FFX_default_Pick.object.selectedcache = 0;
							FFX_default_Pick.object.runsimulation 2;
							FFX_default_Pick.object.selectedcache = 1;
							print "Auto Fume Wavelet : Done"
						)

						
					if (FFX_autofume_dropdown.selection == 3 and FFX_default_Pick.object.ExtraDetailType == 2) then 
						(
							FFX_default_Pick.object.selectedcache = 0;
							FFX_default_Pick.object.runsimulation 0;
							print "Auto Fume Default : Done"
							FFX_default_Pick.object.selectedcache = 0;
							FFX_default_Pick.object.runsimulation 2;
							print "Auto Fume Wavelet : Done"
							FFX_default_Pick.object.selectedcache = 1;
							print "Auto Fume : Done"
						)
						
					if (FFX_autofume_dropdown.selection == 2 or FFX_autofume_dropdown.selection == 3 and FFX_default_Pick.object.ExtraDetailType != 2)	then (messagebox "You must enable Sim > Extra Detail > Wavelet Turbulence in order to sim Wavelet")
						

				)
				
				on FFX_CopyLocal2Network_Button pressed do
				(
					doscommand ("xcopy " + "C:\\Temp\\FumeFX_Cache\\FumeFX_" + getFilenameFile maxFilename + " " + maxfilepath + "\\FumeFX_Cache\\" + getFilenameFile maxFilename)
				)
				
				on FFX_CopyNetwork2Local_Button pressed do
				(
				)			

			)		
					
			
			group "FX Lighting System"	
			(
				button FFXtools_Lighting_Button "Create FFX_Lighting"
				on FFXtools_Lighting_Button pressed do
				(
					
					FFXlayer = LayerManager.newLayerFromName "FFX_Lighting"
					FFXlayer = LayerManager.getLayerFromName "FFX_Lighting"
					FFXlayer.current = true
					
					FFXtools_LightingPoint = Point ()
					FFXtools_LightingPoint.name = "con_FFXLighting"
					FFXtools_LightingPoint.pos = [0,0,100] 
					FFXtools_LightingPoint.size = 50
					FFXtools_LightingPoint.box = true
					FFXtools_LightingPoint.wirecolor = White
								
					FFXtools_LightingPointTarget = Point ()
					FFXtools_LightingPointTarget.name = "con_FFXLightingTarget"
					FFXtools_LightingPointTarget.pos = [0,0,0] 
					FFXtools_LightingPointTarget.size = 20
					--FFXtools_LightingPointTarget.box = true
					FFXtools_LightingPointTarget.wirecolor = gray

					FFXtools_LightingPointTarget.parent = FFXtools_LightingPoint
					

					
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

				)	
			)
	)

	/* Geo ToolsTools Rollout --------------------------------------------------------------------------------------------------------------------------------------------------- */
	rollout motools_geotools "Geometry"
	(	
		group "Random Wire Colors"
		(
				label geo1 "Please Select Objects to be re-colored" align:#center
				button geo_RanColor_Button "Colors" tooltip:"All selected objects wire color are randomly picked" across:4
				button geo_RanBW_Button "Black & White" tooltip:"All selected objects wire color are randomly picked"
				button geo_RanPastel_Button "Pastel" tooltip:"All selected objects wire color are randomly picked"
				button geo_RanHigh_Button "Contrast" tooltip:"All selected objects wire color are randomly picked"
			
				button geo_RanColorRed_Button "Random Reds" tooltip:"All selected objects wire color are randomly picked" across:3
				button geo_RanColorGreen_Button "Random Greens" tooltip:"All selected objects wire color are randomly picked"
				button geo_RanColorBlue_Button "Random Blues" tooltip:"All selected objects wire color are randomly picked"
			
				button geo_RanColorChoice_Button "Based on : " tooltip:"All selected objects wire color are randomly picked" across:3
				colorpicker geo_RanColorChoice " " color:[0,0,255]
				checkbox geo_isinstance "Color Instance" checked:false
			
				on geo_RanColor_Button pressed do
				(
					if $ != undefined then
					(
						for obj in selection do
						(		
							if geo_isinstance.state==true then (InstanceMgr.GetInstances obj &obj)								
							obj.wirecolor = color (random 50 220)  (random 50 220) (random 50 220)
						) 
					) else (messagebox "No objects selected !" title:"Warning" beep:true)					
				)

				on geo_RanBW_Button pressed do
				(
					if $ != undefined then
					(
						for obj in selection do
						(
							if geo_isinstance.state==true then (InstanceMgr.GetInstances obj &obj)	
							bwcolor = (random 1 220)+50
							obj.wirecolor = color (bwcolor) (bwcolor) (bwcolor)
						) 
					) else (messagebox "No objects selected !" title:"Warning" beep:true)					
				)
				
				on geo_RanPastel_Button pressed do
				(
					if $ != undefined then
					(
						for obj in selection do
						(
							if geo_isinstance.state==true then (InstanceMgr.GetInstances obj &obj)	
							obj.wirecolor = color (random 150 250)  (random 150 250) (random 150 250)
						) 
					) else (messagebox "No objects selected !" title:"Warning" beep:true)					
				)
				
				on geo_RanHigh_Button pressed do
				(
					if $ != undefined then
					(
						for obj in selection do
						(
							if geo_isinstance.state==true then (InstanceMgr.GetInstances obj &obj)	
							randomcolorchoice = random 1 100							
							if (randomcolorchoice > 1) do (obj.wirecolor = color (random 200 250)  (random 1 50) (random 1 50))
							if (randomcolorchoice > 33) do (obj.wirecolor = color (random 1 50)  (random 200 250) (random 1 50))
							if (randomcolorchoice > 66) do (obj.wirecolor = color (random 1 50)  (random 1 50) (random 200 250))
								
								
						) 
					) else (messagebox "No objects selected !" title:"Warning" beep:true)					
				)
				
				on geo_RanColorRed_Button pressed do
				(
					if $ != undefined then
					(
						for obj in selection do
						(
							if geo_isinstance.state==true then (InstanceMgr.GetInstances obj &obj)	
							bwcolor = (random 1 230)+20
							obj.wirecolor = color (random 50 220) (25) (25)
						) 
					) else (messagebox "No objects selected !" title:"Warning" beep:true)					
				)
				
				on geo_RanColorGreen_Button pressed do
				(
					if $ != undefined then
					(
						for obj in selection do
						(
							if geo_isinstance.state==true then (InstanceMgr.GetInstances obj &obj)	
							bwcolor = (random 1 230)+20
							obj.wirecolor = color (25) (random 50 220) (25)
						) 
					) else (messagebox "No objects selected !" title:"Warning" beep:true)					
				)
				
				on geo_RanColorBlue_Button pressed do
				(
					if $ != undefined then
					(
						for obj in selection do
						(
							if geo_isinstance.state==true then (InstanceMgr.GetInstances obj &obj)	
							bwcolor = (random 1 230)+20
							obj.wirecolor = color (25) (25) (random 50 220)
						) 
					) else (messagebox "No objects selected !" title:"Warning" beep:true)					
				)
				
				on geo_RanColorChoice_Button pressed do
				(
					if $ != undefined then
					(
						geo_RanColorChoice_color = black
						for obj in selection do
						(
							if geo_isinstance.state==true then (InstanceMgr.GetInstances obj &obj)	
							geo_RanColorChoice_color = geo_RanColorChoice.color
							geo_RanColorChoice_color.value = random 25 250
							obj.wirecolor = geo_RanColorChoice_color
						)
							
					) else (messagebox "No objects selected !" title:"Warning" beep:true)					
				)
				
		)

		group "Random Object Selection"
		(
			button geo_RanSel_Button "Random Select" tooltip:"Randomly selects percentage" across:2
			spinner spinner_geo_RanSel_Amount "Amount %:" range:[0,100,50] type:#integer
				on geo_RanSel_Button pressed do
				(
					if selection.count == 0 then messagebox "No objects selected !" title:"Warning" beep:true
					for obj in $ do
					(
						if (random 0 100 > spinner_geo_RanSel_Amount.value) do (deselect(obj))
					)
				)		
		)
		
		group "Modifier Stack"
		(
				button ModifierStack_Button "Collapes all selected" tooltip:"All selected objects modifier stack will collapes down to edit poly or mesh"
				on ModifierStack_Button pressed do
				(
					if $ != undefined then
					(
						for obj in selection do
						(
							maxOps.CollapseNode obj off
						) 
					) else (messagebox "No objects selected !" title:"Warning" beep:true)					
				)			
		)
		
		group "G-Buffer ID control"
		(
			button geo_GBufferRandom_Button "Randomize GBuffer ID's" tooltip:"All selected objects wire color are randomly picked" across:2
			button geo_GBufferStrip_Button "Strip GBuffer ID's" tooltip:"All selected objects wire color are randomly picked"
		)
		
		on geo_GBufferRandom_Button pressed do
		(
			if $ != undefined then
			(
				for obj in selection do
				(
					if (Superclassof obj==GeometryClass) or (Superclassof obj==shape) do (
						obj.gbufferchannel = random 1 15;
						format "%n was given Gbuffer ID number : %\n" obj.name obj.gbufferchannel
					)
				)				
			) else (messagebox ("Nothing selected"))
		)
		
		on geo_GBufferStrip_Button pressed do
		(
			if $ != undefined then
			(
				for obj in selection do
				(
					obj.gbufferchannel = 0
					format "Clearing the following GBuffer ID's : %\n" obj.name
				)				
			) else (messagebox ("Nothing selected"))
		)		
	)

	/* Lighting Tools Rollout ----------------------------------------------------------------------------------------------------------------------------------------------------- */
	rollout motools_lightingtools "Lighting"
	(
		group "Color Lights objects to light color "
		(
			button ColorLights_button "Re Color Lights" tooltip:"Color Lights objects to light color "
		)
		
		on ColorLights_button pressed do
			(
				if $ != undefined then
				(
					for lights in selection do
					(
						try(
							lights.viewport_wire_color_on = on
							lights.viewport_wire_color = lights.color 
						)catch (print ("this light is not supported") )
					) 
				) else (messagebox ("Nothing selected"))
			)
		
		
		group "FX Three Point Lighting"
		(
			button CreateMasterNode_button "Create Rig" tooltip:"Creates a Three color lighting setup. Use master and child nods to place."
		
			on CreateMasterNode_button pressed do
			(
				LightingLayer = LayerManager.newLayerFromName "Lighting_ThreePoint"
				LightingLayer = LayerManager.getLayerFromName "Lighting_ThreePoint"
				LightingLayer.current = true
					
				ThreePointLighting_LightingPoint = Point ()
				ThreePointLighting_LightingPoint.name = "con_ThreePointLighting"
				ThreePointLighting_LightingPoint.pos = [0,0,100] 
				ThreePointLighting_LightingPoint.size = 50
				ThreePointLighting_LightingPoint.box = true
				ThreePointLighting_LightingPoint.wirecolor = White
								
				ThreePointLighting_LightingPointTarget = Point ()
				ThreePointLighting_LightingPointTarget.name = "con_ThreePointLightingTarget"
				ThreePointLighting_LightingPointTarget.pos = [0,0,0] 
				ThreePointLighting_LightingPointTarget.size = 20
				--ThreePointLighting_LightingPointTarget.box = true
				ThreePointLighting_LightingPointTarget.wirecolor = gray

				ThreePointLighting_LightingPointTarget.parent = ThreePointLighting_LightingPoint

				ThreePointLighting_LightinglightRED = targetSpot ()
				ThreePointLighting_LightinglightRED.name = "ThreePointLighting_RED"
				ThreePointLighting_LightinglightRED.rgb = RED
				ThreePointLighting_LightinglightRED.baseObject.castShadows = true
				ThreePointLighting_LightinglightRED.multiplier = 1.0		
				ThreePointLighting_LightinglightRED.pos = [100,0,100] 
				ThreePointLighting_LightinglightRED.target= (targetObject pos:ThreePointLighting_LightingPointTarget.pos)
				ThreePointLighting_LightinglightRED.parent = ThreePointLighting_LightingPoint
				ThreePointLighting_LightinglightRED.target.parent = ThreePointLighting_LightingPointTarget
				ThreePointLighting_LightinglightRED.wirecolor = red
								
				ThreePointLighting_LightinglightGREEN = targetSpot ()
				ThreePointLighting_LightinglightGREEN.name = "ThreePointLighting_GREEN"
				ThreePointLighting_LightinglightGREEN.rgb = GREEN
				ThreePointLighting_LightinglightGREEN.baseObject.castShadows = true
				ThreePointLighting_LightinglightGREEN.multiplier = 1.0		
				ThreePointLighting_LightinglightGREEN.pos = [-48,87,100] 
				ThreePointLighting_LightinglightGREEN.target= (targetObject pos:ThreePointLighting_LightingPointTarget.pos)
				ThreePointLighting_LightinglightGREEN.parent = ThreePointLighting_LightingPoint
				ThreePointLighting_LightinglightGREEN.target.parent = ThreePointLighting_LightingPointTarget
				ThreePointLighting_LightinglightGREEN.wirecolor = green

					
				ThreePointLighting_LightinglightBLUE = targetSpot ()
				ThreePointLighting_LightinglightBLUE.name = "ThreePointLighting_BLUE"
				ThreePointLighting_LightinglightBLUE.rgb = BLUE
				ThreePointLighting_LightinglightBLUE.baseObject.castShadows = true
				ThreePointLighting_LightinglightBLUE.multiplier = 1.0		
				ThreePointLighting_LightinglightBLUE.pos = [-53,-84,100] 
				ThreePointLighting_LightinglightBLUE.target= (targetObject pos:ThreePointLighting_LightingPointTarget.pos)
				ThreePointLighting_LightinglightBLUE.parent = ThreePointLighting_LightingPoint
				ThreePointLighting_LightinglightBLUE.target.parent = ThreePointLighting_LightingPointTarget
				ThreePointLighting_LightinglightBLUE.wirecolor = Blue			
			)
		)
		
		group "Enviromental Lighting"
		(
			button CreateDiffandSpec_button "Create" tooltip:"Creates a Two Vray dome lights. A diffuse light and a spec and reflecton" enabled:(MOTools_CheckforVray VrayTrue)
			
			on  CreateDiffandSpec_button pressed do
			(
				LightingLayer = LayerManager.newLayerFromName "Lighting_Enviroment"
				LightingLayer = LayerManager.getLayerFromName "Lighting_Enviroment"
				LightingLayer.current = true
				
				enviromentdiffuse = VRayLight ()
				enviromentdiffuse.name = "light_Diffuse"
				enviromentdiffuse.pos = [-10,0,0]
				enviromentdiffuse.type = 1
				enviromentdiffuse.multiplier = 1
				enviromentdiffuse.invisible = on
				enviromentdiffuse.noDecay = on
				enviromentdiffuse.affect_diffuse = on
				enviromentdiffuse.affect_specualr = off
				enviromentdiffuse.affect_reflections = off
				enviromentdiffuse.wirecolor = White
				
				enviromentspecreflec = VRayLight ()
				enviromentspecreflec.name = "light_Spec&Reflect"
				enviromentspecreflec.pos = [10,0,0]
				enviromentspecreflec.type = 1
				enviromentspecreflec.multiplier = 1
				enviromentspecreflec.invisible = on
				enviromentspecreflec.noDecay = on
				enviromentspecreflec.affect_diffuse = off
				enviromentspecreflec.affect_specualr = on
				enviromentspecreflec.affect_reflections = on
				enviromentspecreflec.wirecolor = White			
				
			)
		)	
		
		group "Balance lights"
		(
			
			spinner BalanceLightsSetto "Balance to" range:[0,1000,1] across:2 enabled:false
			button BalanceLights_button "Balance Selected Lights" tooltip:"Creates a Two Vray dome lights. A diffuse light and a spec and reflecton" enabled:false
			on BalanceLights_button pressed do
			(
				if $ != undefined then
					(
					BalanceLightsNumbers = $.count
					BalanceLightsBalance = BalanceLightsNumbers / BalanceLightsSetto.value
					
		
					for lights in selection do
					(
						print BalanceLightsBalance
					) 

						
						
					) else ()
			)
			
		)
		
	)

	
		
	/* materialTools Rollout ----------------------------------------------------------------------------------------------------------------------------------------------------- */
	rollout motools_materialtools "Materials"
	(
		group "Material Editor Style"
		(
			radiobuttons motools_materialtools_MaterialEditorStyle "Material Editor Style" labels:#("Compact", "Slate") default:0
		)
		
		group "Match Material IDs to Material Channel"
		(
			button motools_materialtools_Selected_button "Selected Material Slot" across:2
			button motools_materialtools_All_button "All Materials Slots" tooltip:"Creates a Three color lighting setup. Use master and child nods to place." across:2 enabled:false
		)		
		
		group "Create Materials"
		(
			spinner motools_materialtools_createMMtlAmount_spinner "MultiMaterial Amount" range:[0,100,15] fieldWidth: 40 type:#integer align:#center				
			button motools_materialtools_createBasic_button "Simple MM" across:3
			button motools_materialtools_createVray_button "Vray MM" enabled:(MOTools_CheckforVray VrayTrue)
			button motools_materialtools_createCar_button "Vray Cars" enabled:(MOTools_CheckforVray VrayTrue)
			button motools_materialtools_createPlaneInteriorseat_button "Plane Seats" enabled:(MOTools_CheckforVray VrayTrue) across:3
			button motools_materialtools_createPlaneInterior_button "Plane Interior" enabled:(MOTools_CheckforVray VrayTrue)
			button motools_materialtools_createPlaneExterior_button "Plane Exterior" enabled:(MOTools_CheckforVray VrayTrue)
					
		)
		
		on motools_materialtools_MaterialEditorStyle changed state do 
			(
				if (motools_materialtools_MaterialEditorStyle.state == 1) do (MatEditor.Close();MatEditor.mode=#basic)
				if (motools_materialtools_MaterialEditorStyle.state == 2) do (MatEditor.Close();SME.Close();MatEditor.mode=#advanced)				
			)				
				
		on motools_materialtools_Selected_button pressed do
			(
				try (
					MOTools_MaterialSlotNumber = medit.GetActiveMtlSlot()
					MOTools_MaterialNumber = meditMaterials[MOTools_MaterialSlotNumber].materialList.count

					for i=1 to MOTools_MaterialNumber do
					(
						try (
							meditMaterials[MOTools_MaterialSlotNumber].materialList[i].override_effect_id = on
							meditMaterials[MOTools_MaterialSlotNumber].materialList[i].effect_id = i
						) catch()
						try (
							if i<=15 then (meditMaterials[MOTools_MaterialSlotNumber].materialList[i].effectsChannel = i) else (meditMaterials[MOTools_MaterialSlotNumber].materialList[i].effectsChannel = 15)
						) catch()
						
					)
				) catch (messagebox ("The Current selected Material is not a Multi Material or is blank"))
			)
			

		on motools_materialtools_All_button pressed do
			(
				
				MOTools_MaterialSlotNumber = medit.GetActiveMtlSlot()
				MOTools_MaterialNumber = meditMaterials[MOTools_MaterialSlotNumber].materialList.count

				for i=1 to MOTools_MaterialNumber do
				(

					meditMaterials[MOTools_MaterialSlotNumber].materialList[i].effectsChannel = i
				)
			)
		
		on motools_materialtools_createBasic_button pressed do
		(
			setMeditMaterial (medit.GetActiveMtlSlot()) (MOTools_MultiMaterialBasic create motools_materialtools_createMMtlAmount_spinner.value)
		
		)
		
		on motools_materialtools_createVray_button pressed do
		(
			setMeditMaterial (medit.GetActiveMtlSlot()) (MOTools_MultiMaterialVray create motools_materialtools_createMMtlAmount_spinner.value)
		)		
		
		on motools_materialtools_createCar_button pressed do
		(
			setMeditMaterial (medit.GetActiveMtlSlot()) (MOTools_MultiMaterialCars create)
		)
		
		on motools_materialtools_createPlaneInteriorseat_button pressed do
		(
			setMeditMaterial (medit.GetActiveMtlSlot()) (MOTools_MultiMaterialVray create)
				MOTools_MultiMaterialVray[1].name = "Upholstry"				
				MOTools_MultiMaterialVray[2].name = "Armrest / Cap"
				MOTools_MultiMaterialVray[3].name = "Headrest"
				MOTools_MultiMaterialVray[4].name = "IFE Plastic"
				MOTools_MultiMaterialVray[5].name = "IFE Screen"
				MOTools_MultiMaterialVray[11].name = "Tray"					
				MOTools_MultiMaterialVray[6].name = "Metal-Seat"			
				MOTools_MultiMaterialVray[7].name = "SidePan"
				MOTools_MultiMaterialVray[8].name = "Rubstrip"
				MOTools_MultiMaterialVray[9].name = "Seatbelt Strap"
				MOTools_MultiMaterialVray[10].name = "Seatbelt Metal"
				MOTools_MultiMaterialVray[11].name = "Remote"
				MOTools_MultiMaterialVray[12].name = "Extra01"
				MOTools_MultiMaterialVray[13].name = "Extra02"
				MOTools_MultiMaterialVray[14].name = "Extra03"
				MOTools_MultiMaterialVray[15].name = "Extra04"
		)
	
	)

	/* Rendering Tools Rollout ----------------------------------------------------------------------------------------------------------------------------------------------------- */
	motools_rendertools_text = ("Render Settings is : Standard Quality")
	rollout motools_rendertools "Rendering"
	(
		group "Linear Workflow Check"
		(				
			button motools_linearcheck_Button "Check Scene"
			button motools_forcelinear_Button "Convert to Linear" across:2			
			button motools_forceclassic_Button "Convert to Classic"
		)

		group "Quick Render Settings"
		(
			button motools_rendertools_Button ">>-- Apply Render Setting --<<" enabled:(MOTools_CheckforVray VrayTrue)
			slider motools_rendertools_slider motools_rendertools_text range:[1,5,3] type:#integer ticks:6 enabled:(MOTools_CheckforVray VrayTrue)
			checkbox motools_rendertools_CB_AntiAlias "Anti-Alias" across:3 checked:true enabled:(MOTools_CheckforVray VrayTrue)
			checkbox motools_rendertools_CB_GI "GI" state:false checked:true enabled:(MOTools_CheckforVray VrayTrue)
			checkbox motools_rendertools_CB_Passes "Passes" checked:true enabled:(MOTools_CheckforVray VrayTrue)
			checkbox motools_rendertools_CB_MB "Motion Blur" across:2  checked:true enabled:(MOTools_CheckforVray VrayTrue)
			checkbox motools_rendertools_CB_DoF "DoF"  checked:false enabled:(MOTools_CheckforVray VrayTrue)	
		)	

		group "Production Render Elements Creation"
		(
				button motools_rendertools_autoelements_button "Create Elements" across:2 enabled:(MOTools_CheckforVray VrayTrue)
				button motools_rendertools_clearautoelements_button "Remove/Create Elements" across:2 enabled:(MOTools_CheckforVray VrayTrue)
		)
		
		on motools_linearcheck_Button pressed do (
		
			
			)
		
		on motools_rendertools_slider changed theState do
		(
			print motools_rendertools_slider.value
			if (motools_rendertools_slider.value == 1) then 
			(
				motools_rendertools_slider.text = "Render Settings is : PreViz"
				motools_rendertools_CB_AntiAlias.checked = false
				motools_rendertools_CB_GI.checked = false
				motools_rendertools_CB_passes.checked = false
				motools_rendertools_CB_MB.checked = false
				motools_rendertools_CB_Dof.checked = false
			)
			if (motools_rendertools_slider.value == 2) then 
			(
				motools_rendertools_slider.text = "Render Settings is : Low Quality"
				motools_rendertools_CB_AntiAlias.checked = true
				motools_rendertools_CB_GI.checked = false
				motools_rendertools_CB_passes.checked = false
				motools_rendertools_CB_MB.checked = false
				motools_rendertools_CB_Dof.checked = false
			)
			if (motools_rendertools_slider.value == 3) then 
			(
				motools_rendertools_slider.text = "Render Settings is : Standard Quality"
				motools_rendertools_CB_AntiAlias.checked = true
				motools_rendertools_CB_GI.checked = true
				motools_rendertools_CB_passes.checked = true
				motools_rendertools_CB_MB.checked = false
				motools_rendertools_CB_Dof.checked = false
			)
			if (motools_rendertools_slider.value == 4) then 
			(
				motools_rendertools_slider.text = "Render Settings is : Animation Quality"
				motools_rendertools_CB_AntiAlias.checked = true
				motools_rendertools_CB_GI.checked =true
				motools_rendertools_CB_passes.checked = true
				motools_rendertools_CB_MB.checked = true
				motools_rendertools_CB_Dof.checked = false
			)
			if (motools_rendertools_slider.value == 5) then 
			(
				motools_rendertools_slider.text = "Render Settings is : High Quality"
				motools_rendertools_CB_AntiAlias.checked = true
				motools_rendertools_CB_GI.checked =true
				motools_rendertools_CB_passes.checked = true
				motools_rendertools_CB_MB.checked = true
				motools_rendertools_CB_Dof.checked = true
			)
			
		)
		
		on motools_rendertools_autoelements_button pressed do (MOTools_RenderElements CreateElements)
		on motools_rendertools_clearautoelements_button pressed do (MOTools_RenderElementsMgr.removeallrenderelements();MOTools_RenderElements CreateElements)
		
	)

	/* MOCars for VRAY Tools Rollout --------------------------------------------------------------------------------------------------------------------------------------------------- */
	rollout motools_cartools "MOCars for VRAY"
	(
			label cartools2 "This is a simple and fast way to create" align:#center
			label cartools3 "a basic shader/elements for a Vehicle" align:#center
		
		group "Car Rig"
		(
			button cartools_CreateRig " Create Car Rig" enabled:false
			on cartools_CreateRig pressed do
			(	
							MOCarsConLayer = LayerManager.newLayerFromName "con_veh_MOCars"
							MOCarsConLayer = LayerManager.getLayerFromName "con_veh_MOCars"
							MOCarsConLayer.current = true						
							
							CarPointMaster = Point ()
							CarPointMaster.name = "con_veh_MOCarsCar_Master"
							CarPointMaster.pos = [0,0,0] 
							CarPointMaster.size = 50
							CarPointMaster.box = true
							CarPointMaster.wirecolor = White
							
							CarSplineMain = SplineShape pos:[0,0,0]
							CarSplineMain.name= "con_veh_MOCarsCar_Main"
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
							
							CarSplineBody = SplineShape pos:[0,0,13]
							CarSplineBody.name= "con_veh_MOCarsCar_Body"
							addNewSpline CarSplineBody
							addKnot CarSplineBody 1 #corner #line [-5,-5,70]
							addKnot CarSplineBody 1 #corner #line [-20,-5,70]						
							addKnot CarSplineBody 1 #corner #line [-20,-10,70]
							addKnot CarSplineBody 1 #corner #line [-30,0,70]
							addKnot CarSplineBody 1 #corner #line [-20,10,70]
							addKnot CarSplineBody 1 #corner #line [-20,5,70]
							addKnot CarSplineBody 1 #corner #line [-5,5,70]
							addKnot CarSplineBody 1 #corner #line [-5,20,70]
							addKnot CarSplineBody 1 #corner #line [-10,20,70]
							addKnot CarSplineBody 1 #corner #line [0,30,70]
							addKnot CarSplineBody 1 #corner #line [10,20,70]
							addKnot CarSplineBody 1 #corner #line [5,20,70]
							addKnot CarSplineBody 1 #corner #line [5,5,70]
							addKnot CarSplineBody 1 #corner #line [20,5,70]
							addKnot CarSplineBody 1 #corner #line [20,10,70]
							addKnot CarSplineBody 1 #corner #line [30,0,70]
							addKnot CarSplineBody 1 #corner #line [20,-10,70]
							addKnot CarSplineBody 1 #corner #line [20,-5,70]
							addKnot CarSplineBody 1 #corner #line [5,-5,70]
							addKnot CarSplineBody 1 #corner #line [5,-20,70]						
							addKnot CarSplineBody 1 #corner #line [10,-20,70]		
							addKnot CarSplineBody 1 #corner #line [0,-30,70]		
							addKnot CarSplineBody 1 #corner #line [-10,-20,70]		
							addKnot CarSplineBody 1 #corner #line [-5,-20,70]
							close CarSplineBody 1
							updateShape CarSplineBody						
							addModifier CarSplineBody (Bend())
							CarSplineBody.modifiers[#Bend].BendAxis = 1
							CarSplineBody.modifiers[#Bend].BendDir = -90
							CarSplineBody.modifiers[#Bend].BendAngle = 45
							modPanel.setCurrentObject CarSplineBody.modifiers[#Bend]	
							subobjectLevel = 2
							CarSplineBody.modifiers[#Bend].center += [0,0,57.649]							
							addModifier CarSplineBody (Bend())
							CarSplineBody.modifiers[#Bend].BendAxis = 1
							CarSplineBody.modifiers[#Bend].BendDir = -90
							CarSplineBody.modifiers[#Bend].BendAngle = 45
							modPanel.setCurrentObject CarSplineBody.modifiers[#Bend]	
							subobjectLevel = 1	
							CarSplineBody.modifiers[#Bend].gizmo.rotation += quat 0 0 0.707107 0.707107
							subobjectLevel = 2
							CarSplineBody.modifiers[#Bend].center += [0,0,57.649]							
							maxOps.CollapseNode CarSplineBody off							
							
							CarSplineFAxleNode = Point ()
							CarSplineFAxleNode.name = "con_veh_MOCarsCar_FAxleNode"
							CarSplineFAxleNode.pos = [0,-66,13] 
							CarSplineFAxleNode.size = 20
							freeze CarSplineFAxleNode
							
							CarSplineFAxle = SplineShape pos:[0,-66,13]
							CarSplineFAxle.name= "con_veh_MOCarsCar_FAxle"
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

							CarSplineRAxleNode = Point ()
							CarSplineRAxleNode.name = "con_veh_MOCarsCar_RAxleNOde"
							CarSplineRAxleNode.pos = [0,47,13] 
							CarSplineRAxleNode.size = 20
							freeze CarSplineRAxleNode
							
							CarSplineRAxle = SplineShape pos:[0,47,13]
							CarSplineRAxle.name= "con_veh_MOCarsCar_RAxle"
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

							CarSplineSteer = SplineShape pos:[0,-66,13]
							CarSplineSteer.name= "con_veh_MOCarsCar_Steer"
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
							CarSplineTireFR.name= "con_veh_MOCarsCar_TireFR"
							CarSplineTireFR.radius = 15
							CarSplineTireFR.rotation = quat 0 -0.707107 0 0.707107
							CarSplineTireFR.pos = [-32,-66,13]
							
							CarSplineTireFRNode = Point ()
							CarSplineTireFRNode.name = "con_veh_MOCarsCar_TireFRNode"
							CarSplineTireFRNode.pos = [-32,-66,13]
							CarSplineTireFRNode.size = 20
							freeze CarSplineTireFRNode
							
							CarSplineTireFL = circle pos:[0,0,0]
							CarSplineTireFL.name= "con_veh_MOCarsCar_TireFL"
							CarSplineTireFL.radius = 15
							CarSplineTireFL.rotation = quat 0 -0.707107 0 0.707107
							CarSplineTireFL.pos = [32,-66,13]
							
							CarSplineTireFLNode = Point ()
							CarSplineTireFLNode.name = "con_veh_MOCarsCar_TireFRNode"
							CarSplineTireFLNode.pos = [32,-66,13]
							CarSplineTireFLNode.size = 20
							freeze CarSplineTireFLNode
							
							CarSplineTireRR = circle pos:[0,0,0]
							CarSplineTireRR.name= "con_veh_MOCarsCar_TireRR"
							CarSplineTireRR.radius = 15
							CarSplineTireRR.rotation = quat 0 -0.707107 0 0.707107
							CarSplineTireRR.pos = [-32,47,13]
							
							CarSplineTireRRNode = Point ()
							CarSplineTireRRNode.name = "con_veh_MOCarsCar_TireRRNode"
							CarSplineTireRRNode.pos = [-32,47,13]
							CarSplineTireRRNode.size = 20
							freeze CarSplineTireRRNode
							
							CarSplineTireRL = circle pos:[0,0,0]
							CarSplineTireRL.name= "con_veh_MOCarsCar_TireRL"
							CarSplineTireRL.radius = 15
							CarSplineTireRL.rotation = quat 0 -0.707107 0 0.707107
							CarSplineTireRL.pos =[32,47,13]

							CarSplineTireRLNode = Point ()
							CarSplineTireRLNode.name = "con_veh_MOCarsCar_TireRLNode"
							CarSplineTireRLNode.pos = [32,47,13]
							CarSplineTireRLNode.size = 20
							freeze CarSplineTireRLNode

							--assigning parents						
							CarSplineMain.parent = CarPointMaster
							
							CarSplineBody.parent = CarSplineMain		
							CarSplineFAxle.parent = CarSplineMain
							CarSplineRAxle.parent = CarSplineMain					
							CarSplineSteer.parent = CarSplineMain
							
							CarSplineFAxleNode.parent = CarSplineFAxle
							CarSplineRAxleNode.parent = CarSplineRAxle

							CarSplineTireFRNode.parent = CarSplineTireFR
							CarSplineTireFLNode.parent = CarSplineTireFL
							CarSplineTireRRNode.parent = CarSplineTireRR
							CarSplineTireRLNode.parent = CarSplineTireRL
							
							CarSplineTireFR.parent = CarSplineFAxleNode
							CarSplineTireFL.parent = CarSplineFAxleNode
							CarSplineTireRR.parent = CarSplineRAxleNode
							CarSplineTireRL.parent = CarSplineRAxleNode
							
							--assigning lookat
							CarSplineBody.position.controller = Position_Constraint ()
							CarSplineBody.position.controller.RELATIVE = on
							CarSplineBody.position.controller.appendTarget CarSplineFAxleNode 50.0
							CarSplineBody.position.controller.appendTarget CarSplineRAxleNode 50.0
							
							CarSplineFAxleNode.rotation.controller = LookAt_Constraint ()
							--CarSplineFAxleNode.rotation.controller.RELATIVE = on
							CarSplineFAxleNode.rotation.controller.appendTarget CarSplineTireFR 50.0
							--CarSplineFAxleNode.rotation.controller.appendTarget CarSplineTireFL 50.0
							
			)
		)
		
		group "Elements"
		(
				button  motools_cartools_AutoElements_Button "Create Vray MOCars Car Elements" enabled:(MOTools_CheckforVray VrayTrue) tooltip:"Automaticly create a standard element passes. Comp will thank you."
				checkbox checkbox_cartools_removeall "Clear All Render Elements First?" checked:true align:#center enabled:(MOTools_CheckforVray VrayTrue)

				on motools_cartools_AutoElements_Button pressed do 
				(
					if (checkbox_cartools_removeall.state==false) then (MOTools_RenderElements CreateElements) else (MOTools_RenderElementsMgr.removeallrenderelements() ;MOTools_RenderElements CreateElements)
							
				)
		)
			
		group "Materials"
		(
			button cartools_AutoMaterial_Button "Create a MOCar Material in Editor" enabled:(MOTools_CheckforVray VrayTrue) tooltip:"Will overwrite your 1,2 material editor block"	 
			button cartools_AutoMaterialSelected_Button "Assign a MOCar Material (one Vehicle at a time)" enabled:(MOTools_CheckforVray VrayTrue) tooltip:"Usefull for retexturing one vehicle at a time."
			button cartools_SceneMaterial_Button "Auto MOCars all in scene" enabled:(MOTools_CheckforVray VrayTrue) tooltip:"This will look through your whole scene and try to re-color the base paint shader for all vehicles"
			
			dropdownlist dropdownlist_cartools_types "Vehicle Types" items:#("American Civillian (Cars/Trucks)", "Utility (Work Trucks)", "Emergency (Police/Fire/Rescue)","Military Green","Military Brown") enabled:false
				
			on cartools_AutoMaterial_Button pressed do
			(
				setMeditMaterial 1 (MOtools_mocar_VrayMat VrayMaterial)
				setMeditMaterial 2 (MOtools_mocar_defaultMat defaultMaterial)
			)		
			
			on cartools_AutoMaterialSelected_Button pressed do
			(			
				MOCars_BaseColor = MOtools_mocar_VrayMat VrayMaterial

				MOCars_UVWWaterSpots = Uvwmap ()
				MOCars_UVWWaterSpots.name = "MOtools_mocar_WaterSpots"
				MOCars_UVWWaterSpots.maptype = 4
				MOCars_UVWWaterSpots.length = 30.48
				MOCars_UVWWaterSpots.width = 30.48
				MOCars_UVWWaterSpots.height = 30.48
				MOCars_UVWWaterSpots.mapChannel = 11			
				
				modPanel.addModToSelection MOCars_UVWWaterSpots
				
				$.material = MOCars_BaseColor			
				
			)
			
			on cartools_SceneMaterial_Button pressed do
			(
				for m in scenematerials do 
				(
				try (	
					MOCars_BaseColor = MOtools_mocar_RandomPaintColor RandomPaintColor
					m.materialList[1].base_color = MOCars_BaseColor
					m.materialList[1].flake_color = MOCars_BaseColor
					m.materialList[1].base_glossiness = (random 0.3 0.6)
					m.materialList[1].base_reflection = (random 0.3 0.5)
					m.materialList[1].flake_glossiness = (random 0.3 0.5)
				
				) catch ()
				)
			)		
		)
		
	)

	rollout motools_MaxProgram "Max Program Settings"
	(	
		group "Retimer Bugs / Slow Viewport"
		(
			Button motools_MaxProgram_bugsRetimerall "Remove All retimers" across:2
			Button motools_MaxProgram_bugsRetimerUnused "Remove empty retimers"
		)
		
		group "Orphan Window reseting"
		(
			Button motools_MaxProgram_resetWindows "Reset all window to " tooltip:"" enabled:false 
		)
		
		group "System Information"
		(
			Button motools_MaxProgram_systeminfodump "Print System Info to Listener"
			Button motools_MaxProgram_mappathsdump "Print all maps paths to listener" enabled:false
		)
		
		on motools_MaxProgram_bugsRetimerall press do
		(
			print "hello"
			t=trackviewnodes
			n=t[#Retimer_Manager]
			deleteTrackViewController t n.controller
			gc()
		)
		
		on motools_MaxProgram_bugsRetimerUnused press do
		(
			nrt=RetimerMan.numRetimers
			for i = 1 to nrt do
			(
				j=nrt-i+1
				n=RetimerMan.GetNthRetimer j
				if n!=undefined then
				(
					if n.nummarkers==0 then
					(
						RetimerMan.DeleteRetimer j
					)
				)
			)		
		)
		
		on motools_MaxProgram press do
		(		
			mouse.screenpos
		)
		
		on motools_MaxProgram_systeminfodump pressed do
		(
			print "Start System Info Dump" 
			print "-----------------------"
			format "Time Stamp				: %\n" localTime 
			format "User Name				: %\n" sysInfo.username
			format "Computer Name			: %\n" sysInfo.computername
			print "-----------------------"
			format "Windows Folder			: %\n" sysInfo.windowsdir
			format "System Folder			: %\n" sysInfo.systemdir 
			format "Temp Folder				: %\n" sysInfo.tempdir 
			format "Current Folder			: %\n" sysInfo.currentdir
			print "-----------------------"			
			format "CPU Count				: %\n" sysInfo.cpucount 
			format "Desktop size			: %\n" sysInfo.desktopSize
			format "Desktop BPP				: %\n" sysInfo.desktopBPP
			format "3dsMax Priority			: %\n" sysInfo.MAXPriority
			format "3dsMax Affinity			: %\n" sysinfo.processAffinity 
			format "System Affinity			: %\n" sysinfo.systemAffinity
			print "-----------------------"
			format "Geometry				: %\n" objects.count
			format "Lights					: %\n" lights.count
			format "Cameras					: %\n" cameras.count
			format "Helpers					: %\n" helpers.count			
			format "Shapes					: %\n" shapes.count
			format "Particle System			: %\n" systems.count		
			format "Space Warps				: %\n" spacewarps.count
			format "Scene Materials			: %\n" sceneMaterials.count
			print "-----------------------"	
			
			print "-----------------------"
			print "Ending System Info Dump"
		)		
		
		on motools_MaxProgram_mappathsdump pressed do
		(		
		)
		
	)	

	/* Settings Rollout --------------------------------------------------------------------------------------------------------------------------------------------------- */
	rollout motools_settings "Settings"
	(
	)
		
	
	/* Roll out Area --------------------------------------------------------------------------------------------------------------------------------------------------- */
	
	print ("Starting Mikes_Everday_Tools www.mikeoakley.com "+ localtime)	

	MOTools = newRolloutFloater "Mike's Everyday Tools" 300 800

	addRollout motools_welcome MOTools rolledUp:false
	
	addRollout motools_copytools MOTools rolledUp:false
		
	
	addRollout motools_scenelayout MOTools rolledUp:true
		motools_scenelayout.CreateMasterNode_button.tooltip = "Creates a master Node at zero space, then links everything selected to it"
		motools_scenelayout.CorrectNames_button.tooltip = "Based on teh type of objects this will add a prefix"
		motools_scenelayout.Geo_Lock.tooltip = "Lock selected position, rotation, scale"
		motools_scenelayout.Geo_UnLock.tooltip = "Unlock selected position, rotation, scale"
		motools_scenelayout.Geo_Locks_pos.tooltip = "Position"
		motools_scenelayout.Geo_Locks_rot.tooltip = "Rotation"
		motools_scenelayout.Geo_Locks_scale.tooltip = "Scale"
		motools_scenelayout.Initilize_button.tooltip = "Moves all selected pivots to zero space. Useful when rigging"
		
	addRollout motools_animationtools MOTools rolledUp:true
		motools_animationtools.startframe.tooltip = "Start Frame"
		motools_animationtools.endframe.tooltip = "End Frame"
		motools_animationtools.geo_baketoNode_button.tooltip = "Will bake/copy objects Position,Rotation and Scale to a node"
		motools_animationtools.cartools_TurnTable_Button.tooltip = "Create a turn table with selected time range"
		motools_animationtools.cartools_TurnTable_dropdown.tooltip = "Select time you wish for turn table"	
		
	addRollout motools_shapetools MOTools rolledUp:true	
		
	addRollout motools_geotools MOTools rolledUp:true
		motools_geotools.geo_RanColor_Button.tooltip = "Random colors"
		motools_geotools.geo_RanBW_Button.tooltip = "Random grays"
		motools_geotools.geo_RanPastel_Button.tooltip = "Random Pastels"
		motools_geotools.geo_RanHigh_Button.tooltip = "Random High Contrast Colors"
		motools_geotools.geo_RanColorRed_Button.tooltip = "Random red colors"
		motools_geotools.geo_RanColorGreen_Button.tooltip = "Random green colors"
		motools_geotools.geo_RanColorBlue_Button.tooltip = "Random blue colors"
		motools_geotools.ModifierStack_Button.tooltip = "Collapes all selected modifiers"
		motools_geotools.geo_GBufferRandom_Button.tooltip = "Randomize the G-Buffer ID Channel 1-15 "
		motools_geotools.geo_GBufferStrip_Button.tooltip = "Reset the G-Buffer ID Channel to ID 0"
		
	addRollout motools_cameratools MOTools rolledUp:true
		
	addRollout motools_lightingtools MOTools rolledUp:true
	
	addRollout motools_materialtools MOTools rolledUp:true
		motools_materialtools.motools_materialtools_Selected_button.tooltip = "Match Marierial ID's to the Material Channel Number on selected Material"
		motools_materialtools.motools_materialtools_All_button.tooltip = "Match Marierial ID's to the Material Channel Number on all"
		motools_materialtools.motools_materialtools_createBasic_button.tooltip = "Creates a Multi-Material: Basic max shaders"
		motools_materialtools.motools_materialtools_createVray_button.tooltip = "Creates a Multi-Material: Basic Vray shaders"
		motools_materialtools.motools_materialtools_createCar_button.tooltip = "Creates a Multi-Material: Used for Cars setups"
		motools_materialtools.motools_materialtools_createPlaneInteriorseat_button.tooltip = "Creates a Multi-Material: Used for standard Plane seats"
		motools_materialtools.motools_materialtools_createPlaneInterior_button.tooltip = "Creates a Multi-Material: Used for standard Plane Interiors"
		motools_materialtools.motools_materialtools_createPlaneExterior_button.tooltip = "Creates a Multi-Material: Used for standard Plane Exteriors" 
		
	addRollout motools_rendertools MOTools rolledUp:true
		motools_rendertools.motools_rendertools_Button.tooltip = "Apply to render setup based on settings below *Will Overwrite*"
		motools_rendertools.motools_rendertools_CB_AntiAlias.tooltip = "nil"
		motools_rendertools.motools_rendertools_CB_GI.tooltip = "nil"
		motools_rendertools.motools_rendertools_CB_Passes.tooltip = "nil"
		motools_rendertools.motools_rendertools_CB_MB.tooltip = "nil"
		motools_rendertools.motools_rendertools_CB_DoF.tooltip = "nil"
		motools_rendertools.motools_rendertools_autoelements_button.tooltip = "nil"
		motools_rendertools.motools_rendertools_clearautoelements_button.tooltip = "nil"
		motools_rendertools.motools_rendertools_autoelements_button.tooltip = "Adds Production style Render elements"
		motools_rendertools.motools_rendertools_clearautoelements_button.tooltip = "Clears ALL Elements"
		
	addRollout motools_ffxtools MOTools rolledUp:true
		
	
	/*addRollout motools_cartools MOTools rolledUp:true*/
	
	addRollout motools_MaxProgram MOTools rolledUp:true
		motools_MaxProgram.motools_MaxProgram_bugsRetimerAll.tooltip = "If you have hundreds or even thousands of Retimers in your scene file that becomes unmanageable, this post shows a couple of approaches for cleaning them out using MAXScript."
		motools_MaxProgram.motools_MaxProgram_bugsRetimerUnused.tooltip = "If you have hundreds or even thousands of Retimers in your scene file that becomes unmanageable, this post shows a couple of approaches for cleaning them out using MAXScript."
		motools_MaxProgram.motools_MaxProgram_resetWindows.tooltip = "Resets max floaters"
		motools_MaxProgram.motools_MaxProgram_systeminfodump.tooltip = "Dumps all system information to the listner window"
		motools_MaxProgram.motools_MaxProgram_mappathsdump.tooltip = "Dumps all map paths to the listner window"
		
	addRollout motools_settings MOTools rolledUp:true


	/*Tool Tips text*/	

		
		
	
	


	/*  
	encryptScript "MOTools_Source.ms"
	*/
	
	
	
)