class VarRef
    constructor: (@idLex) ->
        @id = @idLex.lexeme

    generators: {
        java: ->
            return "_#{@id}"
    }

module.exports = VarRef
