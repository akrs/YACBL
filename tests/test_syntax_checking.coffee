chai = require('chai')
expect = chai.expect

parse = require '../parser'
scan = require '../scanner'
error = require '../error'

describe 'Syntax checking', ->
    context 'should not error on valid programs', ->
        it 'should parse hello world', ->
            parse require './test_files/parser/hello_world'
            expect(error.count).to.eql 0
        it 'should parse class declarations', ->
            count = error.count
            parse require './test_files/parser/classes'
            expect(error.count).to.eql count
