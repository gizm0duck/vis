# All credit for all intelligent happenings in here goes to https://github.com/pthrasher/twittergeo
class Blip
  constructor: ->
    @po = org.polymaps
    @map = @po.map().container(d3.select('#map').append("svg:svg").node()).zoom(3).center({lat:27.57,lon:8}).add(@po.interact())

    @map.add(@po.image().url(@po.url("http://{S}tile.cloudmade.com/c79457282b3a4bcc9c9259ae1766eacd/999/256/{Z}/{X}/{Y}.png").hosts(["a.", "b.", "c.", ""])))

    @map.add(@po.compass().pan("none"))
    @layer = d3.select("#map svg").insert("svg:g").attr('class','points')
    # @socket = new io.Socket("http://localhost", {port: 80})
    # @socket.on 'geocodeData', (data) =>
    #  @bloop(data.lat, data.long, data.eventName)

  draw: (x, y, duration, startFillColor, endFillColor, startStroke, endStroke, startRadius, endRadius, startColor, endColor) ->
    @layer.append("svg:circle")
      .attr("cx", x)
      .attr("cy", y)
      .attr("r", startRadius)
      .attr("class",'')
      .style("fill", startFillColor)
      .style("stroke", startColor)
      .style("stroke-opacity", startStroke.opacity)
      .style("stroke-width", startStroke.width)
      .transition()
      .duration(duration)
      .ease(Math.sqrt)
      .attr("r", endRadius)
      .style("fill", endFillColor)
      .style("stroke", endColor)
      .style("stroke-opacity", endStroke.opacity)
      .style("stroke-width", endStroke.width)
      .remove()

  bloop: (lat, long, eventName='') ->
    p = @map.locationPoint({lat: lat, lon: long});
    data = @eventMap(eventName)
    @draw(p.x, p.y, 2000, 'none', 'none', {width:data.startStroke, opacity:1}, {width:1, opacity:0}, 0, 50, data.startColor, data.endColor)

  # window.blip.bloop(35.2269, -80.8433, 'firstRequest')
  # window.blip.bloop(35.2269, -80.8433, 'request')
  eventMap: (eventName) ->
    eventMapping =
      firstRequest: {startColor: 'hsl(0,20%,88%)', endColor: 'hsl(0,90%,48%)', startStroke: 10}
      request: {startColor: 'hsl(205,70%,88%)', endColor: 'hsl(205,70%,48%)', startStroke: 3}
    return eventMapping[eventName] || eventMapping['request']

module.exports = Blip
