def getMinMax( srcNode ):
    MinColor = nuke.nodes.MinColor( target=0, inputs=[srcNode] )
    Inv = nuke.nodes.Invert( inputs=[srcNode])
    MaxColor = nuke.nodes.MinColor( target=0, inputs=[Inv] )
    
    curFrame = nuke.frame()
    nuke.execute( MinColor, curFrame, curFrame )
    min = -MinColor['pixeldelta'].value()
    
    nuke.execute( MaxColor, curFrame, curFrame )
    max = MaxColor['pixeldelta'].value() + 1
    
    for n in ( MinColor, MaxColor, Inv ):
        nuke.delete( n )
    return min, max

minmax = getMinMax( nuke.selectedNode() )
nuke.createNode( 'Grade', 'blackpoint %s whitepoint %s' % minmax )