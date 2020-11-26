
/*

Mike Oakley Tools

mikeoakley@mikeoakley.com
www.mikeoakley.com


*/



/* Start Script */
rollout MOTools "MOTools" --define a rollout and create a dialog 
(
	subrollout Geo1 "test1"	
	
)

rollout Geo1 "test1a"
(
  spinner Ge2o "test1as"
)

/* End Script */


try (DestroyDialog MOTools) catch()
print "Starting Mikes_Everday_Tools www.mikeoakley.com "	

rcmenu MOTools_MainMenu
(	
	subMenu "HELP / Links" 
		(
			menuItem MOTools_bend "Help / Website"
			menuItem mi_twist "About"
		)		
		/*on mi_bend picked do  */	
)
registerRightClickMenu MOTools_MainMenu


CreateDialog MOTools 500 100 style:#(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox, #style_resizing) menu:MOTools_MainMenu

AddSubRollout MOTools.Geo1





