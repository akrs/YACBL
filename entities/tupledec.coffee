class TupleDec
    constructor: (@names, @types, @exps) ->

    toString: ->
        "(#{@names.join(' ')} #{@type?.join(' ')} #{@exp?.join(' ')})"

#TODO, gotta fix this and do it later since java doesnt do tuples 
    java: ->
        return "(_#{@names} #{type.generator.java()} #{@exp.generator.java()})"

module.exports = TupleDec
