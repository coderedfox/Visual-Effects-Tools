# www.mikeoakley.com

import nuke
import os
import inspect

# Get file and folder Var
thisFile = inspect.getfile(inspect.currentframe())
thisFolder = os.path.dirname(thisFile)  
thisName = os.path.basename(thisFolder)

# set ups Node names
toolbar = nuke.menu('Nodes')   
menu = toolbar.addMenu(thisName, thisName+'.png',index=-1)  

# Search Folders for Files
for (path, dirs, files) in os.walk('%s' % (thisFolder)):
    categories = path.replace(thisFolder,'').replace('\\','/').title()
    categories = categories[1:] 
    path = path.replace('\\','/')

    menu.addMenu(categories,categories+'.png')
    
    for curFile in files:
        nodeName = os.path.splitext(curFile)[0]
        
        # Finds and loads Gizmos 
        if os.path.splitext(curFile)[1].lower() == '.gizmo':
            menu.addCommand('%s/%s' % (categories, nodeName) , 'nuke.createNode("%s")' % (nodeName), icon=(nodeName+'.png') )
            if Nuke_Debug : print "DEBUG " + thisFile + " .gizmos : " + categories +"/"+ nodeName
         
        # Finds and loads .NK
        if os.path.splitext(curFile)[1].lower() == '.nk':
            menu.addCommand('%s/%s' % (categories, nodeName) , 'nuke.nodePaste("/%s/%s.nk")' % (path,nodeName), icon=(nodeName+'.png'))
            if Nuke_Debug : print "DEBUG " + thisFile + " .nk : " + categories +"/"+ nodeName
            
        # Finds and Loads .PY
        #if os.path.splitext(curFile)[1].lower() == '.py':
            #if nodeName != "init" and nodeName != "menu" and nodeName != "MOTools":
                #menu.addCommand('%s/%s' % (categories, nodeName), 'import %s; %s.create_%s()' % (nodeName,nodeName,nodeName), icon=(nodeName+".png"))

#debug
if Nuke_Debug : print "DEBUG " + inspect.getfile(inspect.currentframe())