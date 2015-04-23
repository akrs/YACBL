class While
    constructor: (@condition, @block) ->

    toString: ->
        "(#{@condition} #{@block})"

    generator: {
        java: ->
            return "while ( #{@condition.generator.java() ) #{@block.generator.java}"
    }

module.exports = While