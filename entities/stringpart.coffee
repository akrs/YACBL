class StringPart
    constructor: (@parts) ->

    toString: ->
        "#{parts.join(' ')}"

module.exports = StringPart
