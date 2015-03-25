class BinaryExpression
    constructor: (@op, @left, @right) ->

    toString: ->
        "(#{@op.lexeme} #{@left} #{@op.right}"

module.exports = BinaryExpression