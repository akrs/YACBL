class PropDec
    constructor: (@type, @declaration, @exp) ->

    toString: ->
        "(#{@type} #{@declaration} #{@exp})"

module.exports = PropDec