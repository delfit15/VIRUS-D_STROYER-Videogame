
// fijarse umbral si no capta bien

import processing.video.*;
import gab.opencv.*;
import fisica.*;
import ddf.minim.*;

//SONIDOS
Minim minim;
AudioPlayer cancionjuego;
AudioPlayer cancionmenu;
AudioPlayer cancionperder;
AudioPlayer cancionganar;

AudioPlayer sonidodisparo;
AudioPlayer sonidodestroy;
AudioPlayer sonidorayo;
AudioPlayer sonidocolision;


Capture camara; //declaro camara web 
OpenCV opencv; //declaracion de OpenCV

//declaro un ArrayList de objetos contorno
ArrayList<Contour> contornos;
Contour ContornoUno;

// objetos fisica
FWorld mundo;
Cursor cursor;
Malos malos;
Malos maloszig;
Buenos buenos;
Rayos rayo;


FMouseJoint sensor;

// imagenes diseño
PImage fondo;
PImage imagenMenu;
PImage instruc;
PImage perdiste;
PImage ganaste;
PImage [] imagen_malos; 
PImage [] imagen_maloszig; 

float xzag ;
float yzag;
float xmalo;
float ymalo;

int xrect=770;
int mov_xrect=100;

boolean izq =false;
boolean der =true;
boolean disparar=false;

 int contmano=0; // contador de cambio de imagen cursor

int contadorarchivos=0; // contador de archivos eliminados  

int cantbalas; // cantidad de balas

//camara
PImage imagencamara;

//substraccion de video
 PImage substraccion;
 
PImage vida;
int maxvida = 100;
float bateria = 100;
int barraBateriaAncho = 71;
boolean sumar=false;

String estado;

Rectangle [] r;
int umbral;
int blobCount = 0;


void setup()
{
estado = "menu";   
imagenMenu = loadImage("menu.jpg");
instruc= loadImage ("instrucciones.jpg");
vida= loadImage ("bateria.png");
vida.resize(100,100);


perdiste= loadImage ("perder.jpg");
ganaste= loadImage ("ganar.jpg");

size(960,540);
frameRate (30);
background(255);
fondo= loadImage ("windows.jpg");
fondo.resize(960,540);

minim = new Minim (this);
cancionjuego=minim.loadFile ("menusong.mp3");
cancionmenu=minim.loadFile ("cancion.mp3");
cancionperder=minim.loadFile ("sonidoperder.mp3");
cancionganar=minim.loadFile ("sonidoganar.mp3");
sonidodestroy=minim.loadFile ("destroy.mp3");
sonidodisparo=minim.loadFile ("disparo.mp3");
sonidorayo=minim.loadFile ("sonidorayo.mp3");
sonidocolision=minim.loadFile ("colision.mp3");


cancionmenu.loop();

//---------------------------------------------------------------- FISICA
Fisica.init(this);  //inicializo librería
mundo = new FWorld();   //creo mundo física
mundo.setEdges(color (255));
mundo.remove(mundo.top);
mundo.remove(mundo.bottom);
//mundo.setEdgesRestitution(1);
//mundo.setGravity(0, 900);

cursor = new Cursor(70,70);
cursor.inicializar();
mundo.add(cursor);

sensor = new FMouseJoint(cursor,10,10);
sensor.setFrequency(400000);
mundo.add(sensor);

malos= new Malos(60,60); 
malos.inicializar();  

maloszig= new Malos (60,60);
maloszig.inicializar();
 
//---------------------------------------------------------------- CAMARA
camara= new Capture (this, 960,540);//inicializo camara
camara.start();
opencv= new OpenCV(this, 960,540); //mismas dimensiones que camara

umbral= 72; //umbral calibracion preestablecido

//inicia los blobs para los seguimientos por identidad
iniciarBlobs();
 
 //inicia el proceso de substracción
int historia = 5;
opencv.startBackgroundSubtraction( historia, 3, 0.5); //<>//
}


