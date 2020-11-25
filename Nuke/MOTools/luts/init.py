import nuke
import os
import inspect

# Get file and folder Var
thisFile = inspect.getfile(inspect.currentframe())
thisFolder = os.path.dirname(thisFile)  

for (path, dirs, files) in os.walk('%s' % thisFolder):
    for curFile in files:
        nodeName = os.path.splitext(curFile)[0]
        if os.path.splitext(curFile)[1].lower() == '.gizmo':
            nuke.ViewerProcess.register(nodeName, nuke.Node,(nodeName,''))            

# Sets TGD_RGB_PS  as the default LUT  
