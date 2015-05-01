class ClassDec
    constructor: (@nameToken, @parentToken, @properties, @typeConversions) ->
        @name = @nameToken.lexeme
        @parent = @parentToken.lexeme

    toString: ->
        "(Class #{@name.lexeme} parent: #{@parent.lexeme} Properties #{@properties.join(' ')})"

module.exports = ClassDec
