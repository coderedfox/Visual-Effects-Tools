import nuke, os, sys, inspect, socket, platform, psutil

if str(nuke.NUKE_VERSION_STRING)!='12.1v1':
    print "----- WARNING: Your version : ",  nuke.NUKE_VERSION_STRING

print '------------------------------------------------------------'
print ( "\tUSER: " + os.getenv('username') )
print ( "\tOS: " + os.getenv('os') )
print ( "\tPROCs: " + os.getenv('NUMBER_OF_PROCESSORS') )
print ( "\tVERSION: " + nuke.NUKE_VERSION_STRING )
print '\t------------------------------------------------------------'

# Gets drive info
HDList = [ chr(x) + ":" for x in range(65,91) if os.path.exists(chr(x) + ":") ]
for HD in HDList:
    try:
        FreeHD = (psutil.disk_usage(HD)[2]) / (2**30)
        SizeHD = (psutil.disk_usage(HD)[0]) / (2**30)

        if ( FreeHD > 100 ):
            print ("\tDRIVE: " + HD + " " + str(FreeHD) + " GB free out of " + str(SizeHD) + " GB")
        else:
            print ("\tWARNING DRIVE SPACE LOW: " + HD + " : " + str(FreeHD) + " GB free out of " + str(SizeHD) + " GB")
    except OSError: 
            print ("\tDRIVE: " + HD + " Does not exist")
        
print '\t------------------------------------------------------------'
print ( "\tNUKE_PATH: " + os.getenv('NUKE_PATH') )
print ( "\tNUKE_TEMP_DIR: " + os.getenv('NUKE_TEMP_DIR') )

# Server Test
print '\t------------------------------------------------------------'
serverList = ['']
for servers in serverList :
    try:
        print "\tSERVER: " + servers +" at " + (socket.gethostbyname(servers)) + " is Connected"
    except:
        print "\tSERVER: " + servers +" NOT CONNECTED"
        pass
        
print '------------------------------------------------------------'

#debug status
global Nuke_Debug
Nuke_Debug = False
    
if Nuke_Debug : 
    print "*** NUKE is in TGD DEBUG MODE for a while to catch any issues. ***"
    print "*** This will not effect any work or rendering ***"    

# Custom folders
# nuke.addFavoriteDir('Custom1', '//192.168.1.1/')

# Custom formats, cannot start with a number
# nuke.addFormat( '8000 8000 1.0 High Renders' )

# Set plugin/gizmo sub-folders
nuke.pluginAddPath( './gizmos' )
nuke.pluginAddPath( './python' )
nuke.pluginAddPath( './plugins' )

# Add Extra plugins
#nuke.pluginAddPath('./plugins/Deadline') # Adding Deadline Plugin
#nuke.pluginAddPath('./plugins/Cryptomatte') # Cryptomatte
#nuke.pluginAddPath('./plugins/MOTools') # MOTools
#nuke.pluginAddPath('./plugins/collectFiles')
#nuke.pluginAddPath('./plugins/vray_nuke_denoiser') #Vray Denoiser
#nuke.pluginAddPath('./plugins/denoice') #Arnold Denoiser

# If Write dir does not exist, create it.
def createWriteDir(): 
    file = nuke.filename(nuke.thisNode()) 
    dir = os.path.dirname( file ) 
    osdir = nuke.callbacks.filenameFilter( dir )
    try: 
        os.makedirs( osdir ) 
        return 
    except: 
        return

nuke.addBeforeRender( createWriteDir )

# Adding a rewrite for WFH conditions this will take servernames and change them to ip addresses. Might not show in the GUI
def servernameFix(filename):
    if nuke.env['WIN32']:
        filename = filename.replace( '', '' )
    
    return filename

nuke.addFilenameFilter(servernameFix)