Group "Transform Locks"
		(
			button Geo_Lock "Lock" pos:[15,22]
			button Geo_UnLock "Unlock" pos:[60,22]
			checkbox Geo_Locks_pos "Move" checked:true pos:[115,27]
			checkbox Geo_Locks_rot "Rotate" checked:true pos:[165,27]
			checkbox Geo_Locks_scale "Scale" checked:true pos:[225,27]
		
			on Geo_Lock pressed do
			(
				if selection !=undefined do
				(
					local GeoTransLockArray = #{1,2,3,4,5,6,7,8,9}				
					if Geo_Locks_pos.checked==true do (append GeoTransLockArray 1;append GeoTransLockArray 2;append GeoTransLockArray 3)
					if Geo_Locks_rot.checked==true do (append GeoTransLockArray 4;append GeoTransLockArray 5;append GeoTransLockArray 6)
					if Geo_Locks_scale.checked==true do (append GeoTransLockArray 7;append GeoTransLockArray 8;append GeoTransLockArray 9)					
					setTransformLockFlags selection GeoTransLockArray
				)
			)
			
			on Geo_UnLock pressed do
			(
				if selection !=undefined do
				(
					local GeoTransLockArray = #{1,2,3,4,5,6,7,8,9}				
					if Geo_Locks_pos.checked==true do (deleteItem GeoTransLockArray 1;deleteItem GeoTransLockArray 2;deleteItem GeoTransLockArray 3)
					if Geo_Locks_rot.checked==true do (deleteItem GeoTransLockArray 4;deleteItem GeoTransLockArray 5;deleteItem GeoTransLockArray 6)
					if Geo_Locks_scale.checked==true do (deleteItem GeoTransLockArray 7;deleteItem GeoTransLockArray 8;deleteItem GeoTransLockArray 9)
					setTransformLockFlags selection GeoTransLockArray
				)
			)			
		)