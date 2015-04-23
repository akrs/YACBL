class Exp
    constructor: (@exp1, @boolops, @exp1s) ->

    toString: ->
        "(#{@exp1} #{@boolops} #{@exp1s})"

module.exports = Exp
#TODO not used