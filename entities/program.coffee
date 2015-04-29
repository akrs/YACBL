class Program
    constructor: (@declarations) ->

    toString: ->
        "(Program #{@declarations.join(' ')})"

    generator: {
        java: ->
            dec = ""
            for declaration in @declarations
                    dec += "(#{declaration.generator.java()})\n"
            return dec
    }

module.exports = Program
