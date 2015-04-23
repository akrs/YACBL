class FunctionDeclaration
    constructor: (@id, @params, @returns, @block) ->

    toString: ->
        "(function #{@id.lexeme} #{@params.join(' ')}
                  #{@returns.join(' ')} #{@block})"
    
    generator: {
        java: ->
            args = ""
            for param in params
                args += "#{param.generator.java()}, "
            args = args[0..(args.length - 3)]
            return "#{returns} #{id.lexeme}(#{args})#{block.generator.java()}" #TODO fix returns
    }

module.exports = FunctionDeclaration
