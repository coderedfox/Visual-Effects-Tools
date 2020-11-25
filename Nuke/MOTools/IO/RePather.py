print "STARTED"

def getwritenodepaths():
    writeNodes =[]
    writeNodePath = []
    for node in nuke.allNodes('Read'):        
       writeNodes.append( node["name"].value() )
       writeNodePath.append( node["file"].value() )        
    return (writeNodes,writeNodePath )

def setwritenodepaths():
    for node in nuke.allNodes('Read'):        
       writeNodes.append( node["name"].value() )
       writeNodePath.append( node["file"].value() )        
    return (writeNodes,writeNodePath )


def create_window():

    getWriteInfo = getwritenodepaths()

    #print getWriteInfo


    p = nuke.Panel('RePather') 

    for nodes in getWriteInfo:
        #print ( "Read : " + writeNodes[getWriteInfo.index( nodes )]+ " |  Path : " + writeNodePath[getWriteInfo.index( nodes )] )

        p.addFilenameSearch(writeNodes[getWriteInfo.index( nodes )] + " | " + writeNodePath[getWriteInfo.index( nodes )], writeNodePath[getWriteInfo.index( nodes )])

        
    p.addButton('Repath All')    
    p.addButton('Rescan')    

    ret = p.show()

create_window()


def addPanel():
    return 


menu = nuke.menu('Pane')
menu.addCommend('Repather',addPanel)