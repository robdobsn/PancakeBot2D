class PanDisplay
	constructor: (@parentSelector, @imgPath, backdropRect, panBitmapRect, pancakeSketchRect, buttonsRect) ->
		# Add to DOM
		$(@parentSelector).append """
			<div id="backdrop" style="position:absolute;z-index:-20">
				<img src="img/backdrop.png" style="">
				</img>
			</div>
	        <div id="buttonbox" style="position:absolute;cursor:pointer">
	        	<img id="printbtn" src="img/print.png"></img>
	        </div>
			<div id="PanDisplay" style="position:absolute;z-index:-10">
				<img src="img/panLandscape.png">
				</img>
			</div>
			<div id="pancakePath" style="position:absolute;"></div>
			"""
			# <svg id="PanDisplay" style="position:absolute">
			#   <circle cx="50" cy="50" r="40" stroke="white" stroke-width="8" fill="black" />
			# </svg>
		# Create the path editor
		@sketchpad = Raphael.sketchpad("pancakePath", { width: 100, height: 100, editing: true })
		@sketchpad.pen().color("#ecebd3")
		@sketchpad.change(@sketchChanged)
		# Reposition display eleemnts
		@reposition(backdropRect, panBitmapRect, pancakeSketchRect, buttonsRect)
		return

	getStrokes: ->
		strokeJson = @sketchpad.json()
		strokes = JSON.parse(strokeJson)
		pathsOnly = (stroke.path for stroke in strokes)
		return pathsOnly

	getPanBoundary: ->
		panBounds =
			x: @panCentreX
			y: @panCentreY
			radius: @panBoundaryRadius
		return panBounds

	reposition: (@backdropRect, @panBitmapRect, @pancakeSketchRect, @buttonsRect) ->

		# Backdrop
		$("#backdrop").css("left", @backdropRect.x + "px") 
		$("#backdrop").css("top", @backdropRect.y + "px")
		$("#backdrop img").height(@backdropRect.height)
		$("#backdrop img").width(@backdropRect.width)		

		# Pan image
		panBorder = @panBitmapRect.height/70
		height = @panBitmapRect.height
		width = @panBitmapRect.width
		$("#PanDisplay").css("left", @panBitmapRect.x + "px") 
		$("#PanDisplay").css("top", @panBitmapRect.y + "px")
		$("#PanDisplay img").height(height)
		$("#PanDisplay img").width(width)
		if @panBitmapRect.portrait
			$("#PanDisplay img").attr("src","img/panPortrait.png")
		else
			$("#PanDisplay img").attr("src","img/panLandscape.png")

		# Reposition sketchpad
		$("#pancakePath").css("left", @pancakeSketchRect.x + "px") 
		$("#pancakePath").css("top", @pancakeSketchRect.y + "px")
		@sketchpad.paper().setSize(@pancakeSketchRect.width, @pancakeSketchRect.height)

		# Set a circular boundary for the pan
		pancakeBorder = @pancakeSketchRect.height / 12
		@panBoundaryRadius = @pancakeSketchRect.height / 2 - pancakeBorder
		@panCentreX = @pancakeSketchRect.width/2
		@panCentreY = @pancakeSketchRect.height/2
		@sketchpad.setCircularBounds(@panCentreX, @panCentreY, @panBoundaryRadius)

		# $(".app h1").text("boundsCentre x,y " + @panCentreY + "," + @panCentreY + " radius " + @panBoundaryRadius)

		# Reposition buttons
		$("#buttonbox").css("left", @buttonsRect.x)
		$("#buttonbox").css("top", @buttonsRect.y)
		return

	sketchChanged: () =>
		# sss3 = ""
		# for stroke in @sketchpad.strokes()
		# 	sss = JSON.stringify(stroke)
		# 	path = stroke.path[0]
		# 	sss1 = JSON.stringify(path)
		# 	testpath = "M10 10L900 900"
		# 	res = Raphael.pathIntersection(stroke.path, testpath)
		# 	sss2 = JSON.stringify(res)
		# 	sss3 += sss2 + "\n"

		# $("#debug1").html("Len=" + @getStrokes().length + " " + JSON.stringify(@getStrokes()))
		return
