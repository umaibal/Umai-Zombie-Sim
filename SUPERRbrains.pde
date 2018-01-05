/* Umai Balendra 
 SUPERR Brains Oct 30*/

int totalSurvivors = 15;

float ran;

final int circleDim = 40;
float initInfected = 0.5; //initial infected survivor rate = 50%
final float thirty = 0.3;
final float sixty = 0.6;
final float twenty = 0.2;
final float toRespawn = 0.25;

float percentOfSurvivors;
float numHealthies;
int totalBulletsHeld;

int randColor;

int movementX;
int movementY;
float survMovement;

final int survSpeed = 3;
final int injuredSpeed = 2; 
final int infectedSpeed = 5;

color[] legend = {
  color(116, 240, 185), //healthy is green
  color(240, 0, 0), //injured is red
  color(240, 197, 116), //infected is yellow
}; //color legend for survivors

void setup()
{
  size(600, 600);
  background(200);
  survMovement = 0;

  frameRate(20);

  makeSurvivors();
  drawSurvivors();
}

class Survivor
{
  String name;
  float x;
  float y;

  int placeX;
  int placeY;

  int zombieX;
  int zombieY;

  boolean infected = false;
  boolean injured = false;
  boolean healthy = false;
  int numBullets;

  color colour;
} //survivor class

//make array of survivor objects
Survivor[] nonZombie = new Survivor[totalSurvivors]; 

void moveAround()
{
  //angle variates to help wandering behav.
  float anglez = 0;
  int closest = 0;

  for (int k = 0; k < totalSurvivors; k++)
  {
    //set target of zombies
    if (nonZombie[k].infected == false) //if first obj is survivor
    {
      for (int s = 0; s < totalSurvivors; s++)
      {
        if (nonZombie[s].infected == true) //if second obj is zombie
        {
          //if distance between surv and zombie is less than
          //distance between surv and closest one,
          //set target:
          if (dist(nonZombie[k].x, nonZombie[k].y, 
            nonZombie[s].x, nonZombie[s].y) < dist(nonZombie[k].x, 
            nonZombie[k].y, nonZombie[closest].x, nonZombie[closest].y))
          {
            //keep track of closest:
            closest = s;
          }
        }
      }
    } else //do same thing for setting target of survivors
    {
      for (int s = 0; s < totalSurvivors; s++)
      {
        if (nonZombie[s].infected == false) //if is a survivor
        {
          //if distance between surv and zombie is less than
          //distance between surv and closest one
          if (dist(nonZombie[k].x, nonZombie[k].y, 
            nonZombie[s].x, nonZombie[s].y) < dist(nonZombie[k].x, 
            nonZombie[k].y, nonZombie[closest].x, nonZombie[closest].y))
          {
            closest = s;
          }
        }
      }
    }

    if (nonZombie[k].injured == true) //if injured, use injured speed
    {
      survMovement = -1 * injuredSpeed; //-1 to run away
    } else if (nonZombie[k].infected == false) //if not infected, use healthy speed
    {
      survMovement = -1 * survSpeed; //-1 to run away
    } else 
    {
      survMovement = infectedSpeed; //infected speed, no reverse moves
    }

    //wandering BEHAVIOUR:
    //calculate range of the angle b/w zombie and surv
    float zombieDir = atan2(nonZombie[closest].y - nonZombie[k].y, 
      nonZombie[closest].x- nonZombie[k].x); 

    //from sheep wandering codes:
    nonZombie[k].x += survMovement*cos(zombieDir); //shift x
    nonZombie[k].y += survMovement*sin(zombieDir); //shift y

    //println(nonZombie[k].x + " p " + nonZombie[k].y);

    for (int u = 0; u < totalSurvivors; u++)
    {
      float crossProduct=(nonZombie[k].x)*
        (nonZombie[closest].y-nonZombie[k].y)-
        (nonZombie[k].y)*
        (nonZombie[closest].x-nonZombie[k].x);//get the angle

      //println("here");

      if (crossProduct<0) 
      {
        anglez -= radians(anglez+random(anglez/3)-anglez/8);
      } else
      {
        anglez += radians(anglez-random(anglez/3.0)-anglez/8.0f);
      }//if direction is pos or neg
    }
  }
} //function to do wandering movement, used 5.3 code as reference

void makeSurvivors()
{
  for (int num = 0; num < totalSurvivors; num++)
  {
    nonZombie[num] = new Survivor();
    nonZombie[num].x = random(circleDim/2, width-circleDim/2);
    nonZombie[num].y = random(circleDim/2, height-circleDim/2);
    nonZombie[num].numBullets = (int)random(1, 11);

    ran = random(1);

    if (ran < initInfected) //half the time, make zombies
    {
      nonZombie[num].colour =  legend[2];//set color to infected color
      nonZombie[num].infected = true; //is infected

      //nonZombie[num].zombieX = (int)random(circleDim/2, width-circleDim/2);
      //nonZombie[num].zombieY = (int)random(circleDim/2, height-circleDim/2);
    } else  //other half of time, make healthy survs
    {
      nonZombie[num].colour = legend[0];
      nonZombie[num].infected = false;
      nonZombie[num].injured = false; //set to healthy

      numHealthies++;
    }
  }
}//create array of survivors using object that was made

