class FunctionDeclaration
    constructor: (@name, @params, @returns, @block) ->

    toString: ->
        "(function #{@name.lexeme} #{@params.join(' ')}
                  #{@returns.join(' ')} #{@block})"

module.exports = FunctionDeclaration
