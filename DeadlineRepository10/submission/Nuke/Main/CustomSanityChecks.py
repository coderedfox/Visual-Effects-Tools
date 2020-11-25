import nuke
import DeadlineGlobals

# TGD Customs
def RunSanityCheck():
    # Sets the Nuke group name
    DeadlineGlobals.initGroup = "nuke"
    # Adds a discription
    DeadlineGlobals.initDepartment = "Compositings"
    # Sets the limit to out rendering limit
    #DeadlineGlobals.initMachineLimit = 1
    # Sets a 50 percent priority
    DeadlineGlobals.initPriority = 50
    # One machine one job
    #DeadlineGlobals.initConcurrentTasks = 1
    # Sets the machine up to render 25 frame blocks this will cut load time
    DeadlineGlobals.initChunkSize = 25
    # Seperates write nodes into diffrent jobs
    DeadlineGlobals.initSeparateJobs = True
    # submits the script incase overwrite
    DeadlineGlobals.initSubmitScene = True
        
    #nuke.message( "This is a custom sanity check!" )    
    
    
    checkforlocal() # Checks for local files, do not turn on yet

    return True

#checks for local files
def checkforlocal():
    ServerMatch = ["//gun3","//gun1",]
    
    for node in nuke.allNodes('Read'):
        testfile = node["file"].value()
        if ( any(ServerMatch in testfile for ServerMatch in ServerMatch) != True ):
            print("FAILED: INCORRECT PATHING\nNODE: " + node["name"].value() + "\nPATH: "+ node["file"].value() +"\n" )

    for node in nuke.allNodes('Write'):
        testfile = node["file"].value()
        if ( any(ServerMatch in testfile for ServerMatch in ServerMatch) != True ):
            print("FAILED: INCORRECT PATHING\nNODE: " + node["name"].value() + "\nPATH: "+ node["file"].value() +"\n" )

checkforlocal()