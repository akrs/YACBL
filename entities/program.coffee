class Program
    constructor: (@declarations) ->

    toString: ->
        "(Program #{@declarations.join(' ')})"

    generator: {
        java: ->
            dec = ""
            for declaration in @declarations
                    dec += "(#{@declarations.generator.java()})\n"
            return dec
    }

module.exports = Program
