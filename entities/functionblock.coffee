class FunctionBlock
    constructor: (@statements, @returns) ->

    toString: ->
        "(#{@statements.join(' ')} #{@returns.join(' ')})"

    java: (funcName) ->
        statemnts = "{\n"
        for statement in @statements
            statemnts += "\t\t#{statement.java()};\n"
        rets = if !@returns then '' else "$returns_#{funcName} $returns_object = new $returns_#{funcName}();\n#{@returns?.java(funcName)}\n"
        return "#{statemnts}\n\t\t#{rets}}"

module.exports = FunctionBlock
