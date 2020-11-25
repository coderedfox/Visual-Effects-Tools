macroScript MOTools
category:"MOTools"
buttonText:"MOTools"
toolTip:"MOTools : Every day tools we all need"
icon: #("icons\MOTools",1)

(
/* Try to close already opened MOTools */
		try (closeRolloutFloater MOTools) catch()
		
/* Load INI File */
		// getINISetting "MOTools.ini" "Directories" "Scenes"
	
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
		Global MOTools_geotools = ""
		Global MOTools_Selection = #();
		
/* Functions Start  include "MOTools_Functions.ms" */
	/* Define functions as : MOTools_*NAME*  */
	
		fn MOTools_CheckForVray VrayTrue = (
			/* Checks if Vray is the render */
			if (renderers.current as string) == ((vray as string) + ":" + (vray as string)) then (True) else (false)
		)
	
		fn MOTools_RandomRGB Minimum Maximum = (
			/* Random Colors from a Minimum to maximum number */
			color (random Minimum Maximum) (random Minimum Maximum) (random Minimum Maximum)
		)
		
		fn MOTools_PositionRandomize Amounts = (	
			/* Turns on spinners */	
			motools_geotools.spinner_RandomizePositionX.enabled = Amounts
			motools_geotools.spinner_RandomizePositionY.enabled = Amounts
			motools_geotools.spinner_RandomizePositionZ.enabled = Amounts
			motools_geotools.spinner_RandomizeRotationX.enabled = Amounts
			motools_geotools.spinner_RandomizeRotationY.enabled = Amounts
			motools_geotools.spinner_RandomizeRotationZ.enabled = Amounts
			motools_geotools.spinner_RandomizeScaleX.enabled = Amounts
			motools_geotools.spinner_RandomizeScaleY.enabled = Amounts
			motools_geotools.spinner_RandomizeScaleZ.enabled = Amounts
		)
		
		fn MOTools_CreateMultiMaterial MatType MatAmount = (	
			/*
				Creates a Pre Defind MultiMaterial
				- MatType = Standardmaterial or VrayMtl
				- MatAmount = Amount of Sub-Materials
			*/		
			MOTools_MultiMaterialBasic = multimaterial()
			MOTools_MultiMaterialBasic.name = ("MMaterial_"+(random 1 100 as string))			
			MOTools_MultiMaterialBasic.numsubs = amount
			
				for i = 1 to amount do
				(
					MOTools_MultiMaterialBasic[i] = MatType()
					MOTools_MultiMaterialBasic[i].name = (i as string)
					MOTools_MultiMaterialBasic[i].diffuse = (MOTools_ColorsRandom color)
					if i <= 15 then (MOTools_MultiMaterialBasic[i].effectsChannel = i) else (MOTools_MultiMaterialBasic[i].effectsChannel = 15)
				)			
			defaultMaterial = MOTools_MultiMaterial
		)
								
		fn MOTools_ProductionRenderElements CreateNewElements = (
			// Create Production Elements
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
			
			// Create AO maeterial
					MOTools_RenderElements_AOMaterial = VrayDirt()
					MOTools_RenderElements_AOMaterial.name = "AO"
					MOTools_RenderElements_AOMaterial.radius = 200.00
					MOTools_RenderElements_AOMaterial.occluded_color = blue
					MOTools_RenderElements_AOMaterial.unoccluded_color = red
					MOTools_RenderElements_AOMaterial.radius = 200.00						
				MOTools_RenderElementsMgr.addrenderelement (VrayExtraTex elementname:("UpDown") texture:MOTools_RenderElements_UpDownMaterial)
			// Create Falloff material
					MOTools_RenderElements_UpDownMaterial = falloff()
					MOTools_RenderElements_UpDownMaterial.name = "UpDown"
					MOTools_RenderElements_UpDownMaterial.type = 0
					MOTools_RenderElements_UpDownMaterial.color1 = red
					MOTools_RenderElements_UpDownMaterial.color2 = blue
					MOTools_RenderElements_UpDownMaterial.direction = 9	
			// Create Mattes
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
		
/* Rollouts */	
	/* Welcome and Info */
		rollout motools_welcome "Welcome to MOTools" 
		(	
			label motools_welcome_01 "***BETA***"
			label motools_welcome_02 "Every day tools we all need"
			label motools_welcome_03 MOTools_Version
			hyperLink motools4 "Help File @ mikeoakley.com" address:"http://www.mikeoakley.com/tips/mikes-everyday-tools/" align:#center
		)
		
	/* Copy / Paste Rollout */
		rollout motools_Files "Copy / Paste"
		(
			button motools_copytools_Copy "Copy" offset: [-110,0]
			button motools_copytools_MtlCopy "Mtl Copy" offset: [-50,-26] enabled:false		
			button motools_copytools_NetCopy "Net Copy" offset: [15,-26] enabled:false
			button motools_copytools_NetMtlCopy "Net Mtl Copy" offset: [90,-26] enabled:false

			button motools_copytools_Paste "Paste" offset: [-110,0] tooltip:"Local Paste between Max's"
			button motools_copytools_MtlPaste "Mtl Paste" offset: [-50,-26]	enabled:false	
			button motools_copytools_NetPaste "Net Paste" offset: [15,-26] enabled:false
			button motools_copytools_NetMtlPaste "Net Mtl Paste" offset: [90,-26] enabled:false
		)

	/* Scene Control */	
		rollout motools_SceneControl "Scene Control"
		(
			group "Random Wire Colors"
			(
				label motools_label_01 "Please select object(s) to be re-colored" align:#center
				button motools_SceneControl_Rainbow_Button "Rainbow" across:4 tooltip:"All selected objects wire color are randomly picked"
				button motools_SceneControl_BandW_Button "Black & White" tooltip:"All selected objects wire color are randomly picked"
				button motools_SceneControl_Pastel_Button "Pastel" tooltip:"All selected objects wire color are randomly picked"
				button motools_SceneControl_Contrast_Button "Contrast" tooltip:"All selected objects wire color are randomly picked"
				checkbox geo_isinstance "Color Instance" checked:false
			)
				on motools_SceneControl_Rainbow_Button pressed do (if $ != undefined then (
						for obj in selection do	(		
							if geo_isinstance.state==true then (InstanceMgr.GetInstances obj &obj)								
							obj.wirecolor = MOTools_RandomRGB 50 220
						) 
					) else (messagebox "No objects selected !" title:"Warning" beep:true)					
				)
			
			
			
		)		
	
	/* Rendering */
		rollout motools_Render "Rendering"
		(
			group "G-Buffer ID control"
			(
				button motools_Render_GBufferRandom_Button "Randomize GBuffer ID's" tooltip:"All selected objects wire color are randomly picked" across:2
				button motools_Render_GBufferRemove_Button "Strip GBuffer ID's" tooltip:"All selected objects wire color are randomly picked"
			)
		)
	
	
	
	
/* Rollout Defind */		
		print ("Starting Mikes_Everday_Tools www.mikeoakley.com "+ localtime)
		MOTools = newRolloutFloater "Mike's Everyday Tools" 300 800

		
		addRollout MOTools_Welcome MOTools rolledUp:false

		addRollout MOTools_Files MOTools rolledUp:false
		
		addRollout motools_SceneControl MOTools rolledUp:true
		
		addRollout motools_Animation MOTools rolledUp:true
		
		addRollout motools_Shape MOTools rolledUp:true
		
		addRollout motools_Geometry MOTools rolledUp:true
		
		addRollout motools_Material MOTools rolledUp:true
		
		addRollout motools_Camera MOTools rolledUp:true
		
		addRollout motools_Lighting MOTools rolledUp:true
		
		addRollout motools_Render MOTools rolledUp:true
		
		addRollout motools_FumeFX MOTools rolledUp:true		
	
		addRollout motools_Settings MOTools rolledUp:true
		
	
)