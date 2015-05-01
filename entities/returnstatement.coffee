class ReturnStatement
    constructor: (@exps) ->
    
    toString: ->
        "#{@exps}"

    java: (context) ->
        rets = ""
        for exp, i in @exps
            rets += "$returns_object._#{i} = #{exp.java()};\n"
        return "#{rets}return $returns_object;"

module.exports = ReturnStatement