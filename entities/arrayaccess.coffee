class ArrayAccess
    # This should be varref, expression
    constructor: (@varref, @exp) ->
        
    toString: ->
        "#{@varref.id}[#{@exp}]"

    java: (context) ->
        return "_#{@varref.id}[#{@exp.java()}]"

    type: (context) ->
        return context.variables[@varref.id].innerType?.type(context)

    analyse: (context) ->
        unless @varref.analyse(context)
            return false

        if context.variables[@varref.id].type(context) isnt 'Array'
            error('attempting to index non-array type', @varref.token.line)
            return false

        return true

module.exports = ArrayAccess
