#! /usr/bin/rake
#
# Rake file for building binaries, libraries and unit tests. 
# Big Thanks to Pjotr Prins for showing me Rake

require 'rake/clean'

LIBS = [ 'core', 'gui', 'stats', 'windows', 'openGL', 'r' ]
BIN = ['fileloader', 'correlation', 'plang', 'httpreader', 'regression', 'dfltree', 'httpserver', 'dnacode', 'dflopengl' ]
TESTS = [ 'read_csv' ]

CLEAN.include('*.o')
CLEAN.include('*.obj')
CLEAN.include('*.map')
CLEAN.include('*.lib')
CLEAN.include('*.a')
CLEAN.include(BIN)

def windows?
  return RUBY_PLATFORM =~ /(:?mswin|mingw)/
end

def libext
  if windows? then
    return "lib"
  else
    return "a"
  end
end
# ---- Standard Libs ----

file "core" do
  sh "dmd -run cdc.d -lib src/core -ofcore.#{libext}"
end

file "gui" => :core do
#  sh "dmd -run cdc.d -dfl -lib src/gui core.#{libext} -ofgui.#{libext} -Ideps"
end

file "stats" => :core do
  sh "dmd -run cdc.d -lib src/plugins/regression src/core -ofstats.#{libext} -Ideps/"
end

file "windows" => :core do
  sh "dmd -run cdc.d -lib deps/win core.#{libext} -ofwindows.#{libext} -Isrc/"
end

file "openGL" => :core do
  sh "dmd -run cdc.d -lib deps/gl core.#{libext} -ofopenGL.#{libext} -Ideps/ -Isrc/"
end

file "r" => :core do
  sh "dmd -run cdc.d -lib deps/r core.#{libext} -ofr.#{libext} -Ideps/ -Isrc/"
end

# ---- Applications ----

file "fileloader" => :core do
  sh "dmd -run cdc.d src/fileloader.d core.#{libext} -Isrc/"
end

file "correlation" => [ :core, :stats ] do
  sh "dmd -run cdc.d src/correlation.d core.#{libext} stats.#{libext} -Isrc/"
end

file "plang" => :core do
  sh "dmd -run cdc.d src/plang.d core.#{libext} -Isrc/"
end

file "httpreader" do
  sh "dmd -run cdc.d src/httpreader.d core.#{libext} -Isrc/"
end

file "regression" => [ :core, :stats, :r ] do
  sh "dmd -run cdc.d src/regression.d core.#{libext} stats.#{libext} r.#{libext} -Isrc/ -Ideps/ -L-ldl"
end

file "dfltree" => [ :core, :gui ] do
#  sh "dmd -run cdc.d -dfl src/dfltreeexample.d gui.#{libext} core.#{libext} -Isrc/ -L-ldl"
end

file "httpserver" => :core do
  sh "dmd -run cdc.d src/httpserver.d core.#{libext} -Isrc/"
end

file "dnacode" => :core do
  sh "dmd -run cdc.d src/dnacode.d core.#{libext} -Isrc/"
end

file "dflopengl" => LIBS do
#  sh "dmd -run cdc.d -dfl src/dflopengl.d gui.#{libext} openGL.#{libext} windows.#{libext} core.#{libext} -Ideps/ -Isrc/ -L-ldl"
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
  sh "./plang"
  sh "./plang 'Rl(l)' 010"
end
desc "Test DNAcode"
task :test_dnacode => [ :dnacode ] do 
  print "Testing DNA translation\n"
  sh "./dnacode"
  sh "./dnacode AAAATGATTGAGTAGGATGGATTCTATATCTCTACTCATTTTGTCGCTT"
end

desc "Test Fileloader"
task :test_fileloader => [ :fileloader ] do 
  print "Testing fileloader\n"
  sh "./fileloader data/csv/test.csv"
  sh "./fileloader data/csv/test.csv 2mb"
  sh "./fileloader data/csv/test.csv 2mb 1 23"
end

desc "Test Regression"
task :test_regression => [ :regression ] do 
  print "Testing regression\n"
  sh "./regression"
end

desc "Test Correlation"
task :test_correlation => [ :correlation ] do 
  print "Testing correlation\n"
  sh "./correlation"
  sh "./correlation data/csv/test.csv 2mb"
end

desc "Test HTTPreader"
task :test_httpreader => [ 'httpreader' ] do 
  print "Testing httpreader\n"
  sh "./httpreader"
  sh "./httpreader www.dannyarends.nl 80 /" 
end
