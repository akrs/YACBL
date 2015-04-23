class Statement
    constructor: (@loop, @if, @declaration, @assign, @exp) ->

    toString: ->
        "(#{@loop} #{@if} #{@declaration} #{@assign} #{@exp})"

module.exports = Statement