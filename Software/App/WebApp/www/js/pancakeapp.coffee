
$(document).ready ->
	pancakeApp = new PancakeApp()
	$(document).on "touchmove", (evt) ->
		evt.preventDefault()
	$(document).on "touchmove", ".scrollable", (evt) ->
		evt.stopPropagation()
	# Go
	pancakeApp.go()

class PancakeApp
	constructor: ->
		# Size of pan bitmap
		@panSize = 
			width: 400
			height: 319
		# Basic body for DOM
		$("body").prepend """
			<div id="sqWrapper">
				<div class="app">
					<h1 style="color:blue">Pancake Bot 2D</h1>
				</div>
			</div>
			<div id="debug1"></div>
			"""
		# Handler for orientation change
		$(window).on 'orientationchange', =>
		  @redisplay()

		# And resize event
		$(window).on 'resize', =>
		  @redisplay()

		return

	calcLayout: ->
		# Compute window layout
		panMarginX = 20
		panMarginY = 30
		winWidth = window.innerWidth
		winHeight = window.innerHeight
		# winWidth = $(window).width()
		# winHeight = $(window).height()
		isPortrait = (winWidth < winHeight)
		if isPortrait
			@panWidth = winWidth - 2 * panMarginX
			@panHeight = @panWidth * @panSize.height / @panSize.width
			@panX = panMarginX
			@panY = winHeight - @panHeight - panMarginY
		else if winWidth/winHeight < 1.3
			@panWidth = winWidth * 0.83
			@panHeight = @panWidth * @panSize.height / @panSize.width
			@panX = panMarginX
			@panY = panMarginY
		else
			@panHeight = winHeight - 2 * panMarginY
			@panWidth = @panHeight * @panSize.width / @panSize.height
			@panX = panMarginX
			@panY = panMarginY

		# Pan bitmap
		@panBitmapRect = 
			x:@panX
			y:@panY
			width:@panWidth
			height:@panHeight
		# Note the following is intentionally using height instead of width as the bitmap
		# of the pan has the handle extending the width but the height is the diameter of the pan
		@pancakeSketchRect = 
			x:@panX
			y:@panY
			width:@panHeight
			height:@panHeight

		# Logo positioning
		if !isPortrait
			logoMarginY = 150
			logoBoxX = @panX + @panWidth * 0.83
			logoBoxY = @panY + logoMarginY
			logoBoxWidth = 214
			logoBoxHeight = logoBoxWidth
		else
			logoOnBottomRight = false
			if logoOnBottomRight
				logoBoxWidth = @panWidth * 0.2
				logoBoxHeight = logoBoxWidth
				logoBoxX = winWidth * 0.8 - 20
				logoBoxY = @panY + @panHeight - logoBoxWidth - 20
			else
				logoBoxWidth = 214
				logoBoxHeight = logoBoxWidth
				logoBoxX = panMarginX
				logoBoxY = panMarginY
		@logoRect =
			x: logoBoxX
			y: logoBoxY
			width: logoBoxWidth
			height: logoBoxHeight

		# Buttons
		if !isPortrait
			buttonsMarginY = 450
			buttonsBoxX = @panX + @panWidth * 0.83
			buttonsBoxY = @panY + buttonsMarginY
			buttonsBoxWidth = winWidth - buttonsBoxX
			buttonsBoxHeight = winHeight - buttonsBoxY
		else
			buttonsBoxX = winWidth * 0.5
			buttonsBoxY = panMarginY
			buttonsBoxWidth = 250
			buttonsBoxHeight = winHeight - @panY
		@buttonsRect =
			x: buttonsBoxX
			y: buttonsBoxY
			width: buttonsBoxWidth
			height: buttonsBoxHeight
		
		$(".app h1").text("winWid " + winWidth + " winHeight " + winHeight + " panSize " + JSON.stringify(@panSize) + "displayRect " + JSON.stringify(@panDisplayRect))

	go: ->

		# Create the pan display
		@calcLayout()
		@panDisplay = new PanDisplay("#sqWrapper", @panBitmapRect, @pancakeSketchRect, @buttonsRect, @logoRect)

		# Print
		$('#printbtn').on "click", =>
			pancakePath = @panDisplay.getPath()
			if pancakePath?
				$.ajax
					type: "POST"
					url: "print"
					contentType : 'application/json'
					data: JSON.stringify(pancakePath)
					success: ->
						console.log("Success")
					dataType: "json"

		# Create the path editor
		# @sketchpad = Raphael.sketchpad("editor", { width: 400, height: 400, editing: true })
		# @sketchpad.setCircularBounds()

		# When the sketchpad changes, update the input field.
			# sketchpad.change(function() {
			#     $("#data").html(sketchpad.json());
			# });
	
		# @sketchpad.change () =>
		# 	$("#debug1").html("Here")

		return

	redisplay: ->
		@calcLayout()
		@panDisplay.reposition(@panBitmapRect, @pancakeSketchRect, @buttonsRect, @logoRect)