class FunctionBlock
    constructor: (@statements, @returns) ->

    toString: ->
        "(#{@statements.join(' ')} #{@returns.join(' ')})"

    generator: {
        java: ->
            statemnts = "{\n"
            for statement in @statements
                statemnts += "#{statement.generator.java()}\n"
            return "\n" #TODO add returns
    }

module.exports = FunctionBlock