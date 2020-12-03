
# import Read_SanityChecker
# nuke.menu( 'Nuke' ).addCommand( 'TGD/DEV/Add Read Info', 'write_sanitychecker.dataview_Update()' )
# nuke.menu( 'Nuke' ).addCommand( 'TGD/DEV/Remove Read Info', 'write_sanitychecker.dataview_Remove()' )

import nuke

__version__ = "1.8"

set_Tab = 'Sanity Check'

set_Knobs = [
    ['SC_Location',        'File : '               , ''],
    ['SC_BitDepth',        'Bit Depth : '          , ''],
    ['SC_FileSize',        'File Size (kb) : '     , ''],
    ['SC_EXR',             'EXR'                   , ' '],
    ['SC_Type',            'Type : '               , ''],
    ['SC_CompressionName', 'Compression : '        , ''],
    ['SC_ARNOLD',          'Arnold'                , ''],
    ['SC_Info',            ''                      , ''],
    ['SC_Version',         ''                      , 'ver: '+__version__]

]

set_values = [
    ['SC_BitDepth',        'input/bitsperchannel',     'Beauty images should 16 bit half float \nAOVs images should 32 bit full float'],
    ['SC_Type',            'exr/type',                 'Scanline image processes and reads images one line of pixels at a time, until it hits the end of the image'],
    ['SC_CompressionName', 'exr/compressionName',      'RLE compression, run length encoding\n\nZip (1 scanline) one scan line at a time \n\nZip (16 scanline) in blocks of 16 scan lines\n\nPIZ-based wavelet compression, in blocks of 32 scan lines'],
    ['SC_FileSize',        'input/filesize',           'This is in kb']
]

def SC_Create(CreateNode):
    try:
        print "Creating Sanity Checker"
        CreateNode_tab = nuke.Tab_Knob(set_Tab)
        CreateNode.addKnob(CreateNode_tab)    
        for create_Knob in set_Knobs:
            CreateNode.addKnob(nuke.Text_Knob(create_Knob[0], create_Knob[1], create_Knob[2]))
        nuke.addUpdateUI(write_sanitychecker.SC_Update)    
    except:
        pass

def SC_Remove(RemoveNode):
    print "SC_Remove"

def SC_Update(UpdateNodes):
    for UpdateNode in UpdateNodes:
        try:
            UpdateNode['SC_Location'].value
        except NameError:
            SC_Create(UpdateNode)

        if ( "//" in UpdateNode['file'].value() ):
            UpdateNode['SC_Location'].setValue("Server")
        else:
            UpdateNode['SC_Location'].setValue("Local")

        for set_value in set_values:
            try:
                UpdateNode[str(set_value[0])].setValue( getUpdate.metadata(set_value[1]) )
                UpdateNode[str(set_value[0])].setTooltip( set_value[2] )
            except TypeError:
                UpdateNode[str(set_value[0])].setValue( str( getUpdate.metadata(set_value[1] ) ) )
                UpdateNode[str(set_value[0])].setTooltip( set_value[2] )
            except NameError:
                UpdateNode[str(set_value[0])].setValue( "N/A" )
                UpdateNode[str(set_value[0])].setTooltip( "" )


#SC_Update(nuke.selectedNodes())