class Literal
    constructor: (@token) ->

    toString: ->
        "#{@token.lexeme}"

    java: ->
        lit = if type() is 'String' then "\"#{@token.lexeme}\""
        console.log lit
        return lit

    type: ->
        switch @token.kind
            when 'FLOATLIT'
                return 'float'
            when 'INTLIT'
                return 'int'
            when 'STRLIT'
                return 'String'

    analyse: ->
        return true

module.exports = Literal
