class FunctionDeclaration
    constructor: (@id, @params, @returns, @block) ->

    toString: ->
        "(function #{@id.lexeme} #{@params.join(' ')}
                  #{@returns.join(' ')} #{@block})"
    
    generator: {
        java: ->
            rets = ""
            if @returns[0] is 'void'
                rets = "void"
            else
                returnDeclorations = ""
                for type, i in @returns
                    returnDeclorations += "public #{type} _#{i};\n"
                rets = "class _returns_#{@id.lexeme}{\n#{returnDeclorations}}\n _returns_#{@id.lexeme}"
            return "#{rets} _#{id.lexeme}(#{@params.join(', ')})#{block.generator.java(@id.lexeme)}"
    }

module.exports = FunctionDeclaration
