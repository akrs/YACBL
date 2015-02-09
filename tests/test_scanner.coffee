expect = require('chai').expect
fs = require 'fs'

scan = require '../scanner'

describe 'scanner', ->
    describe 'Hello world', ->
        hw = []
        scan './sample_code/hello_world.yac', (tokens) -> hw = tokens
        it 'should have length 20', ->
            expect(hw).to.have.length(20)
        it 'should contain main', ->
            expect(hw).to.contain({ kind: 'main', lexeme: 'main', line: 1, col: 1 })
