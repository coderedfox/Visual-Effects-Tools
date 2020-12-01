#
# MOTools.py
#
# www.MikeOakley.com
#
# 2020-02-19
#
# This includes AutoWrite, AutoExtract
#

import os, nuke, re, inspect, time, datetime, math, platform

# Variables      
infoScript = os.path.basename(inspect.getfile(inspect.currentframe()))
infoContact = "MikeOakley.com"
__version__ = "1.2.24"
PythonVersion = platform.python_version()

thisFile = inspect.getfile(inspect.currentframe())
thisFolder = os.path.dirname(thisFile)  
thisName = os.path.basename(thisFolder)
gizmoList = []

# Main UI set up
def setup_MOTools():
    for (path, dirs, files) in os.walk('%s' % thisFolder):
        nuke.pluginAddPath(os.path.basename(path))

def setup_MOTools_UI():
    if nuke.GUI:
        toolbar = nuke.menu('Nodes')   
        menu = toolbar.addMenu("MOTools", 'MOTools.png',index=-1) 

        # Auto Add Menu Items
        
        # Search Folders for Files
        for (path, dirs, files) in os.walk('%s' % (thisFolder)):
            categories = path.replace(thisFolder,'').replace('\\','/').title()
            categories = categories[1:] 
            path = path.replace('\\','/')

            menu.addMenu(categories,categories+'.png')            
            
            for curFile in files:
                nodeName = os.path.splitext(curFile)[0]
                if os.path.splitext(curFile)[1].lower() == '.gizmo': 
                    menu.addCommand('%s/%s' % (categories, nodeName) , 'nuke.createNode("%s")' % (nodeName), icon=(nodeName+'.png') )
                    print ("\t GIZMO : " + categories + " / " + nodeName)
                if os.path.splitext(curFile)[1].lower() == '.nk': 
                    menu.addCommand('%s/%s' % (categories, nodeName) , 'nuke.nodePaste("/%s/%s.nk")' % (path,nodeName), icon=(nodeName+'.png'))                    
                    print ("\t NK : " + categories + " / " + nodeName)
                

        #Accesibility
        
        #Automation
        menu = toolbar.addMenu("MOTools/Automation", 'Automation.png',index=-1) 
        menu.addCommand("AutoWrite", 'MOTools.create_AutoWrite()', icon='AutoWrite.png')
        menu.addCommand("AutoExtract", 'MOTools.autoExtractEXR()', icon='AutoExtract.png')
        menu.addCommand("ManualExtract", 'MOTools.manualExtractEXR()', icon='ManualExtract.png')
        menu.addCommand("Crop: Set to bbox", 'MOTools.Auto_Settobbox( )', icon='CroptoBbox.png')
        menu.addCommand("Crop: Set crop to Resolution", 'MOTools.Auto_CroptoResolution( )', icon='CroptoBbox.png')
        menu.addCommand("Contactsheet: Set resolution to inputs", 'MOTools.Auto_ContactSheet( )', icon='CroptoBbox.png')
        
        # Camera
        menu = toolbar.addMenu("MOTools/Camera", 'Camera.png',index=-1)
        menu.addCommand("EXR Maya to Nuke", 'MOTools.createCam_Cam_MayatoNuke( )', icon='Cam_MayatoNuke_EXR.png')
        menu.addCommand("EXR VRay to Nuke", 'MOTools.createCam_Cam_VraytoNuke( )', icon='Cam_VraytoNuke_EXR.png')
        
        # Enviroments
        menu = toolbar.addMenu("MOTools/Enviroments", 'Enviroments.png',index=-1)
        
        # FX
        menu = toolbar.addMenu("MOTools/FX", 'FX.png',index=-1)
        
        # Help
        menu = toolbar.addMenu("MOTools/Help", 'Help.png',index=-1)
        menu.addCommand("HELP Online at MikeOakey.com", 'nukescripts.start ("https://www.mikeoakley.com/wiki/motools-for-nuke/")', icon='Help.png')
                
        
        # Hidden
        menu = toolbar.addMenu("MOTools/Hidden", 'Hidden.png',index=-1)
        
        # Image
        menu = toolbar.addMenu("MOTools/Image", 'Image.png',index=-1)
        
        # IO
        menu = toolbar.addMenu("MOTools/IO", 'Image.png',index=-1)

        # Learning
        menu = toolbar.addMenu("MOTools/Learning", 'Help.png',index=-1)
        
        # Lens
        menu = toolbar.addMenu("MOTools/Lens", 'Lens.png',index=-1)
        
        # Mattes
        menu = toolbar.addMenu("MOTools/Mattes", 'Mattes.png',index=-1)
        
        # QC
        menu = toolbar.addMenu("MOTools/QC", 'QC.png',index=-1)
        
        # Rebuilds
        menu = toolbar.addMenu("MOTools/Rebuilds", 'Rebuilds.png',index=-1)
        
        # Vr
        menu = toolbar.addMenu("MOTools/Vr", 'Vr.png',index=-1)
        
        # Zebug
        menu = toolbar.addMenu("MOTools/Zebug", 'Zebug.png',index=-1)
        menu.addCommand("Postage Stamps ALL On", 'MOTools.PostageStamps_On()', icon='Zebug.png')
        menu.addCommand("Postage Stamps ALL Off", 'MOTools.PostageStamps_Off()', icon='Zebug.png')
        menu.addCommand("Postage Stamps ALL On Selected", 'MOTools.PostageStamps_Selected_On()', icon='Zebug.png')
        menu.addCommand("Postage Stamps ALL Off Selected", 'MOTools.PostageStamps_Selected_Off()', icon='Zebug.png')

        menu.addCommand("Preformance Timers On", 'nuke.startPerformanceTimers()', icon='Zebug.png')
        menu.addCommand("Preformance Timers Off", 'nuke.stopPerformanceTimers()', icon='Zebug.png')

        # This adds a global trigger to update the autowrite node when something changes.
        nuke.addUpdateUI(update_AutoWrite, nodeClass='Write')


