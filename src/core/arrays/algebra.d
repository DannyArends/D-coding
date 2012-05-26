/******************************************************************//**
 * \file src/core/arrays/algebra.d
 * \brief Basic array algebra
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.arrays.algebra;

import std.stdio, std.conv, std.string, std.math, std.random;

/*! \brief Get the sum of the values in range r
 * 
 * D-routine to get the sum of the values in range r<br>
 * bugs: none found<br>
 * \param r any type any length vector<br>
 * \return The sum
 */
pure T sum(T)(in T[] r){
  T s = 0;
  foreach(T e; r){ s += e; }
  return s;
}

/*! \brief Get the mean of the values in range r
 * 
 * D-routine to get the mean of the values in range r<br>
 * bugs: none found<br>
 * \param r any type any length vector<br>
 * \return The mean
 */
pure T mean(T)(in T[] r){
  T mean = 0;
  for(size_t i = 0; i < r.length; i++){
    mean += (data[i] - mean) / (i + 1);
  }
  return mean;
}

/*! \brief Get the min or max value of the values in range r
 *
 * D-routine to get the min or max value of the values in range<br>
 * bugs: none found<br>
 * \param r any type any length vector<br>
 * \return The min or max based on op
 */
pure T minmax(string op, T)(in T[] r){
  assert(r.length >= 1);
  T best = r[0];
  foreach(e; r){
    mixin("if (e " ~ op ~ " best) best = e;");
  }
  return best;
}

/*! \brief Get the max value of the values in range r
 *
 * D-routine to get the max value of the values in range<br>
 * bugs: none found<br>
 * \param r any type any length vector<br>
 * \return The max
 */
pure T max(T)(in T[] r){ return minmax!(">",T)(r); }

/*! \brief Get the min value of the values in range r
 *
 * D-routine to get the min value of the values in range<br>
 * bugs: none found<br>
 * \param r any type any length vector<br>
 * \return The min
 */
pure T min(T)(in T[] r){ return minmax!("<",T)(r); }

/*! \brief Get the max value of range r inside d
 *
 * D-routine to get the max value of range r inside d<br>
 * bugs: none found<br>
 * \param d any type any length vector<br>
 * \param r the number of items in d to sum<br>
 * \return The maxOf
 */
pure T maxOf(T)(in T[] d, in size_t r){
  assert(d.length >= 1);
  T m = d[0];
  for(size_t x=0;x < (d.length-r); x++){ 
    T e = sum!T(d[x..x+r]);
    if(m < e){ m = e; }
  }
  return m;
}

T[] applyRandomness(T)(in T[] d1, in int[] rnd){
  T[] r;
  r.length = d1.length;
  for(size_t x=0; x < d1.length;x++){
    if(rnd[x] != 0){
      r[x] = d1[x] + to!T(uniform(-rnd[x],rnd[x])/100.0);
    }else{
      r[x] = d1[x];
    }
  }
  return r;
}

/*! \brief Substract vector d2 from d1
 *
 * D-routine to substract vector d2 from d1<br>
 * bugs: none found<br>
 * \param d1 any type any length vector<br>
 * \param d2 any type any length vector<br>
 * \return The vector d1 - d2
 */
pure T[] subtract(T)(in T[] d1, in T[] d2){
  return add(d1,multiply(d2,-1.0));
}

/*! \brief Add vector d2 to d1
 *
 * D-routine to add vector d2 to d1<br>
 * bugs: none found<br>
 * \param d1 any type any length vector<br>
 * \param d2 any type any length vector<br>
 * \return The vector d1 + d2
 */
pure T[] add(T)(in T[] d1, in T[] d2){
  assert(d1.length == d2.length, "Error: Should have same length");
  T[] sum;
  sum.length = d1.length;
  for(size_t x=0;x<d1.length;x++){ sum[x] = d1[x] + d2[x]; }
  return sum;
}

/*! \brief Multiply a vector with a constant
 *
 * D-routine to multiply a vector with a constant<br>
 * bugs: none found<br>
 * \param d1 any type any length vector<br>
 * \param alpha parameter holding the multiplication factor<br>
 * \return The vector d1 * alpha
 */
pure T[] multiply(T)(in T[] d1, in float alpha = 1.0){
  T[] factor;
  factor.length = d1.length;
  for(size_t x=0; x < d1.length; x++){ factor[x] = d1[x] * alpha; }
  return factor;
}

/*! \brief Multiply a vector with a constant and add it to another vector
 *
 * D-routine to multiply a vector with a constant and add it to another vector<br>
 * bugs: none found<br>
 * \param d1 any type any length vector<br>
 * \param d2 any type any length vector<br>
 * \param alpha parameter holding the multiplication factor<br>
 * \return The vector d1 + ( d2 * alpha )
 */
pure T[] addnmultiply(T)(in T[] d1, in T[] d2, in float alpha = 1.0){
  return add(d1, multiply(d2,alpha));
}

/*! \brief Magnitude of a vector
 *
 * D-routine to get the magnitude of a vector<br>
 * bugs: none found<br>
 * \param d1 any type any length vector<br>
 * \return Magnitude of d1
 */
pure float magnitude(T)(in T[] d1){
  float f = 0.0;
  for(size_t x=0; x < d1.length; x++){ f += (d1[x] * d1[x]); }
  return sqrt(f);
}

/*! \brief Normalize a vector
 *
 * D-routine to normalize a vector<br>
 * bugs: none found<br>
 * \param d1 any type any length vector<br>
 * \return normalized d1
 */
pure T[] normalize(T)(in T[] d1){
  T[] normal;
  normal.length = d1.length;
  
  float len = magnitude!T(d1);
  if(len == 0.0f) len = 1.0f;

  // reduce to unit size
  for(size_t x=0; x < d1.length; x++){ normal ~= d1[x] / len; }
  return normal;
}

/*! \brief Get the (normalized) normal for a triangle
 *
 * D-routine that finds a normalized normal vector for a triangle<br>
 * bugs: none found<br>
 * \param v any type 3x3 holding the three points of the triangle<br>
 * \return normalized normal of v
 */
pure T[] trianglefindnormal(T)(in T[3][3] v){
  T[3] a;
  T[3] b;
  T[3] normal;
  
  a[0] = v[0][0] - v[1][0];
  a[1] = v[0][1] - v[1][1];
  a[2] = v[0][2] - v[1][2];

  b[0] = v[1][0] - v[2][0];
  b[1] = v[1][1] - v[2][1];
  b[2] = v[1][2] - v[2][2];

  // calculate the cross product and place the resulting vector
  normal[0] = (a[1] * b[2]) - (a[2] * b[1]);
  normal[1] = (a[2] * b[0]) - (a[0] * b[2]);
  normal[2] = (a[0] * b[1]) - (a[1] * b[0]);

  // normalize the normal
  return normalize(normal);
}

unittest{
  writeln("Unit test: ",__FILE__);
  try{
    double[] a = [1,2,3];
    double[] b = [2,2,1];
    assert(multiply!double(a,2) == [2,4,6]);
    assert(add!double(a,b) == [3,4,4]);
    assert(addnmultiply!double(a,b,3) == [7,8,6]);
    writeln("OK: ",__FILE__);  
  }catch(Throwable e){
    string err = to!string(e).split("\n")[0];
    writefln(" - %s\nFAILED: %s",err,__FILE__);  
  }
}
