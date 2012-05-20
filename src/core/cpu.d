/******************************************************************//**
 * \file src/core/cpu.d
 * \brief CPUinfo structure definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Apr, 2012<br>
 * First written Apr, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.cpu;

import std.stdio;
import std.parallelism : totalCPUs;
import core.cpuid : threadsPerCPU;

/*! \brief The CPUinfo structure
 *
 *  Structure holding information about the CPU
 */
struct CPUinfo{
    /*! Number of CPUs */
  @property int CPUs(){ return totalCPUs; }
    /*! Number of threads per CPU */
  @property int CPUthreads(){ return threadsPerCPU; }  
}

//  CPUinfo info;
//  writeln("CPUs: ", info.CPUs, "-", info.CPUthreads);