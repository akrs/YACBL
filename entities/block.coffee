class Block
    constructor: (@statements) ->

    toString: ->
        "(#{@statements.join(' ')})"

    generator: {
        java: ->
            block = "{\n"
            for statement in @statements
                block += "#{statement.generator.java()}\n"
            return "#{block}}\n"
    }

module.exports = Block
