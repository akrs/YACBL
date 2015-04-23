class Literal
    constructor: (@val) ->

    toString: ->
        return "#{@val.lexeme}"

module.exports = Literal
