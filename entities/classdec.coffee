class ClassDec
    constructor: (@nameToken, @parentToken, @properties) ->
        @name = @nameToken.lexeme
        @parent = @parentToken.lexeme
    toString: ->
        "(Class #{@name} parent: #{@parent} Properties #{@properties.join(' ')})"

    generator: {
        java: ->
            props = ""
            
            for property in @properties
                props += properties.generator.java()

            return "class #{@name} extends #{@parent}{\n#{props}}"
            
    }

module.exports = ClassDec