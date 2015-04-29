class FunctionDeclaration
    constructor: (@id, @params, @returns, @block) ->

    toString: ->
        "(function #{@name.lexeme} #{@params.join(' ')}
                  #{@returns.join(' ')} #{@block})"

module.exports = FunctionDeclaration