# update the format code for autowrite
def updateformat_AutoWrite(thevalue):
    thisAutoWrite = nuke.thisNode()
    getvalue = thisAutoWrite['AW_userFormat'].value()
    thisAutoWrite['AW_userFormat'].setValue(getvalue + thevalue)

# Create autowrite node
def create_AutoWrite():
    try:
        # this just test the file
        test = os.path.basename(nuke.root().name()).split('_v')[1].split('.nk')[0]

        #creates a unique write node name
        AutoWrite = nuke.createNode('Write', inpanel=True)    
        count = 1
        while nuke.exists('AutoWrite_' + str(count)):
            count += 1
        AutoWrite.knob('name').setValue('AutoWrite_' + str(count))

        AutoWrite.addKnob(nuke.Text_Knob('AutoWrite_test','',"AutoWrite"))
                
        # Create AutoWrite Tab for settings
        AW_Settings = nuke.Tab_Knob('Auto Write Settings')
        AutoWrite.addKnob(AW_Settings)

        # Create AutoWrite UI
        AutoWrite.addKnob(nuke.File_Knob('AW_userCompPath', 'Render Dir : ',))
        AutoWrite['AW_userCompPath'].setValue("SET YOUR RENDER FOLDER HERE")
                    

        # Show Output
        AutoWrite.addKnob(nuke.EvalString_Knob('AW_show_output','OUTPUT: ',''))
        AutoWrite['AW_show_output'].setEnabled( False )

        # Script name
        AutoWrite.addKnob(nuke.EvalString_Knob('AW_autoScriptName','Script name : ',''))
        AutoWrite['AW_autoScriptName'].setEnabled( False )

        # Version number
        AutoWrite.addKnob(nuke.EvalString_Knob('AW_autoVersion','Version : ',''))
        AutoWrite['AW_autoVersion'].setEnabled( False )

        # Additional Information
        AutoWrite.addKnob(nuke.EvalString_Knob('AW_userInfo','Info : ',''))
        AutoWrite['AW_userInfo'].setValue( "Info" )

        # Auto Padding
        AutoWrite.addKnob(nuke.Int_Knob('AW_userPadding','Padding # :'))
        AutoWrite['AW_userPadding'].setValue( 4)

        # Auto Naming
        AutoWrite.addKnob(nuke.Boolean_Knob('AW_autoName','Auto Name?'))
        AutoWrite['AW_autoName'].setEnabled( False )

        AutoWrite.addKnob(nuke.Text_Knob('auto_divider01', '', ''))

        # Formating Options            
        AutoWrite.addKnob(nuke.EvalString_Knob('AW_userFormat','Format : ',''))
        AutoWrite['AW_userFormat'].setValue( 'Path/Script/Version/Script_Info_Version' )
        AutoWrite['AW_userFormat'].setFlag(nuke.ENDLINE)

        AutoWrite.addKnob(nuke.Text_Knob('auto_divider02', '', ''))

        AutoWrite_FormatOptions = ["/","_","Path","Script","Version","Info","Date"]
        for Options in AutoWrite_FormatOptions:
            AutoWrite.addKnob(nuke.PyScript_Knob("Options_"+Options,Options,'MOTools.updateformat_AutoWrite("'+Options+'")'))

        AutoWrite.addKnob(nuke.Text_Knob('auto_divider03', '', ''))

        # Add user info
        AutoWrite.addKnob(nuke.Text_Knob('data','',infoScript + " | " + infoContact + " | " + __version__))
        AutoWrite.addKnob(nuke.PyScript_Knob("help","?",'nukescripts.start ("https://www.mikeoakley.com/wiki/motools-for-nuke/")'))

        # Auto set file_type
        AutoWrite['file_type'].setValue('exr') 

        return
    except IndexError:
        nuke.message("ERROR: Version naming\nex: myfile_v001.nk\n Node will be deleted")
        nuke.delete(AutoWrite)
        return
    except:
        return     

