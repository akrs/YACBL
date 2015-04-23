class PrimitiveDeclaration
    constructor: (@nameToken, @_type, @exp) ->
        @id = @nameToken.lexeme

    toString: ->
        "(#{@name.lexeme} #{@type?.lexeme} #{@exp?})"

    generator: {
        java: ->
            return "(#{@accessLevel.lexeme} #{if @final.lexeme? then 'final' else ''} #{@declaration.generator.java()} #{if @whereExp.generator.java()? then @whereExp.generator.java() else ''})"
    }

    analyse: (context) ->
        @_type ?= @exp.type(context)

        if context.variables[@id]?
            error("redeclaration of variable #{@id}", @nameToken.line)
            return

        if @type isnt @exp.type(context)
            error("type mismatch", @nameToken.line)
            return

        context.variables[@id] = this

    type: ->
        return @_type

module.exports = PrimitiveDeclaration
