class Block
    constructor: (@statements) ->

    toString: ->
        "(#{@statements.join(' ')})"

    java: ->
        block = "{\n"
        for statement in @statements
            block += "#{statement.java()}\n"
        return "#{block}}\n"

module.exports = Block
