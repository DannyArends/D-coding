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
CLEAN.include('*.exe')
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

# ---- Applications Libs ----

file "fileloader" => :Core do
  sh "dmd -run cdc.d src/fileloader.d Core.lib -Isrc/"
end

file "correlation" => [:Core,:RegressionLib] do
  sh "dmd -run cdc.d  src/correlation.d Core.lib Regression.lib -Isrc/"
end

file "plang" => :Core do
  sh "dmd -run cdc.d  src/plang.d Core.lib -Isrc/"
end

file "httpreader" do
  sh "dmd -run cdc.d src/httpreader.d src/core"
end

file "regression" => [:Core, :RegressionLib, :R] do
  sh "dmd -run cdc.d src/regression.d Core.lib Regression.lib R.lib -Isrc/ -Ideps/"
end

file "dfltree" => [:Core, :Gui] do
  sh "dmd -run cdc.d -dfl src/dfltreeexample.d Gui.lib Core.lib -Isrc/"
end

file "httpserver" => :Core do
  sh "dmd -run cdc.d  src/httpserver.d Core.lib -Isrc/"
end

file "dnacode" => :Core do
  sh "dmd -run cdc.d  src/dnacode.d Core.lib -Isrc/"
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

desc "Test #{BIN}"
task :test => ":#{ENV['p']}" do
end

# ---- Utilities ----


# ---- Unit tests

desc "Test fileloader"
task :test_fileloader => [ 'Core', 'fileloader' ] do 
  print "Testing fileloader\n"
  sh "./fileloader cdc.d" 
end

desc "Test httpreader"
task :test_httpreader => [ 'httpreader' ] do 
  print "Testing httpreader\n"
  sh "./httpreader www.dannyarends.nl 80 /" 
end

desc "Test all"
task :test_all => [ :test_fileloader, :test_httpreader ] do
end

