class Convert
    constructor: (@varible, @type) ->

    type: () ->
        return @type

    analyse: (context) ->
        switch context[@varible].type()
            when 'int', 'uint', 'float'
                switch @type.toString()
                    when 'String' then return true
                    when 'int', 'uint', 'float' then return true
                    else return false
            when 'String'
                switch @type.toString()
                    when 'int', 'uint', 'float' then return true
                    when 'String' then return true
                    else return false
            else
                return @type?.typeConversions.some((typeTarget) ->
                    return typeTarget.type() is @type.type())
