class PanDisplay
	constructor: (@parentSelector, displayRect) ->
		# Add to DOM
		$(@parentSelector).append """
			<svg id="PanDisplay" style="position:absolute">
			  <circle cx="50" cy="50" r="40" stroke="white" stroke-width="8" fill="black" />
			</svg>
			"""
		@setLocation(displayRect)
		return

	setLocation: (@displayRect) ->
		panBorder = 10
		height = @displayRect.height
		width = @displayRect.width
		radius = (Math.min(height, width) - panBorder * 2) / 2
		$("#PanDisplay").css("left", @displayRect.x + "px") 
		$("#PanDisplay").css("top", @displayRect.y + "px")
		$("#PanDisplay").height(height)
		$("#PanDisplay").width(width)
		$("#PanDisplay circle").attr("cx", width/2)
		$("#PanDisplay circle").attr("cy", height/2)
		$("#PanDisplay circle").attr("r", radius)
		return
