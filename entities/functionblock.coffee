class FunctionBlock
    constructor: (@statements, @returns) ->

    toString: ->
        "(#{@statements.join(' ')} #{@returns.join(' ')})"

    java: (funcName) ->
        statemnts = "{\n"
        for statement in @statements
            statemnts += "#{statement.java()}\n"
        rets = "_returns_#{funcName} _returns_oject = new _returns_#{funcName}();\n#{@returns?.java(funcName)}\n"
        return "#{statemnts}\n#{rets}"

module.exports = FunctionBlock