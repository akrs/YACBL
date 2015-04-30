class TupleAssignment
    constructor: (@names, @exps) ->

    toString: ->
        "(#{@names.join(' ')} #{@exp?.join(' ')})"

    #TODO, same as tupledec
    java: ->
        return "(_#{@names} #{@exp.generator.java()})"

module.exports = TupleAssignment
