class PropDec
    constructor: (@accessLevel, @final, @declaration, @whereExp) ->

    toString: ->
        "(#{@accessLevel} #{if @final? then 'final' else ''} #{@declaration} #{if @whereExp? then @whereExp else ''})"

    java: ->
        return "(#{@accessLevel.lexeme} #{if @final.lexeme? then 'final' else ''} #{@declaration.generator.java()} #{if @whereExp.generator.java()? then @whereExp.generator.java() else ''})"

module.exports = PropDec
