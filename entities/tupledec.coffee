class TupleDec
    constructor: (@names, @types, @exps) ->

    toString: ->
        "(#{@names.join(' ')} #{@type?.join(' ')} #{@exp?.join(' ')})"

#TODO, gotta fix this and do it later since java doesnt do tuples 
    java: ->
        return "(_#{@names} #{type.java()} #{@exp.java()})"

module.exports = TupleDec
