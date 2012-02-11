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
         'app:gameserver', 'app:voynich', 'app:dnacode', 'app:testal', 'app:sdl',
         'app:sdltest']
TESTS = ['test:plang', 'tests:dnacode', 'test:fileloader', 'test:correlation', 
         'test:httpreader' ]

def builddir;return "build";end

def windows?;return RUBY_PLATFORM =~ /(:?mswin|mingw)/;end

def execext
  if windows? then
    return "exe"
  else
    return "bin"
  end
end
  
CLEAN.include("#{builddir}*.*")
CLEAN.include("#{builddir}")
CLEAN.include("*.#{execext}")

core_files    = Dir.glob("./src/core/**/*.d").join(' ')
libload_files = Dir.glob("./src/libload/*.d").join(' ')
game_files    = Dir.glob("./src/game/**/*.d").join(' ')
plugin_gui    = Dir.glob("./src/gui/**/*.d").join(' ')
plugin_stats  = Dir.glob("./src/plugins/regression/*.d").join(' ')
plugin_opts   = Dir.glob("./src/plugins/optionsparser/*.d").join(' ')
deps_opengl   = Dir.glob("./deps/gl/*.d").join(' ')
deps_openal   = Dir.glob("./deps/openal/*.d").join(' ')
deps_r        = Dir.glob("./deps/r/*.d").join(' ')
deps_jni      = Dir.glob("./deps/jni/*.d").join(' ')
deps_sdl      = Dir.glob("./deps/sdl/*.d").join(' ')

directory builddir

def libext
  if windows? then
    return "lib"
  else
    return "a"
  end
end

# ---- Standard Libs ----
namespace :lib do
  desc "Build all libraries"
  task :all => LIBS
  
  desc "The library with core functionality"
  task "core" do
    sh "dmd -lib #{core_files} -of#{builddir}/core.#{libext}"
  end
  
  desc "The library with libload functionality"
  task "libload" do
    sh "dmd -lib #{libload_files} -of#{builddir}/libload.#{libext}"
  end
  
  desc "Library with game functionality (A* search)"
  task "game" => :core do
    sh "dmd -lib #{game_files} #{builddir}/core.#{libext} -of#{builddir}/game.#{libext} -Isrc/"
  end
  
  desc "Libary with basic statistics functions"
  task "stats" => :core do
    sh "dmd -lib #{plugin_stats} #{builddir}/core.#{libext} -of#{builddir}/stats.#{libext} -Isrc/ -Ideps/"
  end
  
  desc "Libary with basic option parsing functions"
  task "options" => :core do
    sh "dmd -lib #{plugin_opts} #{builddir}/core.#{libext} -of#{builddir}/options.#{libext} -Isrc/ -Ideps/"
  end

  desc "Bindings for openGL"
  task "openGL" => :libload do
    sh "dmd -lib #{deps_opengl} #{builddir}/libload.#{libext} -of#{builddir}/openGL.#{libext} -Ideps/ -Isrc/"
  end
  
  desc "Bindings for openAL"
  task "openAL" => :libload do
    sh "dmd -lib #{deps_openal} #{builddir}/libload.#{libext} -of#{builddir}/openAL.#{libext} -Ideps/ -Isrc/"
  end
  
  desc "Bindings for R"
  task "r" => :libload do
    sh "dmd -lib #{deps_r} #{builddir}/libload.#{libext} -of#{builddir}/r.#{libext} -Ideps/ -Isrc/"
  end

  desc "Bindings for JNI"
  task "jni" => :libload do
    sh "dmd -lib #{deps_jni} #{builddir}/libload.#{libext} -of#{builddir}/jni.#{libext} -Ideps/ -Isrc/"
  end
  
  desc "Bindings for SDL"
  task "sdl" => :libload do
    sh "dmd -lib #{deps_sdl} #{builddir}/libload.#{libext} -of#{builddir}/sdl.#{libext} -Ideps/ -Isrc/"
  end
  
  desc "SDL GUI libary"
  task "gui" => :sdl do
    sh "dmd -lib #{plugin_gui} #{builddir}/sdl.#{libext} -of#{builddir}/gui.#{libext} -Ideps/ -Isrc/"
  end
end
# ---- Applications ----

