#! /usr/bin/rake
#
# Rake file for building binaries, libraries and unit tests. 
# Big Thanks to Pjotr Prins for showing me Rake

require 'rake/clean'

LIBS =  ['libraries:core', 
         'libraries:gui', 
         'libraries:game', 
         'libraries:stats',
         'libraries:options',  
         'libraries:win',
         'libraries:x11',  
         'libraries:openGL', 
         'libraries:r', 
         'libraries:gtk' ]
         
BIN =   ['applications:fileloader', 
         'applications:filesplitter', 
         'applications:aligner', 
         'applications:single_map_probes', 
         'applications:correlation', 
         'applications:plang', 
         'applications:httpreader', 
         'applications:regression', 
         'applications:gtktest', 
         'applications:dfltree', 
         'applications:httpserver',
         'applications:gameserver',
         'applications:gameclient',   
         'applications:dnacode', 
         'applications:dflopengl' ]
TESTS = ['tests:plang', 
         'tests:dnacode', 
         'tests:fileloader', 
         'tests:correlation', 
         'tests:httpreader' ]

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

core_files = (Dir.glob("./src/core/*/*.d") + Dir.glob("./src/core/*/*/*.d")).join(' ')
gui_files = (Dir.glob("./src/gui/*.d") + Dir.glob("./src/gui/*/*.d")).join(' ')
game_files = (Dir.glob("./src/game/*.d") + Dir.glob("./src/game/*/*.d")).join(' ')
gtk_files = (Dir.glob("./src/gui/gtk/*.d")).join(' ')
plugin_stats =  (Dir.glob("./src/plugins/regression/*.d")).join(' ')
plugin_opts =  (Dir.glob("./src/plugins/optionsparser/*.d")).join(' ')
deps_win =  (Dir.glob("./deps/win/*.d")).join(' ')
deps_x11 =  (Dir.glob("./deps/X11/*.d")).join(' ')
deps_opengl =  (Dir.glob("./deps/gl/*.d")).join(' ')
deps_r =  (Dir.glob("./deps/r/*.d")).join(' ')
deps_gtk =  (Dir.glob("./deps/gtk/*.d")).join(' ')

directory builddir

def libext
  if windows? then
    return "lib"
  else
    return "a"
  end
end

# ---- Standard Libs ----
namespace :libraries do
  desc "Build all libraries"
  task :all => LIBS
  
  desc "The library with core functionality"
  task "core" do
    sh "dmd -lib #{core_files} -of#{builddir}/core.#{libext}"
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
  
  desc "Bindings for core Win32 DLLs (Builds on Win32 only)"
  task "win" => :core do
    if windows? then
      sh "dmd -lib #{deps_win} #{builddir}/core.#{libext} -of#{builddir}/windows.#{libext} -Isrc/"
    end
  end
  
  desc "Bindings for core X11 (Builds on Non Win32 only)"
  task "x11" => :core do
    if !windows? then
      sh "dmd -lib #{deps_x11} #{builddir}/core.#{libext} -of#{builddir}/x11.#{libext} -Isrc/"
    end
  end
  
  desc "Bindings for openGL"
  task "openGL" => :core do
    sh "dmd -lib #{deps_opengl} #{builddir}/core.#{libext} -of#{builddir}/openGL.#{libext} -Ideps/ -Isrc/"
  end
  
  desc "Bindings for R"
  task "r" => :core do
    sh "dmd -lib #{deps_r} #{builddir}/core.#{libext} -of#{builddir}/r.#{libext} -Ideps/ -Isrc/"
  end
  
  desc "Bindings for GTK"
  task "gtk" => :core do
    sh "dmd -lib #{deps_gtk} #{gtk_files} #{builddir}/core.#{libext} -of#{builddir}/gtk.#{libext} -Ideps/ -Isrc/"
  end
  
  desc "Deprecated DFL testing libary"
  task "gui" => :core do
    if windows? then
      print "Windows DFL GUI\n"
      #sh "dfl -lib #{gui_files} core.#{libext} -ofgui.#{libext} -Ideps -Isrc/"
    end
  end
end
# ---- Applications ----

