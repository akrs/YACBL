class Exp
    constructor: (@exp1, @boolops, @exp1s) ->

    toString: ->
        "(#{@exp1} #{@boolops} #{@exp1s})"