class Type
    constructor: (@typeToken) ->
        @id = @typeToken.lexeme

    toString: ->
        "(#{@id})"

module.exports = Type
