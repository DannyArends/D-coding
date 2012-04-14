#! /usr/bin/rake
#
# Rake file for building binaries, libraries and unit tests. 
# Big Thanks to Pjotr Prins for showing me Rake

require 'rake/clean'

LIBS =  ['lib:libload', 'lib:core', 'lib:game', 'lib:stats', 'lib:options', 'lib:openGL', 
         'lib:openAL', 'lib:r', 'lib:jni', 'lib:gui', 'lib:sdl']
         
BIN =   ['app:fileloader', 'app:filesplitter', 'app:aligner', 'app:actor', 
         'app:single_map_probes', 'app:correlation', 'app:ostest', 'app:plang',
         'app:startJVM', 'app:httpreader', 'app:regression', 'app:httpserver',
         'app:gameserver', 'app:voynich', 'app:dnacode', 'app:testal', 'app:sdl']
TESTS = ['test:plang', 'tests:dnacode', 'test:fileloader', 'test:correlation', 
         'test:httpreader' ]


def windows?; return RUBY_PLATFORM =~ /(:?mswin|mingw)/; end

bd         = "build"    #Name of the build directory
compiler   = "dmd"      #Name of the compiler executable
comp_args  = "-w"       #Arguments passed to compiler
link_args  = ""         #Arguments passed to linker

if ! windows? then; link_args = "-L-ldl"; end
def execext; if windows? then; return "exe"; else; return "bin"; end; end
def libext; if windows? then; return "lib"; else; return "a"; end; end
def libpre; if windows? then; return ""; else; return "lib"; end; end

CLEAN.include("#{bd}*.*")
CLEAN.include("#{bd}")
CLEAN.include("*.#{execext}")
CLEAN.include("*.save")

core_files    = Dir.glob("./src/core/**/*.d").join(' ')
io_files      = Dir.glob("./src/io/**/*.d").join(' ')
inter_files   = Dir.glob("./src/interpreters/*.d").join(' ')
libload_files = Dir.glob("./src/libload/*.d").join(' ')
game_files    = Dir.glob("./src/game/**/*.d").join(' ')
sfx_files     = Dir.glob("./src/sfx/**/*.d").join(' ')
web_files     = Dir.glob("./src/web/**/*.d").join(' ')
genetic_files = Dir.glob("./src/genetics/*.d").join(' ')
plugin_gui    = Dir.glob("./src/gui/**/*.d").join(' ')
plugin_stats  = Dir.glob("./src/plugins/regression/*.d").join(' ')
plugin_opts   = Dir.glob("./src/plugins/optionsparser/*.d").join(' ')
deps_opengl   = Dir.glob("./deps/gl/*.d").join(' ')
deps_openal   = Dir.glob("./deps/openal/*.d").join(' ')
deps_r        = Dir.glob("./deps/r/*.d").join(' ')
deps_jni      = Dir.glob("./deps/jni/*.d").join(' ')
deps_sdl      = Dir.glob("./deps/sdl/*.d").join(' ')

directory bd  #Create the build dir

