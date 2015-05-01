class TupleAssignment
    constructor: (@names, @exps) ->

    toString: ->
        "(#{@names.join(' ')} #{@exp?.join(' ')})"

    #TODO, same as tupledec
    java: (context) ->
        return "(_#{@names} #{@exp.java()})"

module.exports = TupleAssignment
