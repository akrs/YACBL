class BinaryExpression
    constructor: (@leftSide, @op, @rightSide) ->

    toString: ->
        "(#{@leftSide} #{@op} #{@rightSide}"

module.exports = BinaryExpression