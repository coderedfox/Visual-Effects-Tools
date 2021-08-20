/*******************************************************************************
* Render Element Re-Pather
* Author: Mike Okaley
* Date: 2012
*******************************************************************************/

format "Started:--------------- Render Element Re-Pather"

rollout RenderElementPather "RenderElementPather v02" width:710 height:421
(
	label lbl1 "Render System Info:" pos:[1,1] width:199 height:18
	
	label lbl2 fileInfo pos:[1,30] width:199 height:18
	label lbl3 rendOutputFilename pos:[1,60] width:199 height:18
	editText edt1 "Path" pos:[1,90] width:379 height:23	
	button button_repath "Yo hommie"

	on button_repath pressed do (		
		GetPath = getFileNamePath rendOutputFilename
		GetMaxName = getFilenameFile maxFileName

		theManager = maxOps.GetRenderElementMgr #Production
		theManager.numrenderelements()

		for n = 0 to (theManager.numrenderelements () - 1) do
			(

				el = re.getrenderelement n
				newFileName = GetPath + GetMaxName + "_" + el.elementname  + ".exr"		
				re.SetRenderElementFileName n newFileName 
			)
	)	
)

theNewFloater = newRolloutFloater "RenderElementPather" 800 800
addRollout RenderElementPather theNewFloater
