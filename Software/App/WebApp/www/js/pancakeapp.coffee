
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
			<div id="debug1"></div>
			"""
		return

	go: ->

		# Create the pan display
		@panDisplay = new PanDisplay("#sqWrapper", {x:300,y:100,width:400,height:400})

		# Print
		$('#printbtn').on "click", =>
			$.ajax
				type: "POST"
				url: "print"
				data: JSON.stringify({ "thisIsData": "dataisThis" })
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

