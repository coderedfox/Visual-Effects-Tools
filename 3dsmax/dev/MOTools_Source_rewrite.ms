--macroScript MOTools
--category:"MOTools"
--buttonText:"MOTools"
--toolTip:"MOTools : Every day tools we all need"
--icon: #("MOTools",1)

(
	/* Try to close already opened MOTools */
	global MOTools
	try(destroyDialog MOTools )catch()
	local LastSubRollout = 1

	/* Load INI File */
		-- getINISetting "MOTools.ini" "Directories" "Scenes"	
	
	/* Globals */
	/* Functions - Define as : MOTools_NAME  */
		fn MOTools_RenderElements CreateElements = (
			--create AO maeterial
				MOTools_RenderElements_AOMaterial = VrayDirt()
				MOTools_RenderElements_AOMaterial.name = "AO"
				MOTools_RenderElements_AOMaterial.radius = 2.00
				MOTools_RenderElements_AOMaterial.occluded_color = blue
				MOTools_RenderElements_AOMaterial.unoccluded_color = red										
			--create fall off material
				MOTools_RenderElements_UpDownMaterial = falloff()
				MOTools_RenderElements_UpDownMaterial.name = "UpDown"
				MOTools_RenderElements_UpDownMaterial.type = 0
				MOTools_RenderElements_UpDownMaterial.color1 = red
				MOTools_RenderElements_UpDownMaterial.color2 = blue
				MOTools_RenderElements_UpDownMaterial.direction = 9													
			--create Render Elements
				MOTools_RenderElementsMgr.addrenderelement (VRayOptionRE elementname:("MultiLayer_EXR_Addition"))			
				MOTools_RenderElementsMgr.addrenderelement (VRayDiffuseFilter elementname:("Element_VRayDiffuse"))			
				MOTools_RenderElementsMgr.addrenderelement (VRayLighting elementname:("Element_VRayLighting"))
				MOTools_RenderElementsMgr.addrenderelement (VRayGlobalIllumination elementname:("Element_VRayGlobalIllumination"))
				MOTools_RenderElementsMgr.addrenderelement (VRayReflection elementname:("Element_VRayReflection"))
				MOTools_RenderElementsMgr.addrenderelement (VRayRefraction elementname:("Element_VRayRefraction"))
				MOTools_RenderElementsMgr.addrenderelement (VRaySpecular elementname:("Element_VRaySpecular"))
				MOTools_RenderElementsMgr.addrenderelement (VRayShadows elementname:("Element_VRayShadows"))
					
				MOTools_RenderElementsMgr.addrenderelement (VRayBumpNormals elementname:("AOV_VRayBumpNormals") filterOn:false)
				MOTools_RenderElementsMgr.addrenderelement (VRayNormals elementname:("AOV_VRayNormals") filterOn:false)			
				MOTools_RenderElementsMgr.addrenderelement (VRayZDepth elementname:("AOV_VRayZDepth") zdepth_use_camera_clip_boudaries:false zdepth_min:0 zdepth_max:500 invert_zdepth:false clamp_zdepth:false filterOn:false)
				MOTools_RenderElementsMgr.addrenderelement (VRayVelocity elementname:("AOV_VRayVelocity") clamp_velocity:false max_velocity:1.0 filterOn:false)	
				MOTools_RenderElementsMgr.addrenderelement (VrayExtraTex texture:MOTools_RenderElements_AOMaterial elementname:("AOV_AO"))
				MOTools_RenderElementsMgr.addrenderelement (VrayExtraTex texture:MOTools_RenderElements_UpDownMaterial elementname:("AOV_UpDown"))
				MOTools_RenderElementsMgr.addrenderelement (VRaySamplerInfo elementname:("AOV_WorldPoint") clamp_velocity:false max_velocity:1.0 filterOn:false)
				
				MOTools_RenderElementsMgr.addrenderelement (VRayObjectID elementname:("Matte_VRayObjectID") filterOn:false)			
				MOTools_RenderElementsMgr.addrenderelement (VRayRenderID elementname:("Matte_VRayRenderID") filterOn:false)				
				MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("Matte_Mat_01_02_03") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:1 G_gbufID:2 B_gbufID:3)
				MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("Matte_Mat_04_05_06") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:4 G_gbufID:5 B_gbufID:6)
				MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("Matte_Mat_07_08_09") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:7 G_gbufID:8 B_gbufID:9)
				MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("Matte_Mat_10_1112") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:10 G_gbufID:11 B_gbufID:12)
				MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("Matte_Mat_13_14_15") MatID:true R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:13 G_gbufID:14 B_gbufID:15)
				MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("Matte_Geo_01_02_03") MatID:false R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:1 G_gbufID:2 B_gbufID:3)
				MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("Matte_Geo_04_05_06") MatID:false R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:4 G_gbufID:5 B_gbufID:6)
				MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("Matte_Geo_07_08_09") MatID:false R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:7 G_gbufID:8 B_gbufID:9)
				MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("Matte_Geo_10_11_12") MatID:false R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:10 G_gbufID:11 B_gbufID:12)
				MOTools_RenderElementsMgr.addrenderelement (MultiMatteElement elementname:("Matte_Geo_13_14_15") MatID:false R_gbufIDOn:true G_gbufIDOn:true B_gbufIDOn:true R_gbufID:13 G_gbufID:14 B_gbufID:15)
		)	
	
	
	
	
	
	
	/* Rollouts */
		/* Info and Settings */
			rollout MOTools_Settings "Welcome to MOTools" 
			(	
				label motools_welcome_01 "***BETA***"
				label motools_welcome_02 "Every day tools we all need"
				label motools_welcome_03 MOTools_Version
				hyperLink motools4 "Help File @ mikeoakley.com" address:"http://www.mikeoakley.com/tips/mikes-everyday-tools/" align:#center
			)
			
		/* Copy / Paste Rollout */
			rollout MOTools_Files "Copy / Paste"
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
	
	

	MOTools_Rollouts = #(
		#("Animation",#()),
		#("Camera",#()),
		#("Objects",#()),
		#("Lighting",#()),
		#("Material",#()),
		#("Render",#()),
		#("Shape",#()),
		#("Settings",#(MOTools_Settings,MOTools_Files))	
			
	)	

	rollout MOTools "Mike's Everyday Tools"
	(
	dotNetControl dn_tabs "System.Windows.Forms.TabControl" height:20 width:420 align:#center
	subRollout theSubRollout width:420 height:580 align:#center

	on dn_tabs Selected itm do
	(
	if LastSubRollout != (itm.TabPageIndex+1) do --do not update if the same tab clicked twice
	(
	for subroll in MOTools_Rollouts[LastSubRollout][2] do
	removeSubRollout theSubRollout subroll
	for subroll in MOTools_Rollouts[LastSubRollout = itm.TabPageIndex+1][2] do	
	addSubRollout theSubRollout subroll
	) 
	)--end tabs clicked	

	on MOTools open do
	(
	for aTab in MOTools_Rollouts do
	(
	dn_tabs.TabPages.add aTab[1]
	)
	for subroll in MOTools_Rollouts[1][2] do 
	addSubRollout theSubRollout subroll	
	)
	)

	createDialog MOTools 440 600
)