# Update autowrite node
def update_AutoWrite():
        #AutoWrite = nuke.thisNode()
        AutoWriteAll = nuke.allNodes('Write')

        for AutoWrite in AutoWriteAll:
            try:
                check_test = AutoWrite['AutoWrite_test'].value()

                #print ( "Updating : " + AutoWrite['name'].value() )

                # system updates
                getdate = datetime.datetime.now()
                setdate = getdate.strftime("%y")+getdate.strftime("%m")+getdate.strftime("%d")

                #get the variables
                getUserCompPath = AutoWrite['AW_userCompPath'].value()
                getUserFormat = AutoWrite['AW_userFormat'].value()

                getAutoScriptName = os.path.basename(nuke.root().name()).split('_v')[0]
                getAutoVersion = 'v' +os.path.basename(nuke.root().name()).split('_v')[1].split('.nk')[0]
                getUserExtra = AutoWrite['AW_userInfo'].value()
                getUserPadding = AutoWrite['AW_userPadding'].value()
                getUserPadding = '.%0' + str(int(getUserPadding)) + 'd.'

                getUserFileType = AutoWrite['file_type'].value()
                
                # Changes the default file ext to three padded
                if getUserFileType == 'targa' : getUserFileType = 'tga'
                if getUserFileType == 'jpeg' : getUserFileType = 'jpg'
                if getUserFileType == 'tiff' : getUserFileType = 'tif'


                # Replaces text with data ["/","_","Path","Script","Version","Info","Date"]
                getUserFormat = getUserFormat.replace('Path',getUserCompPath)
                getUserFormat = getUserFormat.replace('Script',getAutoScriptName)
                getUserFormat = getUserFormat.replace('Version',getAutoVersion)
                getUserFormat = getUserFormat.replace('Info',getUserExtra)
                getUserFormat = getUserFormat.replace('Date',setdate)

                # set varibles
                AutoWrite['AW_autoScriptName'].setValue(getAutoScriptName)
                AutoWrite['AW_autoVersion'].setValue(getAutoVersion)
                
                AutoWrite['AW_show_output'].setValue(getUserFormat+getUserPadding+getUserFileType)
                    
                AutoWrite['file'].setValue(getUserFormat+getUserPadding+getUserFileType)

                #if AutoWrite['AW_autoName'].value() == True:
                    #Newname = "AutoWrite_"+getAutoScriptName+getAutoVersion+getUserFileType
                    #AutoWrite[Newname].setValue()
                return
            except NameError:
                return
            except:
                nuke.message("ERROR: update_AutoWrite failed to update")
                return
