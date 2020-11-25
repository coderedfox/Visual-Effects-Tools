#
# MOTools.py
# www.MikeOakley.com
#
# MEL python("execfile('//bluefox/dev/git_repos/Maya/MOTools/MOTools.py')");
# Python execfile('//bluefox/dev/git_repos/Mike-Oakley-VFX/Maya/MOTools/MOTools.py')

import maya.cmds as mc, mtoa.aovs as aovs ,os, inspect, sys, platform

__version__ = "0.3.1"
PythonVersion = platform.python_version()

#thisFile = sys.argv[0]
#thisFolder = os.path.dirname(thisFile)  
#thisName = os.path.basename(thisFolder)

thisFile = sys.argv[0]
thisFolder = str("//bluefox/dev/git_repos/Mike-Oakley-VFX/Maya/MOTools/Icons/")
thisName = os.path.basename(thisFolder)

def FindFiles():    
        
    #thisFile = inspect.getfile(inspect.currentframe())
    thisFile = sys.argv[0]
    thisFolder = os.path.dirname(thisFile)  
    thisName = os.path.basename(thisFolder)
    
    print "thisFile : " + thisFile
    print "thisFolder : " + thisFolder
    print "thisName : " + thisName
    
    print sys.path.append('/path/to/script/directory')


## SHELF BUILDER ##
def _null(*args):
    pass

class _shelf():
    def __init__(self, name="MOTools", iconPath=thisFolder):
        self.name = name

        self.iconPath = iconPath

        self.labelBackground = (0, 0, 0, 0)
        self.labelColour = (.9, .9, .9)

        self._cleanOldShelf()
        mc.setParent(self.name)
        self.build()

    def build(self):
        pass
        
    #Add the first Button via Folders
    def addButon(self, label, iconname, command=_null, doubleCommand=_null):
        mc.setParent(self.name)
        if iconname:
            icon = self.iconPath + iconname
        mc.shelfButton(width=37, height=37, image=icon, l=label, command=command, dcc=doubleCommand, imageOverlayLabel="", olb=self.labelBackground, olc=self.labelColour)

    def addMenuItem(self, parent, label,iconname, command=_null, icon=".png"):
        if iconname:
            icon = self.iconPath + iconname
        return mc.menuItem(p=parent,image=icon, l=label, c=command, i="")

    def addSubMenu(self, parent, label, icon=None):
        if icon:
            icon = self.iconPath + label + icon
        return mc.menuItem(p=parent, l=label, i=icon, subMenu=1)

    def _cleanOldShelf(self):
        if mc.shelfLayout(self.name, ex=1):
            if mc.shelfLayout(self.name, q=1, ca=1):
                for each in mc.shelfLayout(self.name, q=1, ca=1):
                    mc.deleteUI(each)
        else:
            mc.shelfLayout(self.name, p="ShelfLayout")

## Tools ##

# Creates a scene and version tagging
def Set_SceneandVersion():
    try:
        currentFilePrefix = cmds.getAttr( "defaultRenderGlobals.imageFilePrefix")
        currentPath = cmds.file(q=True, sn=True)
        currentBaseName = os.path.basename(cmds.file(q=True, sn=True).split('.')[0])
        currentVersion = os.path.basename(cmds.file(q=True, sn=True)).split('.')[1].split('mb')[0]

        #set the Version Lable to the version
        cmds.setAttr("defaultRenderGlobals.renderVersion","v"+currentVersion,type="string")

        currentFilePrefix = currentFilePrefix.replace("<Scene>", str(currentBaseName))
        cmds.setAttr("defaultRenderGlobals.imageFilePrefix",currentFilePrefix,type="string")
        return
    except:
        cmds.confirmDialog(title='MOTools ERROR',icon='warning', message='File not set up as for versioning \n Ex: Myfile.001.mb',messageAlign='center' ,button=["Cancel"])
        return

def Load_AOV(type):
    if cmds.renderer( 'arnold', exists=True ):       
        if type == "basic": aov_list = ["N","coat","diffuse","emission","sheen","specular","transmission" ]
        if type == "direct": aov_list = ["N","coat_direct","coat_indirect","diffuse_direct","diffuse_indirect","emission","sheen_direct","sheen_indirect", "specular_direct", "specular_indirect", "transmission" ]
        if type == "technical": aov_list = ["AO","FacingRatio","P"]
        
        for aov in aov_list:
            try:
                print ("Adding " + aov + " to render aov list")
                aovs.AOVInterface().addAOV(aov)
                #AOs
                if aov == "AO":
                    createAOV = cmds.createNode("aiAmbientOcclusion" , name="aiAmbientOcclusion_ID")
                    cmds.connectAttr('aiAmbientOcclusion_ID.outColor' , 'aiAOV_AO.defaultValue')

                #FaceRatio
                if aov == "FacingRatio":
                    UtiD = cmds.createNode("aiFacingRatio" , name="aiFacingRatio_ID")
                    cmds.connectAttr('aiFacingRatio_ID.outValue' , 'aiAOV_FacingRatio.defaultValue')

            except:
                print ("ERROR: AOV " + aov + " already exists")
        

# Create MOTools shelf
class motools_Shelf(_shelf):
    def build(self):
        # master
        self.addButon(label="MOTools",iconname="MOTools.png", command='')

        # Help
        p = mc.popupMenu(b=1)
        self.addMenuItem(p, label="MOTools",iconname="",command='os.startfile("https://www.mikeoakley.com/wiki/motools-for-maya/")')
        self.addMenuItem(p, label="HELP",iconname="",command='os.startfile("https://www.mikeoakley.com/wiki/motools-for-maya/")')
        
        # Cameras
        self.addButon(label="Cameras",iconname="cameras.png")
        p = mc.popupMenu(b=1)
        
        # Modeling
        self.addButon(label="Modeling",iconname="modeling.png")
        p = mc.popupMenu(b=1)
        
        # FX
        self.addButon(label="FX",iconname="fx.png")
        p = mc.popupMenu(b=1)

        # Rendering
        self.addButon(label="Rendering",iconname="rendering.png")
        p = mc.popupMenu(b=1)
        self.addMenuItem(p, label="Set Scene and Version",iconname="SetSceneandVersion.png",command='Set_SceneandVersion()')

        # Arnold Options
        self.addButon(label="Arnold",iconname="Arnold.png")
        p = mc.popupMenu(b=1)
        self.addMenuItem(p, label="Load Standard AOV's",iconname="SetSceneandVersion.png",command='Load_AOV("basic")')
        self.addMenuItem(p, label="Load Direct AOV's",iconname="SetSceneandVersion.png",command='Load_AOV("direct")')
        self.addMenuItem(p, label="Load Technical AOV's",iconname="SetSceneandVersion.png",command='Load_AOV("technical")')

motools_Shelf()

# Prints out the code version and python version
print ("LOADED : MOTools.py | " + __version__ + " | Python : " + PythonVersion + " | MikeOakley.com")

#end