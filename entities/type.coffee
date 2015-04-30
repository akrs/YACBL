class Type
    constructor: (@token) ->
        @id = @token.lexeme

    toString: ->
        "(#{@id})"

    java: ->
        return "(#{@type.lexeme})"

module.exports = Type
