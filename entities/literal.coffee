class Literal
    constructor: (@token) ->

    toString: ->
        return "#{@token.lexeme}"

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
