class UnaryExpression
    constructor: (@operand, @preOrPostfix, @op, @typeStr) ->

    toString: ->    #might need refactoring?
        if @preOrPostfix is 'postfix' then "(#{@operand} #{@op})" else "(#{@op} #{@operand})"
 
    java: (context) ->
        return if @preOrPostfix is 'postfix' then "(#{@operand.java()} #{@op})" else "(#{@op} #{@operand.java()})"

module.exports = UnaryExpression