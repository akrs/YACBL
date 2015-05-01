class Func
    constructor: (@id, @params, @returns, @block) ->

    # note, this entity is used by both full funcs and mere func types    
    toString: ->
        "(function #{@id?.lexeme} #{@params.join(' ')}
                  #{if @returns[0] is 'void' then 'void' else @returns.join(' ')} #{@block?})"
    
    java: (context) ->
        rets = if @returns[0] is 'void' then 'void' else @returns.join(', ') #not sure if coffee is best coffee
        return "func (#{@params.join(', ')}) -> (#{@rets})"  

module.exports = Func

#TODO this func stuff figure out returns 