# ---- Standard Libs ----
namespace :lib do
  desc "Build all libraries"
  task :all => LIBS

  desc "The library with core functionality"
  task "core" do
    sh "#{compiler} -lib #{core_files} -of#{bd}/#{libpre}core.#{libext}"
    if ! windows? then; link_args += " -L-L#{bd} -L-lcore"; end
    comp_args = " -Isrc/"
    comp_args += " #{bd}/#{libpre}core.#{libext}"
  end

  desc "The library with io functionality"
  task "io" => [ "lib:core" ] do
    sh "#{compiler} -lib #{comp_args} #{io_files} -of#{bd}/#{libpre}io.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-lio"; end
    comp_args += " #{bd}/#{libpre}io.#{libext}";
  end
  
  desc "The library with sfx functionality"
  task "sfx" => ["lib:core",'lib:openAL'] do
    sh "#{compiler} -lib #{comp_args} #{sfx_files} -of#{bd}/#{libpre}sfx.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-lsfx"; end
    comp_args += " #{bd}/#{libpre}sfx.#{libext}";
  end
  
  desc "The library providing interpreters"
  task "inter" => ["lib:core"] do
    sh "#{compiler} -lib #{comp_args} #{inter_files} -of#{bd}/#{libpre}interpreters.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-linterpreters"; end
    comp_args += " #{bd}/#{libpre}interpreters.#{libext}";
  end
  
  desc "The library with libload functionality"
  task "libload" => ["lib:core"] do
    sh "#{compiler} -lib #{comp_args} #{libload_files} -of#{bd}/#{libpre}libload.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-llibload"; end
    if ! windows? then; link_args = " -L-ldl"; end
    comp_args += " -Ideps/ #{bd}/#{libpre}libload.#{libext}";
  end
  
  desc "Library with game functionality (A* search)"
  task "game" => ["lib:web"] do
    sh "#{compiler} -lib #{comp_args} #{game_files} -of#{bd}/#{libpre}game.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-lgame"; end
    comp_args += " #{bd}/#{libpre}game.#{libext}";
  end

  desc "Library with http/web functionality"
  task "web" => ["lib:core"] do
    sh "#{compiler} -lib #{comp_args} #{web_files} -of#{bd}/#{libpre}web.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-lweb"; end
    comp_args += " #{bd}/#{libpre}web.#{libext}";
  end
  
  desc "Library with genetics functionality"
  task "genetics" => ["lib:core"] do
    sh "#{compiler} -lib #{comp_args} #{genetic_files} -of#{bd}/#{libpre}genetics.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-lgenetics"; end
    comp_args += " #{bd}/#{libpre}genetics.#{libext}";
  end
  
  desc "Libary with basic statistics functions"
  task "stats" => ["lib:core"] do
    sh "#{compiler} -lib #{comp_args} #{plugin_stats} -of#{bd}/#{libpre}stats.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-lstats"; end
    comp_args += " #{bd}/#{libpre}stats.#{libext}";
  end
  
  desc "Libary with basic option parsing functions"
  task "options" => ["lib:core"] do
    sh "#{compiler} -lib #{comp_args} #{plugin_opts} -of#{bd}/#{libpre}options.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-loptions"; end
    comp_args += " #{bd}/#{libpre}options.#{libext}";
  end

  desc "Bindings for openGL"
  task "openGL" => ["lib:libload"] do
    sh "#{compiler} -lib #{comp_args} #{deps_opengl} -of#{bd}/#{libpre}openGL.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-lopenGL"; end
    comp_args += " #{bd}/#{libpre}openGL.#{libext}";
  end
  
  desc "Bindings for openAL"
  task "openAL" => :libload do
    sh "#{compiler} -lib #{comp_args} #{deps_openal} -of#{bd}/#{libpre}openAL.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-lopenAL"; end
    comp_args += " #{bd}/#{libpre}openAL.#{libext}";
  end
  
  desc "Bindings for R"
  task "r" => :libload do
    sh "#{compiler} -lib #{comp_args} #{deps_r} -of#{bd}/#{libpre}r.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-lr"; end
    comp_args += " #{bd}/#{libpre}r.#{libext}";
  end

  desc "Bindings for JNI"
  task "jni" => :libload do
    sh "#{compiler} -lib #{comp_args} #{deps_jni} -of#{bd}/#{libpre}jni.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-ljni"; end
    comp_args += " #{bd}/#{libpre}jni.#{libext}";
  end
  
  desc "Bindings for SDL"
  task "sdl" => :libload do
    sh "#{compiler} -lib #{comp_args} #{deps_sdl} -of#{bd}/#{libpre}sdl.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-lsdl"; end
    comp_args += " #{bd}/#{libpre}sdl.#{libext}";
  end
  
  desc "SDL GUI libary"
  task "gui" => ["lib:sdl","lib:game","lib:openGL","lib:sfx"]do
    sh "#{compiler} -lib #{comp_args} #{plugin_gui} -of#{bd}/#{libpre}gui.#{libext} #{link_args}"
    if ! windows? then; link_args += " -L-lgui"; end
    comp_args += " #{bd}/#{libpre}gui.#{libext}";
  end
end
# ---- Applications ----

