class ClassDec
    constructor: (@name, @parent, @properties) ->

    toString: ->
        "(Class #{@name.lexeme} parent: #{@parent.lexeme} Properties #{@properties.join(' ')})"

module.exports = ClassDec
