class Type
    constructor: (@type) ->

    toString: ->
        "(#{@type.lexeme})"

module.exports = Type
