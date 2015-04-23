class VarRef
    constructor: (@token) ->
        @id = @token.lexeme

    toString: ->
        return @id

    analyse: (context) ->
        if context.variables[@id]?
            return true
        else if context.parent?
            @analyse(context.parent)
        else
            error("use of variable #{id} before it was declared", @token.lexeme)
            return false

    generators: {
        java: ->
            return "_#{@id}"
    }

module.exports = VarRef
