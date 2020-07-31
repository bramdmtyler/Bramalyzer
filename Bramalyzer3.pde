import processing.serial.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
ParticleSystem ps;
PImage Spacegalaxy2;
PImage sprite;
PImage sprite2;
PImage B;
class Particle {

  PVector velocity;
  float lifespan = 1000;
  
  PShape part;
  float partSize;
 
  PVector gravity = new PVector(random(-0.01,0.01),random(-0.01,0.01));

  Particle() {
    partSize = random(25,50);
    part = createShape();
    part.beginShape(QUAD);
    part.noStroke();
    part.texture(sprite);
    part.normal(0, 0, 1);
    part.vertex(-partSize/2, -partSize/2, 0, 0);
    part.vertex(+partSize/2, -partSize/2, sprite.width, 0);
    part.vertex(+partSize/2, +partSize/2, sprite.width, sprite.height);
    part.vertex(-partSize/2, +partSize/2, 0, sprite.height);
    part.endShape();
    
    rebirth(width/2,height/2);
    lifespan = random(100,1000);
  }

  PShape getShape() {
    return part;
  }
  
  void rebirth(float x, float y) {
    float a = random(TWO_PI);
    float speed = random(0.1,0.5);
    velocity = new PVector(cos(a), sin(a));
    velocity.mult(speed);
    lifespan = 1000;   
    part.resetMatrix();
    part.translate(x, y); 
  }
  
  boolean isDead() {
    if (lifespan < 0) {
     return true;
    } else {
     return false;
    } 
  }
  

  public void update() {
    lifespan = lifespan - 1;
    velocity.add(gravity);
    colorMode(RGB);
    //part.setTint(color(255,random(200,255)));
    part.translate(velocity.x, velocity.y);
  }
}
class ParticleSystem {
  ArrayList<Particle> particles;

  PShape particleShape;

  ParticleSystem(int n) {
    particles = new ArrayList<Particle>();
    particleShape = createShape(PShape.GROUP);

    for (int i = 0; i < n; i++) {
      Particle p = new Particle();
      particles.add(p);
      particleShape.addChild(p.getShape());
    }
  }

  void update() {
    for (Particle p : particles) {
      p.update();
    }
  }

  void setEmitter(float x, float y) {
    for (Particle p : particles) {
      if (p.isDead()) {
        p.rebirth(x, y);
      }
    }
  }

  void display() {

    shape(particleShape);
  }
}
Minim       minim;
AudioPlayer song;
AudioPlayer groove;
FFT         fft;
PShader monjori;
PImage img;
int smallPoint, largePoint;
int concentration;
//SETUPSETUPSETUPSUETSUEPTSUETPSSETUPSETUPSUETPUSETUPSEUTPSUEPTUSEUTPSETUPSETUPSETUPSETUPSETUPSETUP
void setup()
{

  Spacegalaxy2 = loadImage("nature.jpg");
  Spacegalaxy2.resize(width, height);
  img = loadImage("stroke.png");
  B = loadImage("B.png");
  smallPoint = 4;
  largePoint = 40;
  imageMode(CENTER);
  fullScreen(P3D);
  //surface.setResizable(true);
  //monjori = loadShader("monjori.glsl");
  //monjori.set("resolution", float(width), float(height));   
  minim = new Minim(this);
  song = minim.loadFile("Song(fantasy).mp3", 1024);
  song.loop();
  song.pause();
  fft = new FFT( song.bufferSize(), song.sampleRate() );
  colorMode(HSB, height, height, height);
  sprite = loadImage("sprite.png");
  ps = new ParticleSystem(1000);
 
  // Writing to the depth buffer is disabled to avoid rendering
  // artifacts due to the fact that the particles are semi-transparent
  // but not z-sorted.
  hint(DISABLE_DEPTH_MASK);
  sphereDetail(60);
}
//DRAW DRAW DRAW DRAW DRAW DRAW DRAW DRAW DRAW DRAW DRAW DRAW DRAW DRAW DRAW DRAW
void draw()
{
  image(Spacegalaxy2,width/2,height/2);
    ps.update();
  ps.display();
  ps.setEmitter(width/2, height/2);
  fft.forward( song.mix );
  for(int i = 0; i < fft.specSize(); i++)
  {
    int x = int(random(img.width));
    int y = int(random(img.height));
    color pix = img.get(x, y);
    //fill(pix, 128);
    strokeWeight(1);
    //noStroke();
    float bandDB = 20 * log( 2 * fft.getBand(i) / fft.timeSize() );
    float bandHeight = map( bandDB, 0, -150, 0, height );
    rect(i*8, bandHeight+200, 8, height);
    if (bandDB > -50)
    {
      ps.update();
      image(B,width/2,height/2, 260, 260);
      image(B,width/2,height/2, 270, 270);
      image(B,width/2,height/2, 275, 275);
      image(B,width/2,height/2, 290, 290);
      image(B,width/2,height/2, 300, 300);
    }
  }
    stroke(255);
    strokeWeight(3);
    for(int u = 0; u < width/2; u++)
  {
    float x1 = map( u, 0, width/2, 0, width/2 - 2*height/8 + width*(0.066875) - 7 - song.left.get(u)*50);
    float x2 = map( u+1, 0, width/2, 0, width/2 - 2*height/8 + width*(0.066875) - 7 - song.left.get(u+1)*50);
    float x3 = map( u, 0, width/2, width/2 + 2*height/8 - width*(0.066875) + 7 + song.left.get(u)*50, width);
    float x4 = map( u+1, 0, width/2, width/2 + 2*height/8 - width*(0.066875) + 7 + song.left.get(u+1)*50, width);
    //float x1 = random(0,width/2 - 2*height/8 + 100 + song.left.get(1)*50);
    //float x2 = x1 + 1;
    //float x3 = random(width/2 + 2*height/8 - 100 - song.left.get(1)*50,width);
    //float x4 = x3 + 1;
    //println(x1,x2,x3,x4);
    line( x1, 3*height/8 + song.left.get(u)*50, x2, 3*height/8 + song.left.get(u+1)*50);
    line( x1, 5*height/8 - song.left.get(u)*50, x2, 5*height/8 - song.left.get(u+1)*50);
    line( x3, 3*height/8 + song.left.get(u)*50, x4, 3*height/8 + song.left.get(u+1)*50);
    line( x3, 5*height/8 - song.left.get(u)*50, x4, 5*height/8 - song.left.get(u+1)*50);
    //ellipse(800, 450,3*height/8 + song.left.get(u+1)*50 , 3*height/8 + song.right.get(u+1)*50 );
    
  }
    fill(1000,1000,1000,100);
    ellipse(width/2,height/2, 2*height/8 + width*(0.066875) + song.left.get(1)*50, 2*height/8 + width*(0.066875) + song.right.get(1)*50);
    image(B,width/2,height/2, 280, 280);
}

void keyPressed()
{
  if ( song.isPlaying() )
  {
    song.pause();
  }

  else
  {
    // simply call loop again to resume playing from where it was paused
    song.loop();
  }
}
