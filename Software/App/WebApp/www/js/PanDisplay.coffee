class PanDisplay
	constructor: (@parentSelector, panBitmapRect, pancakeSketchRect, buttonsRect, logoRect) ->
		# Add to DOM
		$(@parentSelector).append """
			<div id="logobox" style="position:absolute;">
				<img src="http://robdobson.com/pancakebot/img/panlogo.png" style="width:100%;height:auto">
				</img>
			</div>
			<div id="PanDisplay" style="position:absolute;z-index:-10">
				<img src="http://robdobson.com/pancakebot/img/pan.png">
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
		@reposition(panBitmapRect, pancakeSketchRect, buttonsRect, logoRect)
		return

	getPath: ->
		if @sketchpad.strokes().length > 0
			return @sketchpad.strokes()[0].path
		return null

	setupPathEditor: ->

	reposition: (@panBitmapRect, @pancakeSketchRect, @buttonsRect, @logoRect) ->
		# Pan image
		panBorder = @panBitmapRect.height/70
		height = @panBitmapRect.height
		width = @panBitmapRect.width
		$("#PanDisplay").css("left", @panBitmapRect.x + "px") 
		$("#PanDisplay").css("top", @panBitmapRect.y + "px")
		$("#PanDisplay img").height(height)
		$("#PanDisplay img").width(width)

		# Reposition sketchpad
		$("#pancakePath").css("left", @pancakeSketchRect.x + "px") 
		$("#pancakePath").css("top", @pancakeSketchRect.y + "px")
		@sketchpad.paper().setSize(@pancakeSketchRect.width, @pancakeSketchRect.height)
		pancakeBorder = @pancakeSketchRect.height / 12
		circleRadius = @pancakeSketchRect.height / 2 - pancakeBorder
		@sketchpad.setCircularBounds(@pancakeSketchRect.width/2, @pancakeSketchRect.height/2, circleRadius)
		# $(".app h1").text("displayRect " + JSON.stringify(@displayRect))

		# Reposition logo
		$("#logobox").css("left", @logoRect.x)
		$("#logobox").css("top", @logoRect.y)
		$("#logobox").css("width", @logoRect.width)
		$("#logobox").css("height", @logoRect.height)

		# Reposition buttons
		$("#buttonbox").css("left", @buttonsRect.x)
		$("#buttonbox").css("top", @buttonsRect.y)
		return

	sketchChanged: () =>
		sss3 = ""
		for stroke in @sketchpad.strokes()
			sss = JSON.stringify(stroke)
			path = stroke.path[0]
			sss1 = JSON.stringify(path)
			testpath = "M10 10L900 900"
			res = Raphael.pathIntersection(stroke.path, testpath)
			sss2 = JSON.stringify(res)
			sss3 += sss2 + "\n"
		$("#debug1").html(sss3)
		return
