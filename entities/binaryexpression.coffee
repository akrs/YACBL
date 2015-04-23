class BinaryExpression
    constructor: (@leftSide, @opToken, @rightSide) ->
        @op = @opToken.lexeme

    toString: ->
        "(#{@leftSide} #{@op} #{@rightSide}"

    generator: {
        java: ->
            return "{@leftSide.generator.java()} #{@op} #{@rightSide.generator.java()}"
    }

module.exports = BinaryExpression