






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