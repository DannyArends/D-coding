/******************************************************************//**
 * \file src/gui/objects/pe.d
 * \brief ParticleSystem and emitter definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.objects.pe;

import std.array;
import std.stdio;
import std.random;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;

import core.typedefs.color;

import gui.objects.object3d;
import gui.physics;
import gui.objects.triangle;
import gui.objects.force;

class ParticleSystem : Object3D{
  public:
    this(double x, double y, double z){ super(x,y,z); }
  
    override void buffer(){ }
    override void update(){ }
    override void render(int faceType = GL_TRIANGLES){  }
    override int getFaceType(){ return GL_TRIANGLES; }
  private:
    Physics  physics;
    PE[]     emitters;
}

class PE : Object3D{
public:
  this(double x, double y, double z){ 
    this(x,y,z, 200,new Fountain()); 
  }
  
  this(double x, double y, double z, int np, Force force){ 
    super(x,y,z);
    this.forces ~= force;
    for(auto p = 0; p < np; p++){
      Triangle t = new Triangle(x,y,z,this);
      t.setLife(uniform(50,100));
      t.setColor(new Color());
      particles ~= t;
    }
  }
  
  void addForce(Force f){
    this.forces ~= f;
  }
  
  override void buffer(){ }
  
  override void update(){
    for(auto p = 0; p < particles.length; p++){
      foreach(Force force; forces){
        force.act(this, particles[p]);
      }
      particles[p].update();
    }
  }
  
  override void render(int faceType = GL_TRIANGLES){
    for(auto x = 0; x < particles.length;x++){
      particles[x].render(particles[x].getFaceType());
    }
  }
  
  override int getFaceType(){ return GL_TRIANGLES; }
  private:
    Object3D[]  particles;
    Force[]     forces;
}
