
int frameBajada1;
int frameBajada;


class Malos extends FBox {
  
  color red= color (255,0,0);
  Malos(float _w, float _h)
  {
    super(_w, _h);
  }
  
  void inicializar()
  {
   xmalo=random (10,940);
   ymalo= -5;
   setPosition(xmalo, ymalo);
   setFillColor(red);
   setStatic(false);
   setRotatable(false);
   setRestitution(1.0);
   setGrabbable(false);
   setDamping(0);
   setFriction(0);
   // setVelocity(getVelocityX(), getVelocityY()-100);
   
   imagen_malos = new PImage[4];
     imagen_maloszig = new PImage[4];
   
    for (int i = 0; i < 4; i++)
    {
      imagen_malos[i] = loadImage("malo_"+i+".png"); 
      imagen_malos[i].resize(70,70); 
    }
    
     for (int i = 0; i < 4; i++)
    {
      imagen_maloszig[i] = loadImage("malozig_"+i+".png"); 
      imagen_maloszig[i].resize(70,70); 
    }
    

      
 attachImage(imagen_malos[0]);
       
  }
   

void actualizar(){
  
if (frameCount % 6==0){
 
 frameBajada= (frameBajada )% 4;
  
 attachImage(imagen_malos[frameBajada]);
}  
  }
  
  
  
void actualizarzig(){
  
if (frameCount % 6==0){
 
 frameBajada= (frameBajada + 1)% 4;
  
 attachImage(imagen_maloszig[frameBajada]);
}  
  }
  
    
    
    
    
  }
