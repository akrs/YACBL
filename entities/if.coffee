class If
    constructor: (@condition, @block) ->

    toString: ->
        "(#{@condition} #{@block})"

    java: ->
        "if(#{condition.java()})#{block.java()}"
        
module.exports = If