#include "Keyboard.h"
#define ACCELX A0
#define ACCELY A1
#define ACCELZ A2

struct AccelVector {
  int x;
  int y;
  int z;
};

void setup() {
 pinMode(2, INPUT_PULLUP);
 Serial.begin(9600);
 Keyboard.begin();
 if(digitalRead(2) == LOW){
  Keyboard.end();
 }
}

typedef struct{
  boolean LEFT;
  boolean RIGHT;
  boolean UP;
  boolean DOWN;
}Direction;
Direction direction = {false, false, false, false};

struct AccelVector read_accelerometer(void) {

  struct AccelVector ret;
  ret.x = analogRead(ACCELX) - 500;
  ret.y = analogRead(ACCELY) - 500;
  ret.z = analogRead(ACCELZ) - 500;

  return ret;
}

void print_accel(struct AccelVector v) {
  Serial.print("Accel vect: ");
  Serial.print(v.x);
  Serial.print(" - ");
  Serial.print(v.y);
  Serial.print(" - ");
  Serial.println(v.z);
}

struct AccelVector last_accel_vector;

void Motion(){

  struct AccelVector new_accel_vector = read_accelerometer();

//  print_accel(new_accel_vector);
//  print_accel(last_accel_vector);
  
  const int threshold = 60;

     direction.LEFT = false;
     direction.RIGHT = false;
     direction.UP = false;
     direction.DOWN = false;

  if ( new_accel_vector.x > threshold ) {
     direction.LEFT = true;
  //   last_accel_vector = new_accel_vector;
  }
  else if ( new_accel_vector.x < -threshold ) {
     direction.RIGHT = true;
    // last_accel_vector = new_accel_vector;
  }
  else if ( new_accel_vector.y > threshold ) {
      direction.DOWN = true;
     //last_accel_vector = new_accel_vector;
  }
   else if ( new_accel_vector.y < -threshold ) {
      direction.UP = true;
     //last_accel_vector = new_accel_vector;
  }
}

void loop() {
   
     Motion();
     if(direction.LEFT){
       
       Keyboard.print("A");}
     else if(direction.RIGHT){
        
        Keyboard.println("D");}
     else if(direction.UP){
      
       Keyboard.print("W");
       }
     else if(direction.DOWN){
      Keyboard.println("S");}
     delay(200);
   
}
