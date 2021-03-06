class LeaderBoard
  constructor: ->
    
  updateStats: (json) ->
    return unless json.stats
    for countryName, count of json.stats
      if $("div[data-name='#{countryName}']").length != 0
        @updateCountry(countryName, count)
      else
        @insertCountry(countryName, count)
  
  updateCountry: (name, count) ->
    elem = $("div[data-name='#{name}']")
    $('.count', elem).html(count)
    
  insertCountry: (name, count) ->
    template = $("<div class='country' data-name='#{name}'><div class='name'>#{name}</div><div class='count'>#{count}</div></div>")
    $("#countries").append(template)
    
module.exports = LeaderBoard