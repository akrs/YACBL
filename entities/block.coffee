class Block
    constructor: (@statements) ->

    toString: ->
        "(#{@statements.join(' ')})"

    generator: {
        java: ->
            block = "{\n"
            @statements.forEach (@statement) ->
                block += "#{@statement.generator.java()}\n"
            return "#{block}}\n"
    }

module.exports = Block