# end of AutoWrite


# Auto extracts EXR file to single EXRs
def autoExtractEXR():
    try: 
        if not nuke.selectedNode().Class() == 'Read' :
            nuke.message('Please select Read node\nthat has EXR information')
            return
        
        nodes = nuke.selectedNodes()
        
        for node in nodes:
            get_Path = nuke.filename( node )
            get_Dir = os.path.dirname ( get_Path )
            get_Filename = get_Path.split('/')[-1].split('.')[0]    

            get_colorspace = node['colorspace'].value()
            get_file_type = node['file_type'].value()  
                
            if node.Class() == 'Read':
                channels = node.channels()
                layers = list( set([channel.split('.')[0] for channel in channels]) )
                layers.sort()
                for layer in layers:
                    if layer == 'crypto_object' or layer == 'crypto_object01' or layer == 'crypto_object02':
                        print ("Skipping : " + layer)
                    else:
                        if layer == 'crypto_object00' :
                            # this does the convert diffrently but using a removenode
                            removeNode = nuke.nodes.Remove(label=layer,inputs=[node])
                            removeNode['operation'].setValue( 'keep' )
                            removeNode['channels'].setValue( 'rgba' )
                            removeNode['channels2'].setValue( 'crypto_object00' )
                        
                            writeNode = nuke.nodes.Write(label=layer,inputs=[removeNode])
                            writeNode['channels'].setValue( 'all' )
                            writeNode['file_type'].setValue('exr')
                            writeNode['datatype'].setValue('32 bit float')
                            writeNode['metadata'].setValue('all metadata')
                            writeNode['noprefix'].setValue(True)
                            print (layer + " Renamed to Cryptomatte")
                            layer = "Cryptomatte" 


                        else:
                            # Create Shuffle node
                            shuffleNode = nuke.nodes.Shuffle(label=layer,inputs=[node])
                            shuffleNode['in'].setValue( layer )

                            # Create Write node
                            writeNode = nuke.nodes.Write(label=layer,inputs=[shuffleNode])
                            writeNode['channels'].setValue( 'rgba' )                    
                            
                            
                        # set renders to layer subfolders
                        writeNode['file'].setValue( get_Dir + "/" + layer + "/"+ get_Filename + "_"+ layer + "." + get_file_type )                           
                        writeNodeFile = writeNode['file'].value()                
                        first = int(writeNode['first'].value())
                        last = int(writeNode['last'].value())
                        
                        # Render 
                        nuke.execute(writeNode, first, last, 1)                
                        print ("AutoExtractEXR : " + writeNodeFile)
                        

                        # Remove nodes
                        try: 
                            nuke.delete(removeNode)
                        except:
                           pass     
                        try:
                            nuke.delete(shuffleNode)
                        except:
                           pass                    
                        try:
                            nuke.delete(writeNode)
                        except:
                           pass
                        
                        readNode = nuke.nodes.Read(label=layer)
                        readNode['file'].setValue( writeNodeFile )
                        
                else:
                    pass
        
        nuke.message('AutoExtract Done\n'+get_Filename)
    except:
        nuke.message('ERROR: Please select a EXR file')
        return            

