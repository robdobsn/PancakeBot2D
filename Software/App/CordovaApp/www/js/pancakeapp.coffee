
$(document).ready ->
	pancakeApp = new PancakeApp()
	pancakeApp.go()

class PancakeApp
	constructor: ->
		# Basic body for DOM
		$("body").prepend """
			<div id="sqWrapper">
		        <div class="app">
		            <h1>Pancake Bot 2D</h1>
		        </div>
			</div>
			"""
		return

	go: ->

		# Create the pan display
		panDisplay = new PanDisplay("#sqWrapper", {x:700,y:100,width:400,height:400})
		return

