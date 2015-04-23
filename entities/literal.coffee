class Literal
    constructor: (@val) ->

    toString: ->
        return "#{@val.lexeme}"

    type: ->
        switch @val.kind
            when 'FLOATLIT'
                return 'float'
            when 'INTLIT'
                return 'int'
            when 'STRLIT'
                return 'String'

module.exports = Literal
