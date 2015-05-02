class PanDisplay
	constructor: (@parentSelector, displayRect) ->
		# Add to DOM
		$(@parentSelector).append """
			<div id="PanDisplay" style="position:absolute;"><img src="img/pan.png"></img></div>
			<div id="pancakePath" style="position:absolute;"></div>
			"""
			# <svg id="PanDisplay" style="position:absolute">
			#   <circle cx="50" cy="50" r="40" stroke="white" stroke-width="8" fill="black" />
			# </svg>
		# Create the path editor
		@sketchpad = Raphael.sketchpad("pancakePath", { width: 400, height: 400, editing: true })
		@sketchpad.setCircularBounds(200, 200, 170)
		@sketchpad.pen().color("#d0d0d0")
		@reposition(displayRect)

		return

	reposition: (@displayRect) ->
		panBorder = 10
		height = @displayRect.height
		width = @displayRect.width
		radius = (Math.min(height, width) - panBorder * 2) / 2
		$("#PanDisplay").css("left", @displayRect.x + "px") 
		$("#PanDisplay").css("top", @displayRect.y + "px")
		$("#PanDisplay img").height(height)
		# $("#PanDisplay img").width(width)
		# $("#PanDisplay circle").attr("cx", width/2)
		# $("#PanDisplay circle").attr("cy", height/2)
		# $("#PanDisplay circle").attr("r", radius)
		$("#pancakePath").css("left", @displayRect.x + "px") 
		$("#pancakePath").css("top", @displayRect.y + "px")
		return
