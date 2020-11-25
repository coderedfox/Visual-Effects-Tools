
/*

Mike Oakley Tools

mikeoakley@mikeoakley.com
www.mikeoakley.com


*/

/*------------------------------------------------------------------------------------------------------------*/

/* Start Script */
rollout MOTools "MOTools" --define a rollout and create a dialog 
(
	subrollout Geo1 "test1"	
	
)


/* End Script */


/*------------------------------------------------------------------------------------------------------------*/

/* Start Process */
try (DestroyDialog MOTools) catch()
print "Starting Mikes_Everday_Tools www.mikeoakley.com "	


/* File Menu */
rcmenu MOTools_MainMenu
(	
	subMenu "File"
		(
		)	
	
	subMenu "HELP / Links" 
		(
			menuItem MOTools_help_website "Help / Website"
			menuItem MOTools_about_website "About"
			menuItem MOTools_bugreport_website "Bug report"
		)		
		
		on MOTools_help_website picked do (shellLaunch "http:\\www.mikeoakley.com" "")		
		on MOTools_about_website picked do (messagebox "MOTools by Mike Oakley \n www.mikeoakley.com \n 2015" title:"About")		
		on MOTools_bugreport_website picked do (shellLaunch "http:\\www.mikeoakley.com" "")

		
)
registerRightClickMenu MOTools_MainMenu


/*------------------------------------------------------------------------------------------------------------*/

CreateDialog MOTools 500 100 style:#(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox, #style_resizing) menu:MOTools_MainMenu







