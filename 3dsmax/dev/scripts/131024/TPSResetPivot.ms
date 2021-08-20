	rollout motools "Testing"
	(	
		group "Instance Modifiers"
		(
			button Initilize_button "RE_Center" pos:[10,30]

			on Initilize_button pressed do
				(
					WorldAlignPivot $
					$.pivot = [0,0,0]
				)
			
		)
	)
	
	try (closeRolloutFloater theNewFloater) catch()	
	
	theNewFloater = newRolloutFloater "Mike's Everyday Tools" 300 600
	addRollout motools theNewFloater