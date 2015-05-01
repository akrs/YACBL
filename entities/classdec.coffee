class ClassDec
    constructor: (@nameToken, @parentToken, @properties, @typeConversions) ->
        @name = @nameToken.lexeme
        @parent = @parentToken.lexeme
    toString: ->
        "(Class #{@name} parent: #{@parent} Properties #{@properties.join(' ')})"

    java: (context) ->
        props = ""
        
        for property in @properties
            props += properties.java()

        return "class #{@name} extends #{@parent}{\n#{props}}"
        
module.exports = ClassDec