#
# Motools_AutoWrite.py
#
# 
#
#

import os
import sys
import re
import nuke

AutoWrite_Enabled = False

def dropAutoWrite():
    #creates a unique write node
    w = nuke.createNode('Write', inpanel=True)
    count = 1
    while nuke.exists('AutoWrite_' + str(count)):
        count += 1
    w.knob('name').setValue('AutoWrite_' + str(count))
    
    # Setup Defaults
    w.knob('channels').setValue('rgb')
    w.knob('colorspace').setValue('linear')    
    w.knob('colorspace').setValue('linear')    
    w.knob('file_type').setValue('targa')
    
    # Create extra tab for custom settings
    t = nuke.Tab_Knob("Auto Write Settings")
    w.addKnob(t)
    
    w.addKnob(nuke.File_Knob('AutoWrite_UserCompPath', 'Main Render Folder'))
    w.knob('AutoWrite_UserCompPath').setValue(nuke.getFilename("Select Nuke Render Folder"))
    w.addKnob(nuke.Text_Knob("divName","",""))
    w.addKnob(nuke.Boolean_Knob('AutoWrite_DisableVersioning','Disable Versioning'))
    w.addKnob(nuke.Boolean_Knob('AutoWrite_EnableNodeFileType','Append Node File Type to Node Name?'))
    w.addKnob(nuke.Text_Knob("divName","",""))
    w.addKnob(nuke.Text_Knob('none','','Extra Info i.e. _English, _Test, _Previz, _matte'))
    w.addKnob(nuke.EvalString_Knob('AutoWrite_Userextrainfo','Extra Info',''))
    
    # Create MOTools tab 
    mo = nuke.Tab_Knob("MOTools")
    w.addKnob(mo)
    w.addKnob(nuke.Text_Knob('none','','MOTools : www.mikeoakley.com'))
    w.addKnob(nuke.Text_Knob('none','','Version 20180423'))
    
    w.root.knob('onScriptSave')
    node.knob('autolabel')

def createWriteDir():
    file = nuke.filename(nuke.thisNode()) 
    dir = os.path.dirname( file ) 
    osdir = nuke.callbacks.filenameFilter( dir ) 
    try: 
        os.makedirs( osdir ) 
        return 
    except: 
        return

def updateOutput():
    try:
        n = nuke.thisNode()    
        AutoWrite_CompPath = n['AutoWrite_UserCompPath'].value()
        AutoWrite_extrainfo = n['AutoWrite_Userextrainfo'].value()
        AutoWrite_scriptPath = nuke.root()['name'].value()
        AutoWrite_scriptname = os.path.basename(nuke.Root().name()).split('_v')[0]
        AutoWrite_version = os.path.basename(nuke.Root().name()).split('_v')[1].split('.nk')[0]
        AutoWrite_filetype = n['file_type'].value()
        AutoWrite_seq = '####.'
        if AutoWrite_filetype == 'mov': AutoWrite_seq = ''
        
        if AutoWrite_filetype == 'jpeg': AutoWrite_filetype = 'jpg'
        elif AutoWrite_filetype == 'tiff': AutoWrite_filetype = 'tif'
        elif AutoWrite_filetype == 'targa': AutoWrite_filetype = 'tga' 
        
        # if AutoWrite_EnableNodeFileType == True : n.knob('name').setValue('AutoWrite_' + AutoWrite_filetype)
        
        AutoWrite_output = '%s%s/v%s/%s%s_v%s.%s%s' % (AutoWrite_CompPath, AutoWrite_scriptname, AutoWrite_version, AutoWrite_scriptname,AutoWrite_extrainfo,AutoWrite_version,AutoWrite_seq,AutoWrite_filetype )     
        
        
        n['file'].setValue(AutoWrite_output)
        return
    except: 
        return

# register functions
nuke.addKnobChanged( updateOutput, nodeClass="Write" )
nuke.addOnScriptSave(updateOutput)
nuke.addUpdateUI(updateOutput, nodeClass='Write')

