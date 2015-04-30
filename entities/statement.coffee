class Statement
    constructor: (@loop, @if, @declaration, @assign, @exp) ->

    toString: ->
        "(#{@loop} #{@if} #{@declaration} #{@assign} #{@exp})"

    java: ->
        return "(#{@loop.java()} #{@if.java()} #{@declaration.java()} #{@assign.generator,java()} #{@exp.java()})"
    
module.exports = Statement

#TODO, this entity is actually never used/call 