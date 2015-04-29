class TupleAssignment
    constructor: (@names, @exps) ->

    toString: ->
        "(#{@names.join(' ')} #{@exp?.join(' ')})"

module.exports = TupleAssignment
