class Type
    constructor: (@type) ->

    toString: ->
        "(#{@type.lexeme})"

    generator: {
        java: ->
            return "(#{@type.lexeme})"
    }

module.exports = Type
