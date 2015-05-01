class FunctionBlock
    constructor: (@statements, @returns) ->

    toString: ->
        "(#{@statements.join(' ')} #{@returns.join(' ')})"

    java: (context) ->
        statemnts = "{\n"
        for statement in @statements
            statemnts += "\t\t#{statement.java()};\n"
        rets = if !@returns then '' else "$returns_#{context.funcName} $returns_object = new $returns_#{context.funcName}();\n#{@returns?.java(context.funcName)}\n"
        return "#{statemnts}\n\t\t#{rets}}"

module.exports = FunctionBlock
