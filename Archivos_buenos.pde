  PImage imagen_buenos;
    
class Buenos extends FBox {
 
    
  Buenos(float _w, float _h)
  {
    super(_w, _h);
  }
  
  void inicializar()
  {
   setPosition(random (10,940), -5);
   setStatic(false);
   setRotatable(false);
   setRestitution(0);
   setGrabbable(false);
   setDamping(0);
   setFriction(0);
    
    
   imagen_buenos= loadImage("carpeta.png");
   imagen_buenos.resize(70,70);
   attachImage(imagen_buenos); 
  }
  
     

}
      
