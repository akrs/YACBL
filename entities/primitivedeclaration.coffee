class PrimitiveDeclaration
    constructor: (@nameToken, @_type, @exp) ->
        @id = @nameToken.lexeme

    toString: ->
        "(#{@id} #{@_type?.lexeme} #{@exp?})"

    java: ->
        return "(#{@_type.lexeme} _#{@id} = #{@exp.generator.java()})"

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
