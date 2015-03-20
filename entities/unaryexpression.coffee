class UnaryExpression
    constructor: (@op, @operand) ->

    toString: ->
        "(#{@op.lexeme} #{@operand}"