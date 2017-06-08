assert = require 'assert'
count = require '../lib/count_steam'
Streamify = require 'streamify-string'
StreamifyArray = require 'stream-array'

str = 'Grumpy wizards make toxic brew for the evil Queen and Jack.'

describe 'count', ->

  it 'should return length for strings', ( done ) ->
    Streamify( str ).pipe count ( c ) ->
      assert c is str.length
      done( )

  it 'should return count for objects', ( done ) ->
    words = str.split ' '
    StreamifyArray( words ).pipe count.obj ( c ) ->
      assert c is words.length
      done( )



