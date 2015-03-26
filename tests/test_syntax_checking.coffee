chai = require('chai')
expect = chai.expect
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai.use sinonChai

error = require '../error'
sinon.stub(error, 'parserError');

parse = require '../parser'
scan = require '../scanner'

describe 'Syntax checking', ->
    context 'should not error on valid programs', ->
        beforeEach 'reset stub', ->
            error.parserError.reset()
        it 'should parse hello world', ->
            parse require './test_files/parser/hello_world'
            expect(error.parserError).to.not.have.been.called
        it 'should parse class declarations', ->
            parse require './test_files/parser/classes'
            expect(error.parserError).to.not.have.been.called
