class PropDec
    constructor: (@accessLevel, @final, @declaration, @whereExp) ->

    toString: ->
        "(#{@accessLevel} #{if @final? then 'final' else ''} #{@declaration} #{if @whereExp? then @whereExp else ''})"

module.exports = PropDec
