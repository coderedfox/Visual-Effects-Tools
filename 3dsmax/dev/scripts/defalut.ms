
/*

Mike Oakley Tools

mikeoakley@mikeoakley.com
www.mikeoakley.com


*/



/* Start Script */
rollout MOTools "MOTools - ?"
(
	
)


/* End Script */


try (DestroyDialog MOTools) catch()
print "Starting Mikes_Everday_Tools www.mikeoakley.com "	
/*button btn_button "?" width:20 height:20 align:#right*/

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

CreateDialog MOTools 500 500 style:#(#style_titlebar, #style_sysmenu) menu:MOTools_MainMenu


