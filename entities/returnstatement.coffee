class ReturnStatement
    constructor: (@exps) ->
    
    toString: ->
        "#{@exps}"

    java: () ->
        rets = ""
        for exp, i in @exps
            rets += "_return_object._#{i} = #{@exp.java()};\n"
        return "return _return_object;"

module.exports = ReturnStatement