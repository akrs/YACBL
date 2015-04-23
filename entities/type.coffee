class Type
    constructor: (@token) ->
        @id = @token.lexeme

    toString: ->
        "(#{@id})"

module.exports = Type
