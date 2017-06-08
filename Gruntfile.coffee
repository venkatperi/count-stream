src = [ 'lib/**/*.coffee', 'index.coffee' ]
dist = 'dist'

config = ( grunt ) ->
  tasks :
    coffee :
      options : { sourceMap : false, bare : true, force : true }
      dist : { expand : true, src : src, dest : dist, ext : '.js' }

    clean : { dist : [ dist ] }

    coffeelint :
      app : src
      options :
        'no_trailing_whitespace' :
          level : 'warn'

    watch : { coffee : { tasks : [ 'coffee' ], files : src } }

    copy :
      dist :
        src : 'config.json'
        dest : 'dist/'

    exec :
      readme : { cmd : 'atomdoc-md -o . -n README.md .' }
      mocha : { cmd : 'mocha --require ./coffee-coverage-loader.coffee' }
      istanbul : { cmd : 'istanbul report lcov' }
      open_coverage : { cmd : 'open ./coverage/lcov-report/index.html' }

  register :
    coverage : [ 'exec:istanbul', 'exec:open_coverage' ]
    test : [ 'exec:mocha', 'coverage' ]
    default : [ 'clean:dist', 'coffee:dist', 'copy:dist' ]

doConfig = ( cfg ) -> ( grunt ) ->
  opts = cfg grunt
  pkg = opts.tasks.pkg = grunt.file.readJSON 'package.json'
  grunt.initConfig opts.tasks
  opts.load ?= []
  dev = Object.keys pkg.devDependencies
  deps = (f for f in dev when f.indexOf('grunt-') is 0)
  opts.load = opts.load.concat deps
  grunt.loadNpmTasks t for t in opts.load

  for own name, tasks of opts.register
    grunt.registerTask name, tasks

module.exports = doConfig config
