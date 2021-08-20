
import nuke
import os
import inspect
import time


'''
This will add all subdirectories here to the Nuke Path
'''

curInitFile = inspect.getfile(inspect.currentframe()) # get location of current py file
fileDir = os.path.dirname(curInitFile) # get the dir name of that file

# for (path, dirs, files) in os.walk('%s' % (fileDir)):
#    nuke.pluginAddPath(path) # add to the nuke plugin path for each directory found

if Nuke_Debug : print ("DEBUG : " + thisFile )
for (path, dirs, files) in os.walk('%s' % fileDir):
    starttime = time.time()
    nuke.pluginAddPath(os.path.basename(path))
    if Nuke_Debug : print ("\t " + path + " | " + str(time.time() - starttime) + " sec")

#end