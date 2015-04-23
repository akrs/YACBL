class Type
    constructor: (@token) ->
        @id = @token.lexeme

    toString: ->
        "(#{@id})"

    generator: {
        java: ->
            return "(#{@type.lexeme})"
    }

module.exports = Type
