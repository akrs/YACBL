utils = require '../utils/typeutils'
isNumber = utils.isNumber
leastCommonNumber = utils.leastCommonNumber

class BinaryExpression
    constructor: (@leftSide, @opToken, @rightSide) ->
        @op = @opToken.lexeme

    toString: ->
        "(#{@leftSide} #{@op} #{@rightSide}"

    typesBothInList: (list) ->
        typeMatch = (variable) ->
            return list.some((type) -> variable.type() is type)

        return typeMatch(@leftSide) and typeMatch(@rightSide)

    bothAreNumbers: (context) ->
        return isNumber(@leftSide.type(context)) and isNumber(@rightSide.type(context))

    leastCommonNumber: (context) ->
        return leastCommonNumber(@leftSide.type(context), @rightSide.type(context))

    analyse: (context) ->
        switch @op
            when '<<', '>>', '|', '&', '^'
                return undefined unless @typesBothInList(['int', 'uint'])
                return @leastCommonNumber(context)
            when '+', '-', '*', '/', '%'
                return undefined unless @bothAreNumbers(context)
                return @leastCommonNumber(context)
            when '...', '..<'
                return undefined unless @typesBothInList(['int', 'uint'])
                return 'range expression'
            when '<', '>', '<=', '>=', '==', '!='
                return undefined unless @bothAreNumbers(context)
                return 'bool'
            when '&&', '||'
                return undefined unless @typesBothInList(['bool'])
                return 'bool'
            when '.'
                return @leftSide.type(context)?.properties[@rightSide.id]?.type()
            else
                return undefined

module.exports = BinaryExpression
