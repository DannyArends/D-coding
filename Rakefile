#! /usr/bin/rake
#
# Rake file for building binaries, libraries and unit tests. 
# Big Thanks to Pjotr Prins for showing me Rake

require 'rake/clean'

LIBS = [ 'Core', 'Gui', 'RegressionLib', 'Windows', 'OpenGL', 'R' ]
BIN = ['fileloader', 'correlation', 'plang', 'httpreader', 'regression', 'dfltree', 'httpserver', 'dnacode', 'dflopengl' ]
TESTS = [ 'read_csv' ]

CLEAN.include('*.o')
CLEAN.include('*.obj')
CLEAN.include('*.map')
CLEAN.include('*.lib')

# ---- Standard Libs ----

file "Core" do
  sh "dmd -run cdc.d -lib src/core -ofCore.lib"
end

file "Gui" => :Core do
  sh "dmd -run cdc.d -dfl -lib src/gui src/core -ofGui.lib -Ideps"
end

file "RegressionLib" => :Core do
  sh "dmd -run cdc.d -lib src/plugins/regression src/core -ofRegression.lib -Ideps/"
end

file "Windows" => :Core do
  sh "dmd -run cdc.d -lib deps/win Core.lib -ofWindows.lib -Isrc/"
end

file "OpenGL" => :Core do
  sh "dmd -run cdc.d -lib deps/gl Core.lib -ofOpenGL.lib -Ideps/ -Isrc/"
end

file "R" => :Core do
  sh "dmd -run cdc.d -lib deps/R Core.lib -ofR.lib -Ideps/ -Isrc/"
end

# ---- Applications ----

file "fileloader" => :Core do
  sh "dmd -run cdc.d src/fileloader.d Core.lib -Isrc/"
end

file "correlation" => [ :Core, :RegressionLib ] do
  sh "dmd -run cdc.d src/correlation.d Core.lib Regression.lib -Isrc/"
end

file "plang" => :Core do
  sh "dmd -run cdc.d src/plang.d Core.lib -Isrc/"
end

file "httpreader" do
  sh "dmd -run cdc.d src/httpreader.d src/core"
end

file "regression" => [ :Core, :RegressionLib, :R ] do
  sh "dmd -run cdc.d src/regression.d Core.lib Regression.lib R.lib -Isrc/ -Ideps/"
end

file "dfltree" => [ :Core, :Gui ] do
  sh "dmd -run cdc.d -dfl src/dfltreeexample.d Gui.lib Core.lib -Isrc/"
end

file "httpserver" => :Core do
  sh "dmd -run cdc.d src/httpserver.d Core.lib -Isrc/"
end

file "dnacode" => :Core do
  sh "dmd -run cdc.d src/dnacode.d Core.lib -Isrc/"
end

file "dflopengl" => LIBS do
  sh "dmd -run cdc.d -dfl src/dflopengl.d Gui.lib OpenGL.lib Windows.lib Core.lib -Ideps/ -Isrc/"
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
  sh "./plang Rl(l) 010"
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
