


carline = SplineShape pos:[0,0,0]
carline.name= "TPSCar"
carline.color= red

addNewSpline carline
addKnot carline 1 #corner #line [-100,0,0]
addKnot carline 1 #corner #line [-10,0,0]
addKnot carline 1 #corner #line [-10,-20,0]
addKnot carline 1 #corner #line [-10,50,0]
addKnot carline 1 #corner #line [5,10,0]
addKnot carline 1 #corner #line [-100,-100,0]
addKnot carline 1 #corner #line [-100,0,0]

updateShape carline