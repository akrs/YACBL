class Type
    constructor: (@token) ->
        @id = @token.lexeme

    toString: ->
        "(#{@id})"

    java: ->
        return "(#{@id})"

module.exports = Type
