{isNumber, compatableNumbers} = require '../utils/typeutils'

class Assign
    constructor: (@varref, @op, @exp) ->

    toString: ->
        "#{@varref} #{@op} #{@exp}"

    java: ->
        return "_{@varref.java()} #{@op} #{@exp.java()};"
        
    type: (context) ->
        return undefined

    analyse: (context) ->
        if not @varref.analyse(context) # will return true if the var exists
            return false

        if isNumber(context.variables[@varref.id].type(context))
            unless compatableNumbers(context.variables[@varref.id], @exp.type(context))
                error("incompatiable number types", @varref.token.line)
                return false
        else
            if context.variables[@varref.id].type(context) isnt @exp.type(context)
                error("type mismatch", @varref.token.line)
                return false

        return true
    
module.exports = Assign
