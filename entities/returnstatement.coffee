class ReturnStatement
    constructor: (@exp) ->
    
    toString: ->
        "#{@exp}"

    generator: {
        java: ->
            return "(#{@exp.generator.java()})"
    }

module.exports = ReturnStatement