# Auto extracts EXR file to single EXRs
def manualExtractEXR():
    try: 
        if not nuke.selectedNode().Class() == 'Read' :
            nuke.message('Please select Read node\nthat has EXR information')
            return
        
        nodes = nuke.selectedNodes()
        
        for node in nodes:
            get_Path = nuke.filename( node )
            get_Dir = os.path.dirname ( get_Path )
            get_Filename = get_Path.split('/')[-1].split('.')[0]    

            get_colorspace = node['colorspace'].value()
            get_file_type = node['file_type'].value()  
                
            if node.Class() == 'Read':
                channels = node.channels()
                layers = list( set([channel.split('.')[0] for channel in channels]) )
                layers.sort()
                for layer in layers:
                    # Create Shuffle node
                    shuffleNode = nuke.nodes.Shuffle(label=layer,inputs=[node])
                    shuffleNode['in'].setValue( layer )

                    # Create Write node
                    writeNode = nuke.nodes.Write(name="Write_"+layer,label=layer,inputs=[shuffleNode])
                    writeNode['channels'].setValue( 'rgba' )
                            
                    # set renders to layer subfolders
                    writeNode['file'].setValue( get_Dir + "/" + layer + "/"+ get_Filename + "_"+ layer + ".####." + get_file_type )                           
                    writeNodeFile = writeNode['file'].value()
                    writeNode['name'].value()
                    first = int(writeNode['first'].value())
                    last = int(writeNode['last'].value())                                               
                        
                else:
                    pass
        
        print ("ManualExtractEXR Ended")
        nuke.message('ManualExtract Done\n'+get_Filename)
    except:
        nuke.message('ERROR: Please select a EXR file')
        return 

#need to update this to combind all and selected
def PostageStamps_On():
    for node in nuke.allNodes():
        try:
            node['postage_stamp'].setValue(1)
        except:
            pass
 
def PostageStamps_Off():
    for node in nuke.allNodes():
        try:
            node['postage_stamp'].setValue(0)
        except:
            pass
            
def PostageStamps_Selected_On():
    for node in nuke.selectedNodes():
        try:
            node['postage_stamp'].setValue(1)
        except:
            pass
 
def PostageStamps_Selected_Off():
    for node in nuke.selectedNodes():
        try:
            node['postage_stamp'].setValue(0)
        except:
            pass   
 

## this script was assembled by j.hezer for studiorakete 2012 all input comes from frank rueter, ivan busquet and Michael Garrett 
## still wip with worldToNDC and worldToCamera only
def getMetadataMatrix(meta_list):
    m = nuke.math.Matrix4()
    try:
        for i in range (0,16) :
            m[i] = meta_list[i]   
    except:
        m.makeIdentity()
    return m  

