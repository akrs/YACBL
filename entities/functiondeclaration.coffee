class FunctionDeclaration
    constructor: (@id, @params, @returns, @block) ->

    toString: ->
        "(function #{@id.lexeme} #{@params.join(' ')}
                  #{@returns.join(' ')} #{@block})"

module.exports = FunctionDeclaration
