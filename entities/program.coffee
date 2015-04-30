class Program
    constructor: (@declarations) ->

    toString: ->
        "(Program #{@declarations.join(' ')})"

    java: ->
        dec = ""
        for declaration in @declarations
                dec += "(#{declaration.generator.java()})\n"
        return dec

module.exports = Program
