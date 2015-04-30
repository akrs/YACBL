class While
    constructor: (@condition, @block) ->

    toString: ->
        "(#{@condition} #{@block})"

    java: ->
        return "while ( #{@condition.java()} ) #{@block.java}"

module.exports = While