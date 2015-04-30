class If
    constructor: (@condition, @block) ->

    toString: ->
        "(#{@condition} #{@block})"

    java: ->
        "if(#{condition.generator.java()})#{block.generator.java()}"
        
module.exports = If