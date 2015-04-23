class FunctionCall
    constructor: (@id, @params) ->

    toString: ->
        "(#{id.lexeme} (#{params?.join(' ')}))"

    generator: {
        java: ->
            args = ""
            for param in params
                args += "#{param.generator.java()}, "
            args = args[0..(args.length - 3)]
            return "#{@id}(#{args})"
    }

module.exports = FunctionCall