namespace :app do
  desc "Build all applications and libraries"
  task :all => BIN

  desc "Caesar subsitution cipher in ASM"
  task "csc" do
    sh "#{compiler} #{comp_args} src/main/csc.d -od#{bd} -ofcsc.#{execext}"
  end

  desc "File load test application"
  task "fileloader" => [ "lib:io" ] do
    sh "#{compiler} #{comp_args} src/main/fileloader.d -od#{bd} -offileloader.#{execext} #{link_args}"
  end

  desc "Large file splitter"
  task "filesplitter" => [ "lib:io" ] do
    sh "#{compiler} #{comp_args} src/main/filesplitter.d -od#{bd} -offilesplit.#{execext} #{link_args}"
  end

  desc "DNA sequence alignment using blastn"
  task "aligner" => [ "lib:io" ] do
    sh "#{compiler} #{comp_args} src/main/aligner.d -od#{bd} -ofaligner.#{execext} #{link_args}"
  end
  
  desc "Actor example from D"
  task "actor" => [ "lib:core" ]do
    sh "#{compiler} #{comp_args} src/main/actor.d -od#{bd} -ofactor.#{execext} #{link_args}"
  end

  desc "Testing operating system cmdline functionality"
  task "ostest" => [ "lib:io" ] do
    sh "#{compiler} #{comp_args} src/main/ostest.d -od#{bd} -ofostest.#{execext} #{link_args}"
  end
  
  desc "Extract probes mapping to a single genome location"
  task "single_map_probes" => [ "lib:io" ] do
    sh "#{compiler} #{comp_args} src/main/single_map_probes.d -od#{bd} -ofmap_probes.#{execext} #{link_args}"
  end
  
  desc "Correlation test using the statistics library"
  task "correlation" => [ "lib:io", "lib:r","lib:stats" ] do
    sh "#{compiler} #{comp_args} src/main/correlation.d -od#{bd} -ofcorrelation.#{execext} #{link_args}"
  end
  
  desc "P'' language interpreter (see: http://en.wikipedia.org/wiki/P'')"
  task "plang" => [ "lib:inter" ] do
    sh "#{compiler} #{comp_args} src/main/plang.d -od#{bd} -ofplang.#{execext} #{link_args}"
  end

  desc "Example on how to start the JVM"
  task "startJVM" => ["lib:jni"] do
    sh "#{compiler} #{comp_args} src/main/startJVM.d -od#{bd} -ofstartJVM.#{execext} #{link_args}"
  end
  
  desc "Basic HTTP response slurper"
  task "httpreader" => ["lib:web"] do
    sh "#{compiler} #{comp_args} src/main/httpreader.d -od#{bd} -ofhttpreader.#{execext} #{link_args}"
  end
  
  desc "Multiple lineair regression"
  task "regression" => ["lib:libload","lib:stats","lib:r"]do
    sh "#{compiler} #{comp_args} src/main/regression.d -od#{bd} -ofregression.#{execext} #{link_args}"
  end
  
  desc "HTPPserver supporting D as CGI"
  task "httpserver" => ["lib:web"] do
    sh "#{compiler} #{comp_args} src/main/httpserver.d -od#{bd} -ofhttpserver.#{execext} #{link_args}"
  end
  
  desc "Server for a multiplayer network mud"
  task "gameserver" => ["lib:gui"] do
    sh "#{compiler} #{comp_args} src/main/server.d -od#{bd} -ofserver.#{execext} #{link_args}"
  end

  desc "Decode the voynich manuscript"
  task "voynich" => ["lib:core"] do
    sh "#{compiler} #{comp_args} src/main/voynich.d -od#{bd} -ofvoynich.#{execext} #{link_args}"
  end
  
  desc "Scan for proteins in DNA code"
  task "dnacode" => ["lib:genetics"] do
    sh "#{compiler} #{comp_args} src/main/dnacode.d -od#{bd} -ofdnacode.#{execext} #{link_args}"
  end

  desc "Test sound via openAL bindings"
  task "testal" => ["lib:openAL"] do
    sh "#{compiler} #{comp_args} src/main/testal.d -od#{bd} -oftestal.#{execext} #{link_args}"
  end

  desc "GUI application using the DGE graphics engine"
  task "sdl" => ["lib:gui"] do
    sh "#{compiler} #{comp_args} src/main/sdlengine.d -od#{bd} -ofsdltest.#{execext} #{link_args}"
  end
end

# ---- Default task ----

desc "Default is to build all applications"
task :default => ["app:all"] do
  print "Build OK\n"
end

desc "Run the unit tests"
task :unittest do
  sh "#{compiler} -unittest #{comp_args} src/main/empty.d #{core_files} #{libload_files} #{io_files} #{inter_files} #{game_files} #{web_files} #{sfx_files} #{genetic_files} #{plugin_gui} #{deps_sdl} #{deps_opengl} #{deps_openal} -od#{bd} -ofunittest.#{execext} #{link_args}"
end

desc "Build all game-executables"
task :game => ['app:gameserver', 'app:sdl' ] do
  print "Game OK\n"
end

# ---- Unit tests ----

namespace :test do
  desc "Run all tests"
  task :all => TESTS do
    print "All tests OK\n"
  end
  
  desc "Test Plang"
  task :plang => [ 'app:plang' ] do 
    print "Testing p'' language interpreter\n"
    sh "./plang.#{execext}"
    sh "./plang.#{execext} 'Rl(l)' 010"
  end
  desc "Test DNAcode"
  task :dnacode => [ 'app:dnacode' ] do 
    print "Testing DNA translation\n"
    sh "./dnacode.#{execext}"
    sh "./dnacode.#{execext} AAAATGATTGAGTAGGATGGATTCTATATCTCTACTCATTTTGTCGCTT"
  end
  
  desc "Test Fileloader"
  task :fileloader => [ 'app:fileloader' ] do 
    print "Testing fileloader\n"
    sh "./fileloader.#{execext}"
    #sh "./fileloader data/csv/test.csv"
    #sh "./fileloader data/csv/test.csv 2mb"
    #sh "./fileloader data/csv/test.csv 2mb 1 23"
  end
  
  desc "Test Regression"
  task :regression => [ 'app:regression' ] do 
    print "Testing regression\n"
    sh "./regression.#{execext}"
  end
  
  desc "Test Correlation"
  task :correlation => [ 'app:correlation' ] do 
    print "Testing correlation\n"
    sh "./correlation.#{execext}"
    #sh "./correlation data/csv/test.csv 2mb"
  end
  
  desc "Test HTTPreader"
  task :httpreader => [ 'app:httpreader' ] do 
    print "Testing httpreader\n"
    sh "./httpreader.#{execext}"
    sh "./httpreader.#{execext} www.dannyarends.nl 80 /" 
  end
end
