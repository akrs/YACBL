class While
    constructor: (@condition, @block) ->

    toString: ->
        "(#{@condition} #{@block})"

    java: ->
        return "while ( #{@condition.generator.java()} ) #{@block.generator.java}"

module.exports = While