class Stats
  constructor: ->
    @scoreboard = {}
    
  update: (geo) =>
    console.log("geo!!!", geo)
    if @scoreboard[geo.country]?
      ++@scoreboard[geo.country]
    else
      @scoreboard[geo.country] = 1
      
    console.log(@scoreboard)
    return @scoreboard
    
module.exports = new Stats()