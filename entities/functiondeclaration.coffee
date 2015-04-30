lookup = require('../generator').lookup
class FunctionDeclaration
    constructor: (@id, @params, @returns, @block) ->

    toString: ->
        "(function #{@id} #{@params.join(' ')}
                  #{@returns.join(' ')} #{@block})"
    
    java: ->
        rets = ""
        id = lookup[@id] || "_#{@id}"
        if id is 'main'
            return "public static void main(String[] args)#{@block.java(id)}"
        else if @returns[0].lexeme is 'void'
            rets = "public static void"
        else
            returnDeclorations = ""
            for type, i in @returns
                returnDeclorations += "public #{type.java()} _#{i};\n"
            rets = "class $returns_#{id}{\n#{returnDeclorations}}\n public static $returns_#{id}"
        params = ""
        for param in @params
            params += "#{param.type} #{param.name.lexeme},"
        params = params[..-2]
        return "#{rets} #{id}(#{params})#{@block.java(id)}"

module.exports = FunctionDeclaration
