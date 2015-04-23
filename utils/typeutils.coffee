leastCommonNumber = (x, y) ->
    if x is 'float' or y is 'float'
        return float
    if x is 'int' or y is 'int'
        return int
    else
        return 'uint'

isNumber = (x) ->
    return ['uint', 'int', 'float'].some((kind) -> kind is x)


module.exports = {
    leastCommonNumber: leastCommonNumber,
    isNumber: isNumber
}
