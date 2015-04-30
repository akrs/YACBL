{isNumber, leastCommonNumber} = require '../utils/typeutils'
error = require('../error').analysisError

class BinaryExpression
    constructor: (@leftSide, @opToken, @rightSide) ->
        @op = @opToken.lexeme

    toString: ->
        "(#{@leftSide} #{@op} #{@rightSide}"
            
    java: ->
        return "{@leftSide.generator.java()} #{@op} #{@rightSide.generator.java()}"

    typesBothInList: (list, context) ->
        typeMatch = (variable) ->
            return list.some((type) -> variable.type(context) is type)

        return typeMatch(@leftSide) and typeMatch(@rightSide)

    bothAreNumbers: (context) ->
        return isNumber(@leftSide.type(context)) and isNumber(@rightSide.type(context))

    leastCommonNumber: (context) ->
        return leastCommonNumber(@leftSide.type(context), @rightSide.type(context))

    type: (context) ->
        switch @op
            when '<<', '>>', '|', '&', '^'
                return undefined unless @typesBothInList(['int', 'uint'], context)
                return @leastCommonNumber(context)
            when '+', '-', '*', '/', '%'
                return undefined unless @bothAreNumbers(context)
                return @leastCommonNumber(context)
            when '...', '..<'
                return undefined unless @typesBothInList(['int', 'uint'], context)
                return 'range expression'
            when '<', '>', '<=', '>=', '==', '!='
                return undefined unless @bothAreNumbers(context)
                return 'bool'
            when '&&', '||'
                return undefined unless @typesBothInList(['bool'], context)
                return 'bool'
            when '.'
                return @leftSide.type(context)?.properties[@rightSide.id]?.type(context)
            else
                return undefined

    analyse: (context) ->
        unless @leftSide.analyse(context) and @rightSide.analyse(context)
            return false

        switch @op
            when '<<', '>>', '|', '&', '^'
                unless @typesBothInList(['int', 'uint'], context)
                    error('expected int or uint', @opToken.line)
                    return false
            when '+', '-', '*', '/', '%'
                unless @bothAreNumbers(context)
                    error('cannot do math on non-number', @opToken.line)
                    return false
            when '...', '..<' # TODO: Generate runtime code to throw exception if the range is backwards
                unless @typesBothInList(['int', 'uint'], context)
                    error('expected int or uint', @opToken.line)
                    return false
            when '<', '>', '<=', '>=', '==', '!='
                unless @bothAreNumbers(context)
                    error('cannot compare non-numbers', @opToken.line)
                    return false
            when '&&', '||'
                unless @typesBothInList(['bool'], context)
                    error('require boolean types for and or or', @opToken.line)
                    return false
            when '.'
                if not @leftSide.type(context).properties[@rightSide.id]?
                    error("cannot find property #{@rightSide.id} of type #{@leftSide.type(context)}", @opToken.line)
                    return false
            else
                error("unrecognized operator #{@op}", @opToken.line)
                return false

        return true

module.exports = BinaryExpression
