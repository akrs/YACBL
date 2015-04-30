class UnaryExpression
    constructor: (@operand, @preOrPostfix, @op) ->

    toString: ->    #might need refactoring?
        if @preOrPostfix is 'postfix' then "(#{@operand} #{@op})" else "(#{@op} #{@operand})"
 
    java: ->
        return if @preOrPostfix is 'postfix' then "(#{@operand.generator.java()} #{@op})" else "(#{@op} #{@operand.generator.java()})"

module.exports = UnaryExpression