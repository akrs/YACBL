class ArrayAccess
    constructor: (@token, @exp) ->
        @id = @token.lexeme

    toString: ->
        "#{@id}[#{@exp}]"

    generator: {
        java: ->
            return "#yac_{@id}[#{@exp.generator.java()}]"
    }

module.exports = ArrayAccess
