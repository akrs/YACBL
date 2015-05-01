class If
    constructor: (@condition, @block, @elseBlock) ->

    toString: ->
        "(#{@condition} #{@block})"

    java: (context) ->
        "if(#{@condition.java()})#{@block.java()} else #{@elseBlock.java()}"
        
module.exports = If