leastCommonNumber = (x, y) ->
    if x is 'float' or y is 'float'
        return 'float'
    if x is 'int' or y is 'int'
        return 'int'
    else
        return 'uint'

isNumber = (x) ->
    return ['uint', 'int', 'float'].some((kind) -> kind is x)

# Checks to see if we can coerce the number y into a x
compatableNumbers = (x, y) ->
    heiarchy = ['uint', 'int', 'float']
    return heiarchy.indexOf(x) <= heiarchy.indexOf(y)

module.exports = {
    leastCommonNumber: leastCommonNumber,
    isNumber: isNumber
    compatableNumbers: compatableNumbers
}
