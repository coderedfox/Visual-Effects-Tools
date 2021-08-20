group "Create Master Node"
		(
			button CreateMasterNode_button "Create Scene Master Node"
			on CreateMasterNode_button pressed do
				(
					FFXlayer = LayerManager.newLayerFromName "MasterNode"
					FFXlayer.current = true --odd issues when re doing the script					
					
					MOMaster_Node = Point ()
					MOMaster_Node.name = "MasterNode"
					MOMaster_Node.pos = [0,0,0] 
					MOMaster_Node.size = 50
					MOMaster_Node.box = true
					MOMaster_Node.constantscreensize = true
					MOMaster_Node.wirecolor = red
					
					fn theRootNode node = if isvalidnode node do (while node.parent != undefined do node = node.parent; node)					
					for i=1 to objects.count do
					(	
						TopNodeToLink = theRootNode objects[i]
						try(TopNodeToLink.parent = MOMaster_Node) catch ()
					)
				)
		)