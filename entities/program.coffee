class Program
    constructor: (@declarations) ->

    toString: ->
        "(Program #{@declarations.join(' ')})"

    java: ->
        dec = ""
        for declaration in @declarations
                dec += "\t#{declaration.java()}\n"
        return "public class Program{\n#{dec}\n}"

module.exports = Program
