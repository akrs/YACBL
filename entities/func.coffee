class Func
    constructor: (@id, @params, @returns, @block) ->

    # note, this entity is used by both full funcs and mere func types
    toString: ->
        "(function #{@id?.lexeme} #{@params.join(' ')}
                  #{if @returns[0] is 'void' then 'void' else @returns.join(' ')} #{@block?})"
    
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
            return "#{rets} _#{id}(#{@params.join(', '))#{blocks.generator.java()}"

    }

module.exports = Func

#TODO this func stuff figure out returns 
