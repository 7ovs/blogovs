require "colors"
exs    = require "express"
ect    = require "ect"
fs     = require "fs"
moment = require "moment"
logger = require "morgan"

app = exs()

app
  .disable("x-powered-by")
  .set("view engine", "ect")
  .engine('ect', ect(
      root : __dirname + '/views'
      ext : '.ect'
      cache: no
    ).render)
  
app.use(logger("short"))



app.get '/', (req, res) ->
  res.render 'index'
  

app.use(exs.static("pub"))

app.use (req, res, next) ->
  res.status 404
  if req.accepts('html')
    res.render '404', url: req.url
  if req.accepts('json')
    res.send error: 'Not found'
  res.type('txt').send 'Not found'

app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render '500', error: err

port = process.env.PORT || 3000
app.listen(port)
console.log "start server on port #{port}".green