class FunctionBlock
    constructor: (@statements, @returns) ->

    toString: ->
        "(#{@statements.join(' ')} #{@returns.join(' ')})"

    java: (funcName) ->
        statemnts = "{\n"
        for statement in @statements
            statemnts += "\t\t#{statement.java()};\n"
        rets = if !@returns then '' else "_returns_#{funcName} _returns_oject = new _returns_#{funcName}();\n#{@returns?.java(funcName)}\n"
        return "#{statemnts}\n\t\t#{rets}}"

module.exports = FunctionBlock