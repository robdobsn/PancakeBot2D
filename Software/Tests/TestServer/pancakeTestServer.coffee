http = require("http")
Express = require("express")
request = require('request')
moment = require('moment')
path = require('path')
bodyParser = require('body-parser')

app = Express()
app.set "port", process.env.PORT or 5294 # Arbitrarily chosen port number
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"

app.use(bodyParser.text())

# app.get "/energy/:series?/:rollupperiod?", (req, res) ->
#   if (req.params.series isnt undefined)
#     series = req.params.series
#   if (req.params.rollupperiod isnt undefined)
#     rollupperiod = req.params.rollupperiod
#   if series? and rollupperiod?

app.post "/print", (req, res) ->
  console.log("PRINT")
  console.log(JSON.stringify(req.body))
  console.log("PRINTPARAMS")
  console.log(JSON.stringify(req.route))
  return

app.use("/", Express.static(path.join(__dirname, '../../App/WebApp/www')));
app.use("/test", Express.static(path.join(__dirname, 'public')));

app.use (req, res) ->
  res.render "404",
    url: req.url
  return

http.createServer(app).listen app.get("port"), ->
  console.log "PancakeBot2D test server listening on port " + app.get("port")
  return
