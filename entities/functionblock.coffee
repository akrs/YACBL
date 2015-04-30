class FunctionBlock
    constructor: (@statements, @returns) ->

    toString: ->
        "(#{@statements.join(' ')} #{@returns.join(' ')})"

    java: (funcName) ->
        statemnts = "{\n"
        for statement in @statements
            statemnts += "#{statement.generator.java()}\n"
        rets = "_returns_#{funcName} _returns_oject = new _returns_#{funcName}();\n#{@returns.generator.java(funcName)}\n"
        return "#{statements}\n#{rets}"

module.exports = FunctionBlock