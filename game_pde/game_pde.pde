/*
  Description: Processing Assignment Two
 Author: Mihir Kachroo
 Date of last edit: November 18
 */

float moveObjects;
float moveBirdY;
boolean darkMode;
int currentScore, topScore;
int screenType;
int pillarX, currentPillarHeight;
IntList whiteDotsX, whiteDotsY;
int moveWhiteDotsX, lastWhiteDotsX;
IntList starsX, starsY;
int moveStarsX, lastStarsX;
int moveGreenTrackX;
float goldCoinX, goldCoinY;
FloatList darkBubblesX, darkBubblesSize, lightBubblesX, lightBubblesSize, buildingsX, buildingsSize, greenBubblesX, greenBubblesY, greenBubblesSize;
float darkBubbleX, lightBubbleX, greenBubbleX, buildingX;
int endingTextSize;
float gravity, velocity;
float distance;
float smallCirclesX, smallCirclesY;
boolean pauseCounter;

void settings() {
  size(950, 650);
}

void setup() { 
  background(76, 188, 252);
  textAlign(CENTER);

  //Prints introduction text
  println("Welcome to Flappy Bird");
  println("Instructions:");
  println("  Select Easy or Hard");
  println("  Click on the circles to change time of day");
  println("  Press p to pause and resume");
  println("  Press e to quit");

  //Defines variables
  gravity=1.3;
  velocity=0;
  goldCoinX=random(width+150, width+350);
  goldCoinY=random(200, 400);
  endingTextSize=10;
  moveGreenTrackX=0;
  currentPillarHeight= (int) random(10, 400);
  pillarX=0;
  lastWhiteDotsX=width-60;
  lastStarsX=width-10;
  screenType=0;
  moveBirdY=0;
  darkMode=false;
  currentScore=0;

  //Initiates lists
  whiteDotsX=new IntList();
  whiteDotsY=new IntList();
  starsX=new IntList();
  starsY=new IntList();
  darkBubblesX = new FloatList();
  darkBubblesSize = new FloatList();
  darkBubbleX=random(-15, 0);
  lightBubblesX = new FloatList();
  lightBubblesSize = new FloatList();
  lightBubbleX=random(-15, -10);
  buildingsX = new FloatList();
  buildingsSize = new FloatList();
  buildingX=random(-15, -10);
  greenBubblesX = new FloatList();
  greenBubblesY = new FloatList();
  greenBubblesSize = new FloatList();
  greenBubbleX=random(-20, -5);

  //Adds the size and x location of the bubbles and buildings to the lists
  for (int i = 0; i<300; i++) {
    //Appends dark bubble values
    darkBubblesX.append(darkBubbleX);
    darkBubblesSize.append(random(72, 110));
    darkBubbleX+=random(45, 55);

    //Appends light bubble values
    lightBubblesX.append(lightBubbleX);
    lightBubblesSize.append(random(69, 90));
    lightBubbleX+=random(40, 50);

    //Appends building values
    buildingsX.append(buildingX);
    buildingsSize.append(random(-100, -75));
    buildingX+=random(40, 80);

    //Appends green bubble values
    greenBubblesX.append(greenBubbleX);
    greenBubblesY.append(random(593, 610));
    greenBubblesSize.append(random(40, 50));
    greenBubbleX+=random(-15, 25);
  }
}

void draw() {
  if (screenType == 0) {
    startScreen();
  }
  if (screenType == 1) {
    gameScreen();
  }
  if (screenType==2) {
    winScreen();
  }
  checkDeath();
  
  if (key=='x') {
    fill(255);
    ellipse (mouseX, mouseY, 2, 2);
    text("x: "+ mouseX+ "     y: "+ mouseY, mouseX, mouseY);
  }
  
}

color findCircleColour(float XPos, float YPos) {
  //Returns colour based on position of circle to mouse
  distance = dist(XPos + 50, YPos + 50, mouseX, mouseY);
  if (distance<=250) {
    return color(218, 13, 21);
  } else {
    return color(11, 175, 17);
  }
}

void winScreen() {
  //Resets small circle variables
  smallCirclesY=24;
  smallCirclesX=20;

  background(0);
  stroke(0);
  strokeWeight(0.7);
  while (smallCirclesX<width) { //Creates each circle column
    while (smallCirclesY<height) { //Creates each circle in column
      fill(findCircleColour(smallCirclesX, smallCirclesY));
      ellipse(smallCirclesX, smallCirclesY, 40, 40);
      smallCirclesY+=40;
    }
    smallCirclesX+=40;
    smallCirclesY=24;
  }

  //Creates winning text and enlarges it at constant rate
  fill(255);
  textAlign(CENTER);
  textSize(endingTextSize);
  endingTextSize+=5;
  if (endingTextSize>=140) {
    endingTextSize=140;
  }
  text("You Win!", width/2, height/1.8);
}