def createCam_Cam_MayatoNuke():
    try:
        selectedNode = nuke.selectedNode()
        nodeName = selectedNode.name()
        node = nuke.toNode(nodeName)
        if nuke.getNodeClassName(node) != 'Read':
            nuke.message('Please select a read Node')
            print ('Please select a read Node')
            return
        metaData = node.metadata()
        reqFields = ['exr/%s' % i for i in ('worldToCamera', 'worldToNDC')]
        if not set( reqFields ).issubset( metaData ):
            nuke.message('no basic matrices for camera found')
            return
        else:
            print ('found needed data')
        imageWidth = metaData['input/width']
        imageHeight = metaData['input/height']
        aspectRatio = float(imageWidth)/float(imageHeight)
        hAperture = 36.0
        vAperture = hAperture/aspectRatio
        
        # get additional stuff
        first = node.firstFrame()
        last = node.lastFrame()
        ret = nuke.getFramesAndViews( 'Create Camera from Metadata', '%s-%s' %( first, last )  )
        frameRange = nuke.FrameRange( ret[0] )
        camViews = (ret[1])
        
        
        for act in camViews:
            cam = nuke.nodes.Camera (name="Camera %s" % act)
            #enable animated parameters
            cam['useMatrix'].setValue( True )
            cam['haperture'].setValue ( hAperture )
            cam['vaperture'].setValue ( vAperture )
        
            for k in ( 'focal', 'matrix', 'win_translate'):
                cam[k].setAnimated()
            
            task = nuke.ProgressTask( 'Baking camera from meta data in %s' % node.name() )
    
            for curTask, frame in enumerate( frameRange ):
                if task.isCancelled():
                    break
                task.setMessage( 'processing frame %s' % frame )
            #get the data out of the exr header
                wTC = node.metadata('exr/worldToCamera',frame, act)
                wTN = node.metadata('exr/worldToNDC',frame, act)
                
            #set the lenshiift if additional metadata is available or manage to calculate it from the toNDC matrix    
                #cam['win_translate'].setValue( lensShift, 0 , frame )
                
            # get the focal length out of the worldToNDC Matrix
            # thats the wip part any ideas ??
                
                worldNDC = wTN
                
                lx =  (-1 - worldNDC[12] - worldNDC[8]) / worldNDC[0]
                rx =  (1 - worldNDC[12] - worldNDC[8]) / worldNDC[0]
                by = (-1 - worldNDC[13] - worldNDC[9]) / worldNDC[5]
                ty = (1 - worldNDC[13] - worldNDC[9]) / worldNDC[5]
                swW = max( lx , rx ) - min( lx , rx )  # Screen Window Width
                swH = max( by , ty ) - min( by , ty )  # Screen Window Height
                focal = hAperture / swW
                cam['focal'].setValueAt(  float( focal ), frame )
            
            # do the matrix math for rotation and translation
        
                matrixList = wTC
                camMatrix = getMetadataMatrix(wTC)
                
                flipZ=nuke.math.Matrix4()
                flipZ.makeIdentity()
                flipZ.scale(1,1,-1)
             
                transposedMatrix = nuke.math.Matrix4(camMatrix)
                transposedMatrix.transpose()
                transposedMatrix=transposedMatrix*flipZ
                invMatrix=transposedMatrix.inverse()
                
                for i in range(0,16):
                    matrixList[i]=invMatrix[i]
                
                for i, v in enumerate( matrixList ):
                    cam[ 'matrix' ].setValueAt( v, frame, i)
            # UPDATE PROGRESS BAR
                task.setProgress( int( float(curTask) / frameRange.frames() *100) )
    except:
        nuke.message('ERROR: Select a EXR from Maya')



