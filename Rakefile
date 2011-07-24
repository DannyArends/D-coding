#! /usr/bin/rake
#
# Rake file for building binaries, libraries and unit tests. 
# Big Thanks to Pjotr Prins for showing me Rake

require 'rake/clean'

LIBS = [ 'core', 'guiLib', 'gameLib', 'stats', 'windows', 'openGL', 'rLib', 'gtkLib' ]
BIN = ['fileloader', 'filesplitter', 'aligner', 'single_map_probes', 'correlation', 'plang', 'httpreader', 'regression', 'gtktest', 'dfltree', 'httpserver', 'dnacode', 'dflopengl' ]
TESTS = [ 'read_csv' ]

def builddir;return "build/";end

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
deps_win =  (Dir.glob("./deps/win/*.d")).join(' ')
deps_opengl =  (Dir.glob("./deps/gl/*.d")).join(' ')
deps_r =  (Dir.glob("./deps/r/*.d")).join(' ')
deps_gtk =  (Dir.glob("./deps/gtk/*.d")).join(' ')

sh "mkdir -p build"

def libext
  if windows? then
    return "lib"
  else
    return "a"
  end
end

# ---- Standard Libs ----

file "core" do
  sh "dmd -lib #{core_files} -of#{builddir}core.#{libext}"
end

file "gameLib" do
  sh "dmd -lib #{game_files} #{builddir}core.#{libext} -of#{builddir}game.#{libext} -Isrc/"
end

file "stats" => :core do
  sh "dmd -lib #{plugin_stats} #{builddir}core.#{libext} -of#{builddir}stats.#{libext} -Isrc/ -Ideps/"
end

file "windows" => :core do
  sh "dmd -lib #{deps_win} #{builddir}core.#{libext} -of#{builddir}windows.#{libext} -Isrc/"
end

file "openGL" => :core do
  sh "dmd -lib #{deps_opengl} #{builddir}core.#{libext} -of#{builddir}openGL.#{libext} -Ideps/ -Isrc/"
end

file "rLib" => :core do
  sh "dmd -lib #{deps_r} #{builddir}core.#{libext} -of#{builddir}r.#{libext} -Ideps/ -Isrc/"
end

file "gtkLib" => :core do
  sh "dmd -lib #{deps_gtk} #{gtk_files} #{builddir}core.#{libext} -of#{builddir}gtk.#{libext} -Ideps/ -Isrc/"
end

file "guiLib" => :core do
  if windows? then
    print "Windows DFL GUI\n"
    #sh "dfl -lib #{gui_files} core.#{libext} -ofgui.#{libext} -Ideps -Isrc/"
  end
end

# ---- Applications ----

file "fileloader" => :core do
  sh "dmd src/fileloader.d #{builddir}core.#{libext} -Isrc/ -od#{builddir} -offileloader.#{execext}"
end

file "filesplitter" => :core do
  sh "dmd src/filesplitter.d #{builddir}core.#{libext} -Isrc/ -od#{builddir} -offileloader.#{execext}"
end

file "aligner" => :core do
  sh "dmd src/aligner.d #{builddir}core.#{libext} -Isrc/ -od#{builddir} -ofaligner.#{execext}"
end

file "single_map_probes" => :core do
  sh "dmd src/single_map_probes.d #{builddir}core.#{libext} -Isrc/ -od#{builddir} -ofmap_probes.#{execext}"
end

file "correlation" => [ :core, :stats ] do
  sh "dmd src/correlation.d #{builddir}core.#{libext} #{builddir}stats.#{libext} -Isrc/ -od#{builddir} -ofcorrelation.#{execext}"
end

file "plang" => :core do
  sh "dmd src/plang.d #{builddir}core.#{libext} -Isrc/ -od#{builddir} -ofplang.#{execext}"
end

file "httpreader" do
  sh "dmd src/httpreader.d #{builddir}core.#{libext} -Isrc/ -od#{builddir} -ofhttpreader.#{execext}"
end

file "regression" => [ :rLib ] do
  sh "dmd src/regression.d #{builddir}core.#{libext} #{builddir}stats.#{libext} #{builddir}r.#{libext} -Isrc/ -Ideps/ -L-ldl -od#{builddir} -ofregression.#{execext}"
end

file "gtktest" => [ :gtkLib ] do
  sh "dmd src/gtktest.d #{builddir}core.#{libext} #{builddir}gtk.#{libext} -Isrc/ -Ideps/ -L-ldl -od#{builddir} -ofgtktest.#{execext}"
end

file "dfltree" => [ :guiLib ] do
  if windows? then
    #sh "dfl src/dfltreeexample.d gui.#{libext} core.#{libext} -Isrc/ -L-ldl"
  end
end

file "httpserver" => :core do
  sh "dmd src/httpserver.d #{builddir}core.#{libext} -Isrc/ -od#{builddir} -ofhttpserver.#{execext}"
end

file "dnacode" => :core do
  sh "dmd src/dnacode.d #{builddir}core.#{libext} -Isrc/ -od#{builddir} -ofdnacode.#{execext}"
end

file "dflopengl" => LIBS do
  if windows? then
    #sh "dfl src/dflopengl.d gui.#{libext} openGL.#{libext} windows.#{libext} core.#{libext} -Ideps/ -Isrc/ -L-ldl"
  end
end

# ---- Standard tasks ----

desc "Default builds and tests #{BIN}"
task :default => [:build, :test]

desc "Build default libraries"
task :libs => LIBS

desc "Build default binaries"
task :build => LIBS+BIN

desc "Build and run use rake run -p #{BIN}"
task :run => "#{ENV['p']}" do
  print "Running #{ENV['p']}\n"
  sh "./#{ENV['p']}" 
end

desc "Test single application use: rake test_single -p #{BIN}"
task :test_single => "test_#{ENV['p']}" do
  print "Test OK\n"
end

desc "Test all"
task :test => [ :test_plang, :test_dnacode, :test_fileloader, :test_correlation, :test_httpreader ] do
  print "All tests OK\n"
end

# ---- Unit tests ----

desc "Test Plang"
task :test_plang => [ :plang ] do 
  print "Testing p'' language interpreter\n"
  sh "./plang.#{execext}"
  sh "./plang.#{execext} 'Rl(l)' 010"
end
desc "Test DNAcode"
task :test_dnacode => [ :dnacode ] do 
  print "Testing DNA translation\n"
  sh "./dnacode.#{execext}"
  sh "./dnacode.#{execext} AAAATGATTGAGTAGGATGGATTCTATATCTCTACTCATTTTGTCGCTT"
end

desc "Test Fileloader"
task :test_fileloader => [ :fileloader ] do 
  print "Testing fileloader\n"
  sh "./fileloader.#{execext}"
  #sh "./fileloader data/csv/test.csv"
  #sh "./fileloader data/csv/test.csv 2mb"
  #sh "./fileloader data/csv/test.csv 2mb 1 23"
end

desc "Test Regression"
task :test_regression => [ :regression ] do 
  print "Testing regression\n"
  sh "./regression.#{execext}"
end

desc "Test Correlation"
task :test_correlation => [ :correlation ] do 
  print "Testing correlation\n"
  sh "./correlation.#{execext}"
  #sh "./correlation data/csv/test.csv 2mb"
end

desc "Test HTTPreader"
task :test_httpreader => [ 'httpreader' ] do 
  print "Testing httpreader\n"
  sh "./httpreader.#{execext}"
  sh "./httpreader.#{execext} www.dannyarends.nl 80 /" 
end


