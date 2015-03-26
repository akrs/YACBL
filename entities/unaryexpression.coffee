class UnaryExpression
    constructor: (@operand, @preOrPostfix, @op) ->

    toString: ->    #might need refactoring?
        if @preOrPostfix is 'postfix' then "(#{@operand} #{@op})" else "(#{@op} #{@operand})"

module.exports = UnaryExpression