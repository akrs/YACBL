class Literal
    constructor: (@token) ->

    toString: ->
        "#{@token.lexeme}"

    java: (context) ->
        lit = if @type() is 'String' then "\"#{@token.lexeme}\"" else "#{@token.lexeme}"
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
