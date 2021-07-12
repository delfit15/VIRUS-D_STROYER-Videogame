
void contactStarted(FContact contact)
{
  FBody _body1 = contact.getBody1();
  FBody _body2 = contact.getBody2();
  

  //-----------CONTACTO ENTRE BALA Y ARCHIVOS MALOS

  if ((_body1.getName() == "malos" && _body2.getName() == "bala") || (_body2.getName() == "malos" && _body1.getName() == "bala"))
  {
       mundo.remove( _body1 );
       mundo.remove( _body2 ); 
       contadorarchivos++;
       sonidocolision.play();
       sonidocolision.rewind();
     
 
       
  }
  
  if ((_body1.getName() == "maloszig" && _body2.getName() == "bala")  || (_body2.getName() == "maloszig" && _body1.getName() == "bala"))
  { 
       mundo.remove( _body1 );
       mundo.remove( _body2 ); 
       contadorarchivos++;
       sonidocolision.play();
       sonidocolision.rewind();
  }
  

  
  //-----------CONTACTO ENTRE BALA Y ARCHIVOS BUENOS

  if ((_body1.getName() == "buenos" && _body2.getName() == "bala") || (_body2.getName() == "buenos" && _body1.getName() == "bala"))
  {
   mundo.remove( _body1 );
   mundo.remove( _body2 ); 
   restarBateria();
  }
  
    //-----------CONTACTO ENTRE BALA Y RAYO

  if ((_body1.getName() == "rayo" && _body2.getName() == "bala")
    || (_body2.getName() == "rayo" && _body1.getName() == "bala"))
  {
   mundo.remove( _body1 );
   mundo.remove( _body2 ); 
   sumar=true;
  }
  
}


void borrarDelMundo() {

  ArrayList <FBody> cuerpos = mundo.getBodies();
  for ( FBody este : cuerpos ) {
    String nombre = este.getName();
    if ( nombre != null ) {
      if (  nombre.equals("buenos") || nombre.equals("rayo")) {
       
        if ( este.getY() > height+70 ) {
          mundo.remove( este );
          
        }
        
         
      }
      if (nombre.equals("malos") || nombre.equals("maloszig") ) {
        
         if ( este.getY() > height+70 ) {
          mundo.remove( este );
           restarBateria();
          
        }
         
      }
      
      
        if (nombre.equals("bala"))
       {  if ( este.getY() < 0){
          mundo.remove( este );
       }
        }       
      
    }  
  }
}

void barraBateria(){
   if (bateria > 40) {
      fill (14,255,3);
      
  } else if (bateria <= 40) {
    fill(255,0,0);}
    noStroke();
     rectMode (CORNER);
    rect(15, 35, barraBateriaAncho*(bateria/maxvida), 32);
    
 
    if (bateria >= 100){
  sumar=false;
 }
      
}

void restarBateria (){

  bateria -= 5;
    sonidodestroy.play();
   sonidodestroy.rewind();
   
    

 
  if (bateria <= 0){
    estado="perder"; 
  }

}
