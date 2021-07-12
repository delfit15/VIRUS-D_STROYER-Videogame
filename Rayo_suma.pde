PImage rayos;
 
float x_rayo;


class Rayos extends FBox {
 
    
  Rayos(float _w, float _h)
  {
    super(_w, _h);
  }
  
  void inicializar()
  {
    x_rayo = random (width-5);

   setPosition(x_rayo, -5);
   setStatic(false);
   setRotatable(true);
   setRestitution(0);
   setGrabbable(false);
   setDamping(0);
   setFriction(0);
   setAngularVelocity(20);
    

   rayos= loadImage("rayo.png");
   rayos.resize(50,50);
   attachImage(rayos); 
  }




}