void gameScreen() {
  createBackground();
  createBackgroundObjects();
  moveBird();
  createGoldCoin();
  createPillar();
  createGround();

  //Current Score
  textSize(50);
  fill(250);
  text(currentScore, width/2, 75);
}

void moveBird() {
  velocity += gravity;
  moveBirdY += velocity;
  //Creates the flappy Bird
  stroke(0);
  strokeWeight(1.7);
  fill(240, 190, 83);
  ellipse(200, 300+moveBirdY, 43, 35); //Yellow body
  fill(245);
  ellipse(210, 292.5+moveBirdY, 20, 19); //White eye
  fill(230);
  rect(175, 298+moveBirdY, 18, 10, 8); //White wing
  fill(253, 104, 74);
  rect(207, 300+moveBirdY, 20, 6, 100); //Upper lip
  rect(207, 306+moveBirdY, 17, 6, 100); //Lower lip
  triangle(207, 301+moveBirdY, 202, 306+moveBirdY, 207, 311+moveBirdY); //Side of lip
  strokeWeight(0);
  triangle(209, 303.5+moveBirdY, 203, 306+moveBirdY, 209, 310+moveBirdY); //Covers the join between the upper, lower and side lip
  strokeWeight(5.8);
  point(214, 292.5+moveBirdY); //Black eye pupil
}

void createBackgroundObjects() {
  //Creates dark bubbles from the lists defined in setup()
  for (int i = 0; i<300; i++) {
    noStroke();
    fill(81, 129, 175);
    ellipse(darkBubblesX.get(i), 500, darkBubblesSize.get(i), darkBubblesSize.get(i));
  }

  //Creates light bubbles from the lists defined in setup()
  for (int i = 0; i<300; i++) {
    fill(109, 159, 204);
    ellipse(lightBubblesX.get(i), 555, lightBubblesSize.get(i), lightBubblesSize.get(i));
  }

  //Creates buildings from the lists defined in setup()
  for (int i = 0; i<300; i++) {
    //Chooses different colours for building based on i values
    if (i%4 == 0) {
      fill(187, 136, 60);
    } else if (i%3 == 0) {
      fill(14, 18, 95);
    } else {
      fill(22, 168, 24);
    }
    rect(buildingsX.get(i), 600, -1*buildingsSize.get(i)/2, buildingsSize.get(i));
  }    

  //Creates green bubbles from the lists defined in setup()
  for (int i = 0; i<300; i++) {
    stroke(25, 170, 60);
    strokeWeight(2);
    fill(39, 129, 66);
    ellipse(greenBubblesX.get(i), greenBubblesY.get(i), greenBubblesSize.get(i), greenBubblesSize.get(i));
  }
}

void createBackground() {
  //Creates the background
  for (int i=0; i<height; i+=1) {
    //Uses darkMode boolean to decide weather to create a dark or light background
    if (darkMode==true) {
      stroke(61-i/15, 80, i/5+90);
    } else {
      stroke(76, 188, 252);
    }
    line(0, i, width, i);
  }
  if(darkMode==true){
      createWhiteDots();
      createStars();
    }
}

void checkGoldCoinCollision(float x, float y) {
  //Adds point and resets gold coin x if bird hits the coin
  if (dist(x, y, 205, moveBirdY+300) < 30) {
    currentScore+=1;
    goldCoinX=random(-70, -50);
    ;
  }
}

void createGoldCoin() {
  goldCoinX-=moveObjects;
  //Creates gold point
  strokeWeight(1);
  fill(220, 185, 9);
  ellipse(goldCoinX, goldCoinY, 25, 25);
  fill(250);
  textSize(20);
  text(1, goldCoinX, goldCoinY+6);
  checkGoldCoinCollision(goldCoinX, goldCoinY);

  //Resets x and y of gold coin if it goes of screen
  if (goldCoinX<0) {
    goldCoinX=random(width+50, width+300);
    goldCoinY=random(150, 400);
  }
}

void checkDeath() {
  //Resets program if bird has hit the top or bottom piller
  if ((moveBirdY+320)>(currentPillarHeight+160) || (moveBirdY+285)<(currentPillarHeight+30)) {
    if ((width+95-pillarX)>=176 && (width-5-pillarX)<=227) {
      println("death");
      setup();
    }
  }
}

void createPillar() {
  //Creates the light green part of pillars
  strokeWeight(5);
  fill(50, 207, 13);
  rect(width+5-pillarX, currentPillarHeight, 80, -100000);
  rect(width+5-pillarX, currentPillarHeight+190, 80, 100000);

  //Creates the dark green part of pillars
  fill(38, 150, 10);
  rect(width-5-pillarX, currentPillarHeight, 100, 30);
  rect(width-5-pillarX, currentPillarHeight+190, 100, -30);
  pillarX+=moveObjects;

  //Adds a point to current score if the bird passes the piller
  if (width+95-pillarX==105) {
    currentScore+=1;
    //Updates the top score
    if (currentScore>topScore) {
      topScore=currentScore;
    }
    //Activates the win screen
    if (currentScore>=5) {
      screenType=2;
    }
  }

  //Creates new pillar
  if (width+95-pillarX<0) {
    currentPillarHeight= (int) random(10, 400);
    pillarX=0;
  }
}