void drawSurvivors()
{
  for (int num=0; num < totalSurvivors; num++)
  {
    if (nonZombie[num].infected == true) 
    {
      nonZombie[num].colour =  legend[2]; //infected
    } else if (nonZombie[num].injured == true)
    {
      nonZombie[num].colour = legend[1]; //injured
    } else
    {
      nonZombie[num].colour = legend[0]; //healthy
    }
    //draw shapes with labels
    fill(nonZombie[num].colour);
    noStroke();
    ellipse(nonZombie[num].x, nonZombie[num].y, circleDim, circleDim);
    fill(0);
    text(num, nonZombie[num].x + circleDim/2, nonZombie[num].y + circleDim/2);
  }
} //draw created color coded survivors

int bulletsHeld(Survivor[] arrayOfSurvivors)
{
  int numberOfBulletsHeld = 0;
  for (int y = 0; y < totalSurvivors; y++)
  {
    if (arrayOfSurvivors[y].injured == false && 
      arrayOfSurvivors[y].infected == false) //if healthy 
    {
      //add to sum of bullets held
      numberOfBulletsHeld += arrayOfSurvivors[y].numBullets;
    }
  }
  return numberOfBulletsHeld;
}//function that returns num of bullets held by healthy surv

float percentage(Survivor[] arrayOfSurvivors)
{
  numHealthies = 0; //set counter to 0
  for (int h = 0; h < totalSurvivors; h++)
  {          
    if (arrayOfSurvivors[h].injured == false 
      && arrayOfSurvivors[h].infected == false) //if healthy:
    {
      numHealthies++;
    }
  }
  //calculation:
  float percentHealthies = 100*(numHealthies / totalSurvivors);
  return percentHealthies;
}//function that returns perc of healthy survs among all survs

boolean checkCollision(Survivor a, Survivor b)
{
  //if objects a and b collide:
  if (dist(a.x, a.y, b.x, b.y) <= circleDim/2)
  {
    return true; //if happens
  } else
  {
    return false; //if no collision
  }
} //check if two survivor circles collide or not using circle collisions

void collisionImpact()
{
  //2 fors to compare survs and zombies
  //scan survivor array for all survivors:
  for (int r = 0; r < totalSurvivors; r++)
  {
    ran = random(1);
    for (int g = 0; g < totalSurvivors; g++)
    {
      //if is zombie and collision happens:
      if (nonZombie[r].infected == true && 
        checkCollision(nonZombie[r], nonZombie[g])) {
        if (nonZombie[g].injured == true)
        {
          //infected 60 percent of time if injured
          if (ran < sixty) {
            nonZombie[g].infected = true;
            //nonZombie[g].injured = false;
          }//if injured
        } else
        {
          //infected 30 percent of time if healthy
          if (ran < thirty) {
            nonZombie[g].infected = true;
          }
        } //if healthy
      }
    }
  }
}//function that updates survs based on collisions

//void respawn(Survivor[] h)
//{
//  int lastArrayItem = nonZombie.length-1;  
//  {
//    h[lastArrayItem].injured = true;
//    h[lastArrayItem].x = random(circleDim/2, width-circleDim/2);
//    h[lastArrayItem].y = random(circleDim/2, height-circleDim/2);
//    h[lastArrayItem].numBullets = (int)random(11);
//  }//first respawn
//}

void callReinforcements()
{
  fill(0);
  //call percentage function
  text("Percent of Healthy Surv: "+ percentage(nonZombie), width/8, 575);
  //call bullets function:
  text("Bullets Held: " + bulletsHeld(nonZombie), width/8, 20);

  int lastArrayItem = nonZombie.length-1;  

  //call help if:
  if (percentage(nonZombie)<twenty)
  {
    ran = random(1);
    //use 'APPEND' fn to add an extra index to the Survivor object array:
    nonZombie = (Survivor[])append(nonZombie, new Survivor());
    //if less than 20%, get two respawners
    if (ran < toRespawn) 
    {
      nonZombie[lastArrayItem].injured = true;
      nonZombie[lastArrayItem].x = random(circleDim/2, width-circleDim/2);
      nonZombie[lastArrayItem].y = random(circleDim/2, height-circleDim/2);
      nonZombie[lastArrayItem].numBullets = (int)random(1, 11);
    }
    nonZombie = (Survivor[])append(nonZombie, new Survivor());
    if (ran < toRespawn) {
      nonZombie[lastArrayItem].injured = true;
      nonZombie[lastArrayItem].x = random(circleDim/2, width-circleDim/2);
      nonZombie[lastArrayItem].y = random(circleDim/2, height-circleDim/2);
      nonZombie[lastArrayItem].numBullets = (int)random(1, 11);
    } //second 
    totalSurvivors += 2; //add to surv total bc 2 new objects were made
  }
}

void draw()
{
  background(200);
  moveAround(); 
  drawSurvivors();

  collisionImpact();
  callReinforcements();
}
