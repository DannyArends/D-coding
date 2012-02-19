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
  
    void buffer(){ }
    void update(){ }
    void render(int faceType = GL_TRIANGLES){  }
    int getFaceType(){ return GL_TRIANGLES; }
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
  
  void buffer(){ }
  
  void update(){
    for(auto p = 0; p < particles.length; p++){
      foreach(Force force; forces){
        force.act(this, particles[p]);
      }
      particles[p].update();
    }
  }
  
  void render(int faceType = GL_TRIANGLES){
    for(auto x = 0; x < particles.length;x++){
      particles[x].render(particles[x].getFaceType());
    }
  }
  
  int getFaceType(){ return GL_TRIANGLES; }
  private:
    Object3D[]  particles;
    Force[]     forces;
}