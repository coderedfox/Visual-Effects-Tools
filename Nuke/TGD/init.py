#
# www.TenGunDesign.com
#
# 2020-02-19
#
import nuke
import os
import inspect


thisFile = inspect.getfile(inspect.currentframe())
thisFolder = os.path.dirname(thisFile)  
thisName = os.path.basename(thisFolder)

for (path, dirs, files) in os.walk('%s' % thisFolder):
    nuke.pluginAddPath(os.path.basename(path))
    if Nuke_Debug : print "DEBUG " + thisFile + " Path : " + path
    
    
#debug
if Nuke_Debug : print "DEBUG " + inspect.getfile(inspect.currentframe())