namespace :app do
  desc "Build all applications and libraries"
  task :all => LIBS+BIN
  
  desc "Fileloader application"
  task "fileloader" => 'lib:core' do
    sh "dmd src/main/fileloader.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -offileloader.#{execext}"
  end

  desc "Large file splitter"
  task "filesplitter" => 'lib:core' do
    sh "dmd src/main/filesplitter.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -offilesplit.#{execext}"
  end

  desc "DNA sequence alignment using blastn"
  task "aligner" => 'lib:core' do
    sh "dmd src/main/aligner.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofaligner.#{execext}"
  end
  
  desc "Actor example from D"
  task "actor" => 'lib:core' do
    sh "dmd src/main/actor.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofactor.#{execext}"
  end

  desc "os test"
  task "ostest" => 'lib:core' do
    sh "dmd src/main/ostest.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofostest.#{execext}"
  end
  
  desc "Extract probes mapping to a single genome location"
  task "single_map_probes" => 'lib:core' do
    sh "dmd src/main/single_map_probes.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofmap_probes.#{execext}"
  end
  
  desc "Correlation test using the Statistics library"
  task "correlation" => [ 'lib:core', 'lib:stats' ] do
    sh "dmd src/main/correlation.d #{builddir}/core.#{libext} #{builddir}/stats.#{libext} -Isrc/ -od#{builddir} -ofcorrelation.#{execext}"
  end
  
  desc "P'' language interpreter (see: http://en.wikipedia.org/wiki/P'')"
  task "plang" => 'lib:core' do
    sh "dmd src/main/plang.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofplang.#{execext}"
  end

  desc "Start the JVM"
  task "startJVM" => 'lib:jni' do
    sh "dmd src/main/startJVM.d #{builddir}/core.#{libext} #{builddir}/jni.#{libext} -Isrc/ -Ideps/ -od#{builddir} -ofstartJVM.#{execext}"
  end
  
  desc "Basic HTTP response slurper"
  task "httpreader" => 'lib:core' do
    sh "dmd src/main/httpreader.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofhttpreader.#{execext}"
  end
  
  desc "Multiple lineair regression"
  task "regression" => [ 'lib:core',  'lib:stats',  'lib:r' ] do
    sh "dmd src/main/regression.d #{builddir}/core.#{libext} #{builddir}/stats.#{libext} #{builddir}/r.#{libext} -Isrc/ -Ideps/ -od#{builddir} -ofregression.#{execext}"
  end
  
  desc "HTPPserver supporting D as CGI"
  task "httpserver" => 'lib:core' do
    sh "dmd src/main/httpserver.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofhttpserver.#{execext}"
  end
  
  desc "Server for a multiplayer network mud"
  task "gameserver" => 'lib:game' do
    sh "dmd src/main/server.d #{builddir}/core.#{libext}  #{builddir}/game.#{libext} -Isrc/ -od#{builddir} -ofserver.#{execext}"
  end

  desc "Decode voynich"
  task "voynich" => 'lib:core' do
    sh "dmd src/main/voynich.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofvoynich.#{execext}"
  end
  
  desc "Scan for proteins in DNA code"
  task "dnacode" => 'lib:core' do
    sh "dmd src/main/dnacode.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofdnacode.#{execext}"
  end

  desc "Test openAL bindings"
  task "testal" => 'lib:openAL' do
    sh "dmd src/main/testal.d #{builddir}/core.#{libext} #{builddir}/openAL.#{libext} -Isrc/ -Ideps/ -od#{builddir} -oftestal.#{execext}"
  end

  desc "SDLconcept engine"
  task "sdl" => ['lib:sdl','lib:openGL','lib:gui','lib:game'] do
    sh "dmd src/main/sdlconcept.d #{builddir}/sdl.#{libext} #{builddir}/gui.#{libext} #{builddir}/openGL.#{libext} #{builddir}/game.#{libext}  -Isrc/ -Ideps/ -od#{builddir} -ofsdltest.#{execext}"
  end
  
  desc "SDL test"
  task "sdltest" => ['lib:sdl','lib:openGL','lib:gui','lib:game'] do
    sh "dmd src/main/sdltest.d #{builddir}/sdl.#{libext} #{builddir}/gui.#{libext} #{builddir}/openGL.#{libext} #{builddir}/game.#{libext}  -Isrc/ -Ideps/ -od#{builddir} -ofsdltest.#{execext}"
  end
end

# ---- Default task ----

desc "Default is to build all applications"
task :default => 'app:all' do
  print "Build OK\n"
end

desc "Build all game-executables"
task :game => ['app:gameserver', 'app:sdltest' ] do
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
