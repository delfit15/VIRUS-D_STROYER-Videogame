float anguloVel = 2;
float diamBala = 10;
float velocidad = 1000;

 Boolean cursorDerecha, cursorIzquierda;
 
 PImage imagen_cursor;
PImage imagen_disparo;
  
 float angulo;
 float x,y;
 
 FCircle bala;
 
 
class Cursor extends FBox
{
    Cursor(float _w, float _h)
  {
    super(_w, _h);
     angulo = radians( -90 );
            
 
     
  }

  void inicializar()
  {
   cursorDerecha=false;
   cursorIzquierda=false;
    x =width/2;
    y=520;
    setSensor(true);
    setPosition(x,y);
   setGrabbable(false);
   setRotatable(false);
   
 imagen_cursor= loadImage("mano.png");
 imagen_cursor.resize(80,80);
 imagen_disparo= loadImage("pistola.png");
 imagen_disparo.resize(80,80);
     
      
     }
     
  
 void actualizar(){
    println(contmano);
    
   if (!disparar){ // imagen mano abierta
   attachImage(imagen_cursor);
   contmano=0;
   
 }   
   
   else if (disparar==true){ //imagen pistola
    contmano++;
    if (contmano<50){  attachImage(imagen_disparo);}
    else {  disparar=false;}
    println(contmano);
   
   }
 
 

 }
 
 
 void disparo (float _xd, float _yd){
     FCircle bala = new FCircle( diamBala );
     x=_xd;
     y=_yd;
     bala.setPosition( x, y );
     bala.setFill( 14,255,3 );
     bala.setStroke( 14,255,3);
     bala. setFriction (3);
     bala.setName( "bala" );
    float vx = velocidad * cos( angulo );
    float vy = velocidad * sin( angulo );
    
    bala.setVelocity( vx , vy );
    mundo.add( bala );
    
    }
  }
   
  
    
  
