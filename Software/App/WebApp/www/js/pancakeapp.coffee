
$(document).ready ->
	pancakeApp = new PancakeApp()
	$(document).on "touchmove", (evt) ->
		evt.preventDefault()
	$(document).on "touchmove", ".scrollable", (evt) ->
		evt.stopPropagation()
	# Go
	pancakeApp.go()
	return

class PancakeApp
	constructor: ->
		# Size of pan bitmap - in landscape mode (portrait is just swapped)
		@panSize = 
			width: 838
			height: 667
		# Basic body for DOM
		$("body").prepend """
			<div id="sqWrapper">
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

		# Backdrop bitmap
		@backdropBitmapRect = 
			x:0
			y:0
			width: winWidth
			height: winHeight

		@isPortrait = (winWidth < winHeight)
		if @isPortrait
			@panWidth = winWidth - 2 * panMarginX
			@panHeight = @panWidth * @panSize.width / @panSize.height
			if @panHeight > winHeight - 2 * panMarginY
				@panHeight = winHeight - 2 * panMarginY
				@panWidth = @panHeight * @panSize.height / @panSize.width
		else
			@panWidth = winWidth - 2 * panMarginX
			@panHeight = @panWidth * @panSize.height / @panSize.width
			if @panHeight > winHeight - 2 * panMarginY
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
			portrait:@isPortrait

		# Note the following is intentionally using height instead of width as the bitmap
		# of the pan has the handle extending the width but the height is the diameter of the pan
		@pancakeSketchRect = 
			x:@panX
			y:@panY
			width: if @isPortrait then @panWidth else @panHeight
			height: if @isPortrait then @panWidth else @panHeight

		# Buttons
		if @isPortrait
			buttonsBoxX = panMarginX + @panWidth / 4
			buttonsBoxY = panMarginY * 3 + @panWidth
			buttonsBoxWidth = 250
			buttonsBoxHeight = winHeight - @panY
			isVertical = false
		else
			buttonsMarginY = panMarginY + @panHeight / 5
			buttonsBoxX = @panX + @panWidth * 0.83
			buttonsBoxY = @panY + buttonsMarginY
			buttonsBoxWidth = winWidth - buttonsBoxX
			buttonsBoxHeight = winHeight - buttonsBoxY
			isVertical = true
		@buttonsRect =
			x: buttonsBoxX
			y: buttonsBoxY
			width: buttonsBoxWidth
			height: buttonsBoxHeight
			vertical: isVertical
		
		# $(".app h1").text("winWid " + winWidth + " winHeight " + winHeight + " panSize " + JSON.stringify(@panSize) + "displayRect " + JSON.stringify(@panDisplayRect))
		return
		
	go: ->

		# Create the pan display
		@calcLayout()
		@panDisplay = new PanDisplay("#sqWrapper", "http://robdobson.com/pancakebot/", @backdropBitmapRect, @panBitmapRect, @pancakeSketchRect, @buttonsRect)

		# Print
		$('#printbtn').on "click", =>
			pancakeData =
				panBounds: @panDisplay.getPanBoundary()
				strokes: @panDisplay.getStrokes()
			# Convert to JSON
			pancakeDataJson = JSON.stringify(pancakeData)
			# Send to pancakebot
			@sendChunkToBot(pancakeDataJson, true)
			return

		return

	redisplay: ->
		@calcLayout()
		@panDisplay.reposition(@backdropBitmapRect, @panBitmapRect, @pancakeSketchRect, @buttonsRect)
		return

	sendChunkToBot: (strokeRemainder, firstChunk) =>
		# Send in several pieces if required
		MAX_CONTENT_POST_MSG = 500
		if firstChunk
			if strokeRemainder.length <= MAX_CONTENT_POST_MSG
				urlToUse = "printinitgo"
			else
				urlToUse = "printinit"
		else
			if strokeRemainder.length > MAX_CONTENT_POST_MSG
				urlToUse = "printpart" 
			else 
				urlToUse = "printgo"
		if strokeRemainder.length is 0
			@postStrokesCompleted()
		else
			console.log("Sending " + urlToUse + " " + strokeRemainder.slice(0,MAX_CONTENT_POST_MSG).length)
			$.ajax
				type: "POST"
				url: urlToUse
				contentType : 'text/plain'
				data: strokeRemainder.slice(0,MAX_CONTENT_POST_MSG)
				success: =>
					remainder = strokeRemainder.slice(MAX_CONTENT_POST_MSG)
					@sendChunkToBot(remainder, false)
					return
		return

	postStrokesCompleted: ->
		console.log("completed POST")
		return