namespace :applications do
  desc "Build all applications and libraries"
  task :all => LIBS+BIN
  
  desc "Fileloader application"
  task "fileloader" => 'libraries:core' do
    sh "dmd src/fileloader.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -offileloader.#{execext}"
  end

  desc "Large file splitter"
  task "filesplitter" => 'libraries:core' do
    sh "dmd src/filesplitter.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -offileloader.#{execext}"
  end
  
  desc "DNA sequence alignment using blastn"
  task "aligner" => 'libraries:core' do
    sh "dmd src/aligner.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofaligner.#{execext}"
  end
  
  desc "Extract probes mapping to a single genome location"
  task "single_map_probes" => 'libraries:core' do
    sh "dmd src/single_map_probes.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofmap_probes.#{execext}"
  end
  
  desc "Correlation test using the Statistics library"
  task "correlation" => [ 'libraries:core', 'libraries:stats' ] do
    sh "dmd src/correlation.d #{builddir}/core.#{libext} #{builddir}/stats.#{libext} -Isrc/ -od#{builddir} -ofcorrelation.#{execext}"
  end
  
  desc "P'' language interpreter (see: http://en.wikipedia.org/wiki/P'')"
  task "plang" => 'libraries:core' do
    sh "dmd src/plang.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofplang.#{execext}"
  end
  
  desc "Basic HTTP response slurper"
  task "httpreader" => 'libraries:core' do
    sh "dmd src/httpreader.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofhttpreader.#{execext}"
  end
  
  desc "Multiple lineair regression"
  task "regression" => [ 'libraries:core',  'libraries:r' ] do
    sh "dmd src/regression.d #{builddir}/core.#{libext} #{builddir}/stats.#{libext} #{builddir}/r.#{libext} -Isrc/ -Ideps/ -L-ldl -od#{builddir} -ofregression.#{execext}"
  end
  
  desc "Test for the old DFL <-> GTK bindings"
  task "gtktest" => [ 'libraries:core', 'libraries:gtk' ] do
    sh "dmd src/gtktest.d #{builddir}/core.#{libext} #{builddir}/gtk.#{libext} -Isrc/ -Ideps/ -L-ldl -od#{builddir} -ofgtktest.#{execext}"
  end
  
  desc "Directory tree control in Win32 DFL"
  task "dfltree" => [ 'libraries:core', 'libraries:gui' ] do
    if windows? then
      #sh "dfl src/dfltreeexample.d gui.#{libext} core.#{libext} -Isrc/ -L-ldl"
    end
  end
  
  desc "HTPPserver supporting D as CGI"
  task "httpserver" => 'libraries:core' do
    sh "dmd src/httpserver.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofhttpserver.#{execext}"
  end
  
  desc "Server for a multiplayer network mud"
  task "gameserver" => 'libraries:game' do
    sh "dmd src/server.d #{builddir}/core.#{libext}  #{builddir}/game.#{libext} -Isrc/ -od#{builddir} -ofserver.#{execext}"
  end
  
  desc "Client for a multiplayer network mud"
  task "gameclient" => 'libraries:game' do
    sh "dmd src/client.d #{builddir}/core.#{libext}  #{builddir}/game.#{libext} -Isrc/ -od#{builddir} -ofclient.#{execext}"
  end
  
  desc "Scan for proteins in DNA code"
  task "dnacode" => 'libraries:core' do
    sh "dmd src/dnacode.d #{builddir}/core.#{libext} -Isrc/ -od#{builddir} -ofdnacode.#{execext}"
  end
  
  desc "OpenGL control in Win32 DFL"
  task "dflopengl" => LIBS do
    if windows? then
      #sh "dfl src/dflopengl.d gui.#{libext} openGL.#{libext} windows.#{libext} core.#{libext} -Ideps/ -Isrc/ -L-ldl"
    end
  end
end

# ---- Default task ----

desc "Default is to build all applications"
task :default => 'applications:all' do
  print "Build OK\n"
end

desc "Build all game-executables"
task :game => ['applications:gameserver', 'applications:gameclient' ] do
  print "Game OK\n"
end

# ---- Unit tests ----

namespace :tests do
  desc "Run all tests"
  task :all => TESTS do
    print "All tests OK\n"
  end
  
  desc "Test Plang"
  task :plang => [ 'applications:plang' ] do 
    print "Testing p'' language interpreter\n"
    sh "./plang.#{execext}"
    sh "./plang.#{execext} 'Rl(l)' 010"
  end
  desc "Test DNAcode"
  task :dnacode => [ 'applications:dnacode' ] do 
    print "Testing DNA translation\n"
    sh "./dnacode.#{execext}"
    sh "./dnacode.#{execext} AAAATGATTGAGTAGGATGGATTCTATATCTCTACTCATTTTGTCGCTT"
  end
  
  desc "Test Fileloader"
  task :fileloader => [ 'applications:fileloader' ] do 
    print "Testing fileloader\n"
    sh "./fileloader.#{execext}"
    #sh "./fileloader data/csv/test.csv"
    #sh "./fileloader data/csv/test.csv 2mb"
    #sh "./fileloader data/csv/test.csv 2mb 1 23"
  end
  
  desc "Test Regression"
  task :regression => [ 'applications:regression' ] do 
    print "Testing regression\n"
    sh "./regression.#{execext}"
  end
  
  desc "Test Correlation"
  task :correlation => [ 'applications:correlation' ] do 
    print "Testing correlation\n"
    sh "./correlation.#{execext}"
    #sh "./correlation data/csv/test.csv 2mb"
  end
  
  desc "Test HTTPreader"
  task :httpreader => [ 'applications:httpreader' ] do 
    print "Testing httpreader\n"
    sh "./httpreader.#{execext}"
    sh "./httpreader.#{execext} www.dannyarends.nl 80 /" 
  end
end
