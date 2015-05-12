http = require("http")
Express = require("express")
request = require('request')
moment = require('moment')
path = require('path')
bodyParser = require('body-parser')

# Use bodyParser to parse application/json
jsonParser = bodyParser.json()

app = Express()
app.set "port", process.env.PORT or 5294 # Arbitrarily chosen port number
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"

# app.get "/energy/:series?/:rollupperiod?", (req, res) ->
#   if (req.params.series isnt undefined)
#     series = req.params.series
#   if (req.params.rollupperiod isnt undefined)
#     rollupperiod = req.params.rollupperiod
#   if series? and rollupperiod?

lastPath = []

app.post "/print", jsonParser, (req, res) ->
  console.log(JSON.stringify(req.body))
  lastPath = req.body
  return

app.get "/path", (req, res) ->
  res.send(JSON.stringify(lastPath))
  console.log("Sending path")

app.use("/", Express.static(path.join(__dirname, '../../App/WebApp/www')));
app.use("/test", Express.static(path.join(__dirname, 'public')));

app.use (req, res) ->
  res.render "404",
    url: req.url
  return

http.createServer(app).listen app.get("port"), ->
  console.log "PancakeBot2D test server listening on port " + app.get("port")
  return
