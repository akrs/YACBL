class If
    constructor: (@condition, @block, @elseBlock) ->

    toString: ->
        "(#{@condition} #{@block})"

    java: ->
        "if(#{@condition.java()})#{@block.java()} else #{@elseBlock.java()}"
        
module.exports = If