# code copied and adapted from https://pastebin.com/4vmAmARU
# Big thanks to Ivan Busquets who helped me put this together!
# (ok, ok, he really helped me a lot)
# Also thanks to Nathan Dunsworth for giving me solid ideas and some code to get me started.
def createCam_Cam_VraytoNuke( node ):
    try:
        mDat = node.metadata()
        reqFields = ['exr/camera%s' % i for i in ('FocalLength', 'Aperture', 'Transform')]
        if not set( reqFields ).issubset( mDat ):
            nuke.critical( 'No metadata for camera found! Please select a read node with EXR metadata from VRay!' )
            return

        nuke.message( "Creating a camera node based on VRay metadata. This works specifically on VRay data coming from Maya!\n\nIf you get both focal and aperture as they are in the metadata, there's no guarantee your Nuke camera will have the same FOV as the one that rendered the scene (because the render could have been fit to horizontal, to vertical, etc). Nuke always fits to the horizontal aperture. If you set the horizontal aperture as it is in the metadata, then you should use the FOV in the metadata to figure out the correct focal length for Nuke's camera. Or, you could keep the focal as is in the metadata, and change the horizontal_aperture instead. I'll go with the former here. Set the haperture knob as per the metadata, and derive the focal length from the FOV." )

        first = node.firstFrame()
        last = node.lastFrame()
        ret = nuke.getFramesAndViews( 'Create Camera from Metadata', '%s-%s' %( first, last ) )
        if ret is None:
            return
        fRange = nuke.FrameRange( ret[0] )
        
        cam = nuke.createNode( 'Camera2' )
        cam['useMatrix'].setValue( False )
        
        for k in ( 'focal', 'haperture', 'vaperture', 'translate', 'rotate'):
            cam[k].setAnimated()
        
        task = nuke.ProgressTask( 'Baking camera from meta data in %s' % node.name() )
        
        for curTask, frame in enumerate( fRange ):
            if task.isCancelled():
                break
            task.setMessage( 'processing frame %s' % frame )
            
            hap = node.metadata( 'exr/cameraAperture', frame ) # get horizontal aperture
            fov = node.metadata( 'exr/cameraFov', frame ) # get camera FOV
            
            focal = float(hap) / ( 2.0 * math.tan( math.radians(fov) * 0.5 ) ) # convert the fov and aperture into focal length

            width = node.metadata( 'input/width', frame )
            height = node.metadata( 'input/height', frame )
            aspect = float(width) / float(height) # calulate aspect ratio from width and height
            vap = float(hap) / aspect # calculate vertical aperture from aspect ratio
            
            cam['focal'].setValueAt( float(focal), frame )
            cam['haperture'].setValueAt( float(hap), frame )
            cam['vaperture'].setValueAt( float(vap), frame )
            
            matrixCamera = node.metadata( 'exr/cameraTransform', frame ) # get camera transform data
            
            # create a matrix to shove the original data into 
            matrixCreated = nuke.math.Matrix4()
            
            for k,v in enumerate( matrixCamera ):
                matrixCreated[k] = v
            
            matrixCreated.rotateX( math.radians(-90) ) # this is needed for VRay, it's a counter clockwise rotation
            translate = matrixCreated.transform( nuke.math.Vector3(0,0,0) )  # get a vector that represents the camera translation   
            rotate = matrixCreated.rotationsZXY() # give us xyz rotations from cam matrix (must be converted to degrees)
        
            cam['translate'].setValueAt( float(translate.x), frame, 0 )
            cam['translate'].setValueAt( float(translate.y), frame, 1 )
            cam['translate'].setValueAt( float(translate.z), frame, 2 )
            cam['rotate'].setValueAt( float( math.degrees( rotate[0] ) ), frame, 0 )
            cam['rotate'].setValueAt( float( math.degrees( rotate[1] ) ), frame, 1 ) 
            cam['rotate'].setValueAt( float( math.degrees( rotate[2] ) ), frame, 2 ) 
        
            task.setProgress( int( float(curTask) / fRange.frames() * 100 ) )
    except:
       nuke.message('ERROR: Select a EXR from Max / VRay')


# sets toBBOx
def Auto_Settobbox():
    try:
        Override_Crop = nuke.selectedNode()
        Override_Crop['box'].setExpression('bbox.x',0)
        Override_Crop['box'].setExpression('bbox.y',1)
        Override_Crop['box'].setExpression('bbox.r',2)
        Override_Crop['box'].setExpression('bbox.t',3)
        Override_Crop['reformat'].setValue(True)
        return
    except:
        nuke.message('ERROR: Select a node that has Bbox')
        return

def Auto_CroptoResolution():
    try:
        Override_Crop = nuke.selectedNode()
        Override_Crop['box'].setExpression('0',0)
        Override_Crop['box'].setExpression('0',1)
        Override_Crop['box'].setExpression('bbox.w',2)
        Override_Crop['box'].setExpression('bbox.h',3)
        Override_Crop['reformat'].setValue(True)
        return
    except:
        nuke.message('ERROR: Select a Crop node')
        return
 
def Auto_ContactSheet():
    try:
        Auto_ContactSheet = nuke.selectedNode()
        Auto_ContactSheet['width'].setExpression('width*columns')
        Auto_ContactSheet['height'].setExpression('height*rows')
        return
    except:
        nuke.message("ERROR: Select a ContactSheet Node")
        return




# Prints out the code version and python version
print ("LOADED : "+ infoScript + " | " + __version__ + " | Python : " + PythonVersion )

#END