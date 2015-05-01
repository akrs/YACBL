class Type
    constructor: (@token) ->
        @id = @token.lexeme

    toString: ->
        "#{@id}"

    java: (context) ->
        return "#{@id}"

module.exports = Type
