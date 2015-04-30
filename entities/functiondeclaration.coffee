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
        return "#{rets} #{id}(#{@params.join(', ')})#{@block.java(id)}"

module.exports = FunctionDeclaration