void keyPressed() {
  //Makes bird jump
  if (key==' ' || keyCode==UP) {
    velocity=-20;
  }

  //Pauses and resumes program
  if (key=='p' || key=='P') {
    if (pauseCounter) {
      noLoop();
    } else {
      loop();
    }
    pauseCounter=!pauseCounter;
  }

  //Closes program
  if (key=='e' || key=='E') {
    exit();
  }
}

void mousePressed() {
  //Makes bird jump
  if (mouseButton == LEFT) {
    velocity=-20;
  }
}


void createWhiteDots() {
  //Creates new white dot
  lastWhiteDotsX+=(int) random(100, 110);
  whiteDotsX.append(lastWhiteDotsX);
  whiteDotsY.append((int) random(-30, 350));

  //Accesses white dots lists to create dots
  for (int i=0; i<whiteDotsX.size(); i+=1) {
    fill(255);
    ellipse(whiteDotsX.get(i)+moveWhiteDotsX, whiteDotsY.get(i), 4, 4);
  }
  moveWhiteDotsX-=moveObjects/2;
}

void createStars() {
  //Creates new star
  lastStarsX+=(int) random(180, 210);
  starsX.append(lastStarsX);
  starsY.append((int) random(-45, 260));

  //Accesses stars lists to create stars
  for (int i=0; i<starsX.size(); i+=1) {
    noStroke();
    //Chooses colour for star depending on i value
    if (i%3==0) {
      fill(70, 100, 160);
    } else {
      fill(255, 246, 0);
    }
    rect(starsX.get(i)+moveStarsX, starsY.get(i), 0, 0, -6);
  }
  moveStarsX-=moveObjects/2;
}

void createGround() {
  //Creates the pale ground
  noStroke();
  fill(230, 180, 120);
  rect(0, height, 950, -45);

  //Creates the green track
  for (int i=0; i<90000; i+=40) {
    strokeWeight(2);
    stroke(10);
    fill(118, 190, 51);
    rect(i-moveGreenTrackX+1, height-47, 40, 10, 3);
    noStroke();
    fill(152, 218, 91);
    rect(i-moveGreenTrackX+3, height-44.5, 15, 6.5, 1);
  }
  moveGreenTrackX+=moveObjects;
}

void startScreen() {
  //Creates information box
  stroke(0);
  strokeWeight(6);
  fill(220, 213, 135);
  rect(275, 250, 400, 100);

  //Creates Start Game text
  textSize(55);
  fill(251, 150, 72);
  text("Start Game", 480, 207);

  //Displays Current Score and Top Score texts
  textSize(27);
  text("Current Score", 490, 285);
  text("Top Score", 472, 331);

  //Displays Current Score and Top Score numbers
  fill(255);
  text(currentScore, 330, 285);
  text(topScore, 330, 331);

  //Creates the light and dark mode symbols
  noStroke();
  fill(255, 255, 0);
  ellipse(295, 190, 40, 40); //Light symbol
  fill(0, 20, 0);
  ellipse(665, 190, 40, 40); //Dark symbol

  //Uses mouse X and Y values to check if it is within the light symbol
  if (mousePressed && dist(295, 190, mouseX, mouseY) < 20) {
    darkMode=false;
    print("hi");
  }

  //Uses mouse X and Y values to check if it is within the dark symbol
  if (mousePressed && dist(665, 190, mouseX, mouseY) < 20) {
    darkMode=true;
  }

  //Highlights (by changing the colour) the option which the user is hovering over
  if (mouseX<405 && mouseX>275 && mouseY<430 && mouseY>380) {
    fill(49);
  } else {
    fill(0); //The default colour if the user is not hovering over the option
  }

  //Creates the left rectangle
  stroke(255);
  strokeWeight(4);
  rect(275, 380, 130, 50);

  //Highlights (by changing the colour) the option which the user is hovering over
  if (mouseX<675 && mouseX>545 && mouseY<430 && mouseY>380) {
    fill(190);
  } else {
    fill(255); //The default colour if the user is not hovering over the option
  }

  //Creates the right rectangle
  stroke(0);
  rect(545, 380, 130, 50);

  if (mousePressed) {
    if (mouseX<405 && mouseX>275 && mouseY<430 && mouseY>380) { //If the user selects the play option
      moveObjects=10;
      screenType=1;
    } else if (mouseX<675 && mouseX>545 && mouseY<430 && mouseY>380) { //If the user selects the quit option
      moveObjects=20;
      screenType=1;
    }
  }

  //Writes the text for the options of playing or quitting
  textAlign(CENTER);
  fill(0, 102, 153);
  textSize(25);
  text("Easy", 340, 413);
  text("Hard", 610, 413);
}
