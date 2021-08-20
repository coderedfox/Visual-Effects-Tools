group "Correct Names"
		(
			button CorrectNames_button "Correct Selected Names"
			on CorrectNames_button pressed do
				(
					if $ != undefined do
					(
						for i in 1 to selection.count do
						(	
							if (superclassof selection[i]==GeometryClass and matchPattern selection[i].name pattern:"geo_*" !=true) do (selection[i].name = "geo_" + selection[i].name)
							if superclassof selection[i]==camera and matchPattern selection[i].name pattern:"cam_*" !=true do (selection[i].name = "cam_" + selection[i].name)
							if superclassof selection[i]==helper and matchPattern selection[i].name pattern:"con_*" !=true do (selection[i].name = "con_" + selection[i].name)
							if superclassof selection[i]==shape and matchPattern selection[i].name pattern:"con_*" !=true do (selection[i].name = "con_" + selection[i].name)
							if superclassof selection[i]==light and matchPattern selection[i].name pattern:"lgt_*" !=true do (selection[i].name = "lgt_" + selection[i].name)
							if superclassof selection[i]==SpacewarpObject and matchPattern selection[i].name pattern:"fx_*" !=true do (selection[i].name = "fx_" + selection[i].name)
							
						)
						messagebox "All selected items have tried to be renamed" title:"Correct Selected Names" beep:true			
					)					
				)
		)