//---------------------------------------------------------------- DRAW
void draw()
{
 if (estado == "menu")
{   
 image (imagenMenu,0,0);
}


else if (estado == "instrucciones"){
    image (instruc,0,0);

}

else if (estado=="calibracion"){
    
    if ( camara.available() ) {
    //lee el nuevo fotograma
    camara.read();
    //cargo en openCV la imagen de la camara
    opencv.loadImage( camara );
    //aplicar un umbral
    opencv.threshold( umbral );
    PImage salida = opencv.getOutput();
    image( salida, 0, 0 );
    println("umbral=" + umbral);
    
 textSize(20);
 fill(255,0,0);
 text("Presiona las flechas ARRIBA o ABAJO para calibrar", 20,30);
 text("Presiona ENTER al terminar", 20,50);
  }  
} 

  else if (estado == "juego"){
 cursor.actualizar();
 malos.actualizar();
 maloszig.actualizarzig();
 
 
// println (contadorarchivos);         
//---------------------------------------------------------------- CAMARA

if (camara.available()){ 
camara.read();

// opencv
opencv.loadImage( camara );
opencv.threshold (umbral);
imagencamara=camara;


 detectBlobs(); // busco blobs que matienen su identidad en el tiempo
 
//recorro el ArrayList de blobs que genera la funcion detectBlobs
  for ( Blob esteBlob : blobList ) {
esteBlob.display(); 
  }
      
//recorro array de contornos blobs 1x1
contornos= opencv.findContours(); 
stroke (255,0,0);
for ( Contour Contorno : contornos){ 
Contorno.draw();
}

}

if (imagencamara != null){
image(fondo,0,0);
 blend(imagencamara, 0,0, width,height, 0,0, width,height,MULTIPLY);  
 
 // image(imagencamara,0,0);
}
mundo.step(); //actualizo fisica
mundo.draw();

 

// DISTINTAS DIFICULTADES SEGUN TIEMPO SOBREVIVIENDO

//----------------------------------------------- NIVEL1
if (contadorarchivos<5){ 
  
   if (frameCount % 170== 0){
  agregarMalos();
 }
  
 if (frameCount % 300== 0){ 
  agregarBuenos();
 } 
 
  if (frameCount % 1000== 0){ 
    agregarRayos();
 }
}

//----------------------------------------------- NIVEL2
else if (contadorarchivos>=5 && contadorarchivos< 20){ 
 
     if (frameCount % 150== 0){
  agregarMalos();
 }
 
 if (frameCount % 100== 0){
  agregarBuenos();
 
 }
 
  if (frameCount % 300== 0){
  agregarMalosZig();
 
 }
 
   if (frameCount % 500== 0){ 
    agregarMalosZigIzq();
 }
 
  if (frameCount % 900== 0){ 
    agregarRayos();
 }
 
}

//----------------------------------------------- NIVEL3
else if (contadorarchivos>=20 && contadorarchivos< 50){ 
   
     if (frameCount % 90== 0){
  agregarMalos();
 }
 
 if (frameCount % 40== 0){
  agregarBuenos();
 }
 
   if (frameCount % 200== 0){
  agregarMalosZig();
 
 }
 
   if (frameCount % 350== 0){ 
    agregarMalosZigIzq();
 }
 
  if (frameCount % 600== 0){ 
    agregarRayos();
 }
 
 
}


else if (contadorarchivos >=50){ //GANAR
 estado= "ganar";
}

 image (vida, 5,0); // barra de vida
 barraBateria();
 
 pushMatrix();
 stroke(255,255,255,40);
 noFill();
 rectMode (CENTER);
 rect (width/2,height/2,xrect,470); // zona de sensor mano / MAPEO
 popMatrix();
 //println(xrect);
 borrarDelMundo(); // cuando salen de pantalla los borro del mundo
  
    if (sumar==true){
  bateria =bateria+ 10;
   sonidorayo.play();
   sonidorayo.rewind();
   sumar=false;
     }



  }
  

else if (estado == "ganar"){
   image (ganaste,0,0);
   cancionjuego.pause();
   cancionganar.play();
 
}

else if (estado == "perder"){
    image (perdiste,0,0);
    cancionjuego.pause();
    cancionperder.play();
  
} //FIN DRAW

}




void keyPressed() { 
 
  
if (estado=="juego"){ 
  
if (key=='s'){
  //ejecuta la substracción de video VER
opencv.updateBackground();
  //obtengo una muestra del proceso de substraccion
 substraccion = opencv.getSnapshot();// snapshot
 println ("snapshot");

};

if (keyCode== LEFT){
 xrect++; 
}
 
else if (keyCode==RIGHT){ 
 xrect--;

}


  if (key=='c'){
estado = "calibracion";
cancionjuego.pause();

  }
}

if (estado == "calibracion"){

if (keyCode== UP){
  umbral ++;
  opencv.threshold (umbral);
}

else if (keyCode==DOWN){ 
  umbral --;
  opencv.threshold (umbral);
}

if (keyCode == ENTER){
estado = "juego";
 cancionjuego.loop();
 cancionmenu.pause();
}
  }


if (estado == "menu"){
if ( key==' ' ) {
 estado= "instrucciones";
 cancionperder.pause();
 cancionganar.pause();

} 
}

else if (estado == "instrucciones"){
if ( key==' ' ) {
 estado= "juego"; 
 cancionjuego.loop();
 cancionmenu.pause();
} 
}

else if (estado == "ganar" || estado=="perder"){
 if ( key==' ' ) {
   camara.stop();
   setup();
   contadorarchivos=0;
   bateria=100;
}  
  
}

}

void agregarMalos() {
malos= new Malos(70,70); 
malos.inicializar();  
mundo.add(malos);
malos.setName ("malos");

;}


void agregarMalosZig(){
maloszig= new Malos (70,70);
maloszig.inicializar();
mundo.add(maloszig);
maloszig.setName ("maloszig");
xzag =xmalo++;
maloszig.setVelocity (xzag,yzag);

;}

void agregarMalosZigIzq(){
maloszig= new Malos (70,70);
maloszig.inicializar();
mundo.add(maloszig);
maloszig.setName ("maloszig");
xzag =xmalo++;
maloszig.setVelocity (-xzag,yzag);

;}

void agregarBuenos() {
 
 buenos= new Buenos(70,70); 
 buenos.inicializar();
 mundo.add(buenos);
 buenos.setName ("buenos");

}

void agregarRayos() {
rayo= new Rayos(40,40); 
rayo.inicializar();
 mundo.add(rayo);
 rayo.setName ("rayo");

}
