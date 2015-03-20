class If
    constructor: (@exp, @block) ->

    toString: ->
        "(#{@exp} #{@block})"