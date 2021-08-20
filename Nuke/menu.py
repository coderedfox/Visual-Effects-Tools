import nuke, subprocess, inspect

# -------- Toolbar --------
# Initialize the toolbar menu
toolbar = nuke.toolbar('Nodes')
menubar = nuke.menu("Nuke");

# -------- Adding most used Folders --------
# nuke.addFavoriteDir('', '')

# Custom Defaults
# nuke.knobDefault("Merge.label","A : [value Achannels]\nB : [value Bchannels]\nOut : [value Bchannels]") 
# nuke.knobDefault("Shuffle.label","B : [value in1] to [value out1]\nA : [value in2] to [value out2]")
# nuke.knobDefault("Remove.label","Channels : [value channels]\nand : [value channels2]\nand : [value channels3]\nand : [value channels4]")

# Custom reolutions
nuke.knobDefault('Root.format','1920 1080 HD')
nuke.knobDefault('Roto.output','alpha')

# Deadline Client
import DeadlineNukeClient
menubar = nuke.menu("Nuke")
tbmenu = menubar.addMenu("&Thinkbox")
tbmenu.addCommand("Submit Nuke To Deadline", DeadlineNukeClient.main, "")

#debug Check
if Nuke_Debug : print "DEBUG " + inspect.getfile(inspect.currentframe())
