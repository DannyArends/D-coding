#! /usr/bin/rake
#
# Rake file for building binaries, libraries and unit tests. 
# Big Thanks to Pjotr Prins for showing me Rake

require 'rake/clean'

BIN =   ['app:fileloader', 'app:filesplitter', 'app:aligner', 'app:actor', 
         'app:single_map_probes', 'app:correlation', 'app:ostest', 'app:plang',
         'app:startJVM', 'app:httpreader', 'app:regression', 'app:httpserver',
         'app:gameserver', 'app:voynich', 'app:dnacode', 'app:testal', 'app:sdl']
TESTS = ['test:plang', 'tests:dnacode', 'test:fileloader', 'test:correlation', 
         'test:httpreader']

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

# ---- Applications ----
namespace :app do
  desc "Build all applications and libraries"
  task :all => BIN

  desc "Caesar subsitution cipher in ASM"
  task "csc" do
    sh "#{compiler} #{comp_args} src/main/csc.d -od#{bd} -ofcsc.#{execext}"
  end

  desc "File load test application"
  task "fileloader" do
    sh "#{compiler} #{comp_args} src/main/fileloader.d #{core_files} #{io_files} -od#{bd} -offileloader.#{execext}"
  end

  desc "Large file splitter"
  task "filesplitter" do
    sh "#{compiler} #{comp_args} src/main/filesplitter.d #{core_files} #{io_files} -od#{bd} -offilesplit.#{execext}"
  end

  desc "DNA sequence alignment using blastn"
  task "aligner" do
    sh "#{compiler} #{comp_args} src/main/aligner.d #{core_files} #{io_files} -od#{bd} -ofaligner.#{execext}"
  end
  
  desc "Actor example from D"
  task "actor" do
    sh "#{compiler} #{comp_args} src/main/actor.d #{core_files} -od#{bd} -ofactor.#{execext}"
  end

  desc "Testing operating system cmdline functionality"
  task "ostest" do
    sh "#{compiler} #{comp_args} src/main/ostest.d #{core_files} #{io_files} -od#{bd} -ofostest.#{execext}"
  end
  
  desc "Extract probes mapping to a single genome location"
  task "single_map_probes" do
    sh "#{compiler} #{comp_args} src/main/single_map_probes.d #{core_files} #{io_files} -od#{bd} -ofmap_probes.#{execext}"
  end
  
  desc "Correlation test using the statistics library"
  task "correlation" do
    sh "#{compiler} #{comp_args} src/main/correlation.d #{core_files} #{libload_files} #{io_files} #{plugin_stats} #{deps_r} -od#{bd} -ofcorrelation.#{execext} #{link_args}"
  end
  
  desc "P'' language interpreter (see: http://en.wikipedia.org/wiki/P'')"
  task "plang" do
    sh "#{compiler} #{comp_args} src/main/plang.d #{core_files} #{inter_files} -od#{bd} -ofplang.#{execext}"
  end

  desc "Example on how to start the JVM"
  task "startJVM" do
    sh "#{compiler} #{comp_args} src/main/startJVM.d #{core_files} #{libload_files} #{deps_jni} -od#{bd} -ofstartJVM.#{execext} #{link_args}"
  end
  
  desc "Basic HTTP response slurper"
  task "httpreader" do
    sh "#{compiler} #{comp_args} src/main/httpreader.d #{core_files} #{web_files} -od#{bd} -ofhttpreader.#{execext}"
  end
  
  desc "Multiple lineair regression"
  task "regression" do
    sh "#{compiler} #{comp_args} src/main/regression.d #{core_files} #{libload_files} #{plugin_stats} #{deps_r} -od#{bd} -ofregression.#{execext} #{link_args}"
  end
  
  desc "HTPPserver supporting D as CGI"
  task "httpserver" do
    sh "#{compiler} #{comp_args} src/main/httpserver.d #{core_files} #{web_files} -od#{bd} -ofhttpserver.#{execext}"
  end
  
  desc "Server for a multiplayer network mud"
  task "gameserver" do
    sh "#{compiler} #{comp_args} src/main/server.d #{core_files} #{libload_files} #{web_files} #{game_files} #{plugin_gui} #{sfx_files} #{deps_sdl} #{deps_opengl} #{deps_openal} -od#{bd} -ofserver.#{execext} #{link_args}"
  end

  desc "Decode the voynich manuscript"
  task "voynich" do
    sh "#{compiler} #{comp_args} src/main/voynich.d #{core_files} -od#{bd} -ofvoynich.#{execext}"
  end
  
  desc "Scan for proteins in DNA code"
  task "dnacode" do
    sh "#{compiler} #{comp_args} src/main/dnacode.d #{core_files} #{genetic_files} -od#{bd} -ofdnacode.#{execext}"
  end

  desc "Test sound via openAL bindings"
  task "testal" do
    sh "#{compiler} #{comp_args} src/main/testal.d #{core_files} #{libload_files} #{deps_openal} -od#{bd} -oftestal.#{execext} #{link_args}"
  end

  desc "GUI application using the DGE graphics engine"
  task "sdl" do
    sh "#{compiler} #{comp_args} src/main/sdlengine.d #{core_files} #{libload_files} #{web_files} #{game_files} #{plugin_gui} #{sfx_files} #{deps_sdl} #{deps_opengl} #{deps_openal} -od#{bd} -ofsdltest.#{execext} #{link_args}"
  end
end

# ---- Default task ----

desc "Default is to build all applications"
task :default => 'app:all' do
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
