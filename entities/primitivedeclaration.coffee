class PrimitiveDeclaration
    constructor: (@name, @type, @exp) ->

    toString: ->
        "(#{@name.lexeme} #{@type?.lexeme} #{@exp?})"

module.exports = PrimitiveDeclaration
