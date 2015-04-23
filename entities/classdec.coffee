class ClassDec
    constructor: (@nameToken, @parentToken, @properties, @typeConversions) ->

    toString: ->
        "(Class #{@name.lexeme} parent: #{@parent.lexeme} Properties #{@properties.join(' ')})"

module.exports = ClassDec
