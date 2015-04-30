class Statement
    constructor: (@loop, @if, @declaration, @assign, @exp) ->

    toString: ->
        "(#{@loop} #{@if} #{@declaration} #{@assign} #{@exp})"

    java: ->
        return "(#{@loop.generator.java()} #{@if.generator.java()} #{@declaration.generator.java()} #{@assign.generator,java()} #{@exp.generator.java()})"
    
module.exports = Statement

#TODO, this entity is actually never used/call 