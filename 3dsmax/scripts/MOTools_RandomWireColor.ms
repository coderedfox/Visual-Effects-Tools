
/*

Mike Oakley Tools

mikeoakley@mikeoakley.com
www.mikeoakley.com


*/

rcmenu SMTD_MainRollout_MainMenu
	(
		subMenu "Presets"
		(
		)
	)
	


/* Start Script */
rollout MOTools_randomcolor "Geometry"
(	
	
	
	
	group "Random Wire Colors"
	(
			label geo1 "Please Select Objects to be re-colored" align:#center
			button geo_RanColor_Button "Random Colors" tooltip:"All selected objects wire color are randomly picked" across:2
			button geo_RanBW_Button "Random Black & White" tooltip:"All selected objects wire color are randomly picked" 
		
			button geo_RanColorRed_Button "Random Reds" tooltip:"All selected objects wire color are randomly picked" across:3
			button geo_RanColorGreen_Button "Random Greens" tooltip:"All selected objects wire color are randomly picked"
			button geo_RanColorBlue_Button "Random Blues" tooltip:"All selected objects wire color are randomly picked"
		
			on geo_RanColor_Button pressed do
			(
				if $ != undefined then
				(
					for obj in selection do
					(
						
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
						bwcolor = (random 1 220)+50
						obj.wirecolor = color (bwcolor) (bwcolor) (bwcolor)
					) 
				) else (messagebox "No objects selected !" title:"Warning" beep:true)					
			)
			
			on geo_RanColorRed_Button pressed do
			(
				if $ != undefined then
				(
					for obj in selection do
					(
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
						bwcolor = (random 1 230)+20
						obj.wirecolor = color (25) (25) (random 50 220)
					) 
				) else (messagebox "No objects selected !" title:"Warning" beep:true)					
			)
			
	)

)




/* End Script */

rollout MOTools_abouthelp "about/help" 
(	
	label motools1 "***BETA***"
	label motools2 "Every day tools we all need"
	label motools3 "Version 131206"
	hyperLink motools4 "Open web help file @ mikeoakley.com" address:"http://www.mikeoakley.com/tips/mikes-everyday-tools/" align:#center
)	

try (DestroyDialog MOTools_randomcolor) catch()
print "Starting Mikes_Everday_Tools www.mikeoakley.com "	
/*button btn_button "?" width:20 height:20 align:#right*/

CreateDialog SMTD_MainRollout 500 theHeight pos:thePos style:#(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox, #style_resizing)  menu:SMTD_MainRollout_MainMenu


createDialog MOTools_randomcolor 300 100
