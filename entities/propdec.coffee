class PropDec
    constructor: (@accessLevel, @final, @declaration, @whereExp) ->

    toString: ->
        "(#{@accessLevel} #{if @final? then 'final' else ''} #{@declaration} #{if @whereExp? then @whereExp else ''})"

    java: ->
        return "(#{@accessLevel.lexeme} #{if @final.lexeme? then 'final' else ''} #{@declaration.java()} #{if @whereExp.java()? then @whereExp.java() else ''})"

module.exports = PropDec
