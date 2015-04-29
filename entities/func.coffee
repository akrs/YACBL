class Func
    constructor: (@id, @params, @returns, @block) ->

    # note, this entity is used by both full funcs and mere func types
    toString: ->
        "(function #{@name?.lexeme} #{@params.join(' ')}
                  #{if @returns[0] is 'void' then 'void' else @returns.join(' ')} #{@block?})"

module.exports = Func
