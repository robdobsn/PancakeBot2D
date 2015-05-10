// Generated by CoffeeScript 1.7.1
var Express, app, bodyParser, http, moment, path, request;

http = require("http");

Express = require("express");

request = require('request');

moment = require('moment');

path = require('path');

bodyParser = require('body-parser');

app = Express();

app.set("port", process.env.PORT || 5294);

app.set("views", path.join(__dirname, "views"));

app.set("view engine", "jade");

app.use(bodyParser.text());

app.post("/print", function(req, res) {
  console.log("PRINT");
  console.log(JSON.stringify(req.body));
  console.log("PRINTPARAMS");
  console.log(JSON.stringify(req.route));
});

app.use("/", Express["static"](path.join(__dirname, '../../App/WebApp/www')));

app.use("/test", Express["static"](path.join(__dirname, 'public')));

app.use(function(req, res) {
  res.render("404", {
    url: req.url
  });
});

http.createServer(app).listen(app.get("port"), function() {
  console.log("PancakeBot2D test server listening on port " + app.get("port"));
});