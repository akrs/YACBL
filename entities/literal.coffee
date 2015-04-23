class Literal
    constructor: (@val) ->

    toString: ->
        "#{@val.lexeme}"

module.exports = Literal
