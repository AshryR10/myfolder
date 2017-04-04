// game pong with A.I

float gameScreen = 0;

float ballX;
float ballY;
float ballSize = 20;
color ballColor = color(255,0,100);
float ballSpeedVert;
float ballSpeedHor;

float pongX;
float pongY;
float pongWidth = 70;
float pongHeight = 10;
float pongSpeed = 0;
color pongColor = color(255,0,100);

float AIpongX;
float AIpongY;
float AIpongWidth = 70;
float AIpongHeight = 10;
float AIpongSpeed = 0;
color AIpongColor = color(255,0,100);
boolean terpantul = false;
boolean terpantulPong = false;

float health;
float maxHealth;
float healthWidth = 50;
float healthHeight = 7;

int scorePong = 0;
int AIscorePong = 0;

float pembatasX;
float pembatasY;
float pembatasWidth = 500;
float pembatasHeight = 7;

void setup() {
  size(500,500);
  
  ballX = random(width/2);
  ballY = height/2;
  ballSpeedVert = 20;
  ballSpeedHor = 20;
  
  pongX = width/2;
  pongY = height - 20;
  pongSpeed = 20;
  
  AIpongX = width/2;
  AIpongY = 0 + 20;
  AIpongSpeed = 20;
  
  pembatasX = width/2;
  pembatasY = height/2;
}

void draw() {
  if(gameScreen == 0) {
    initScreen();
  } else if(gameScreen == 1) {
    gameScreen();
  } else if(gameScreen == 2) {
    gameOverScreen();
  }
}

void mousePressed() {
 if(gameScreen == 0) {
  startGame(); 
 } else if(gameScreen == 2) {
  restart(); 
 }
}

void keyPressed() {
 if(key == 'D') {
   pongX = pongX + (pongSpeed * 1); 
 } else if(key == 'A') {
   pongX = pongX + (pongSpeed * -1);
 } 
 
 if(key == 'S') {
    ballSpeedHor = 20;
 } else if(key == 'W') {
    ballSpeedHor = 2.5;
    ballSpeedVert = 2.5;
 }
}

void startGame() {
  gameScreen = 1;
}

void restart() {
  scorePong = 0;
  gameScreen = 0;
}

void initScreen() {
  background(0);
  fill(255);
  textAlign(CENTER);
  textSize(15);
  text("Click to start!", width/2, height/2);
}

void gameScreen() {
  background(255);
  
  // menampilkan bola
  drawBall();
  keepBall();
  applySpeedVert();
  applySpeedHor();
  
  // menampilkan pong
  drawPong();
  bounceBallOnPong();
  bounceBallOnAIPong();
  pongBehavior();
  
  // menampilkan AI pong
  drawAIPong();
  AIBehavior();
  
  // menampilkan score
  printScore();
  
  touchGoalEnemy();
  checkWin();
  
  drawPembatas();
}

void gameOverScreen() {
  background(0);
  fill(255,0,0);
  textAlign(CENTER);
  
  if(scorePong == 10 && gameScreen == 2) {
   textSize(30);
   text("Game Over, Player Win!", width/2, height/2);
   textSize(20);
   text("Player Score : " + scorePong, width/2, height/2 + 20); 
  } else if(AIscorePong == 10 && gameScreen == 2) {
   textSize(30);
   text("Game Over, A.I Win!", width/2, height/2);
   textSize(20);
   text("A.I Score : " + AIscorePong, width/2, height/2 + 20);
  }
}

void drawBall() {
  fill(ballColor);
  noStroke();
  ellipseMode(CENTER);
  ellipse(ballX, ballY, ballSize, ballSize);
}

void applySpeedHor() {
  ballX = ballX + ballSpeedHor;
}

void applySpeedVert() {
  ballY = ballY + ballSpeedVert;
}

void keepBall() {
  if(ballY+(ballSize/2) > height) {
   makeBounceBottom(height); 
  }
  if(ballY-(ballSize/2) < 0) {
   makeBounceTop(0); 
  }
  if(ballX-(ballSize/2) < 0) {
   makeBounceLeft(0); 
  }
  if(ballX+(ballSize/2) > width) {
   makeBounceRight(width); 
  }
}

void makeBounceBottom(float surface) {
  ballY = surface-(ballSize/2);
  ballSpeedVert *= -1;
  terpantul = false;
}

void makeBounceTop(float surface) {
  ballY = surface+(ballSize/2);
  ballSpeedVert *= -1;
  terpantulPong = false;
}

void makeBounceRight(float surface) {
  ballX = surface-(ballSize/2);
  ballSpeedHor *= -1;
  
}

void makeBounceLeft(float surface) {
  ballX = surface+(ballSize/2);
  ballSpeedHor *= -1;
}

void drawPong() {
  noStroke();
  fill(pongColor);
  rectMode(CENTER);
  rect(pongX, pongY, pongWidth, pongHeight);
}

void drawAIPong() {
 noStroke();
 fill(AIpongColor);
 rectMode(CENTER);
 rect(AIpongX, AIpongY, AIpongWidth, AIpongHeight);
}

void bounceBallOnPong() {
 if((ballX+(ballSize/2) > pongX-(pongWidth/2)) && (ballX-(ballSize/2) < pongX+(pongWidth))) {
   if(ballY+(ballSize/2) >= pongY){
     makeBounceBottom(pongY);
     ballSpeedHor = (ballX - pongX)/5;
     terpantulPong = true;
   }
 }
}

void bounceBallOnAIPong() {
 if((ballX+(ballSize/2) > AIpongX-(AIpongWidth/2)) && (ballX-(ballSize/2) < AIpongX+(AIpongWidth/2))) {
   if(ballY-(ballSize/2) <= AIpongY){
     makeBounceTop(AIpongY);
     ballSpeedHor = (ballX - AIpongX)/5;
     terpantul = true;
   }
 }
}

void AIBehavior() {
  if(ballY < height/2) {
    if(terpantul == false) {
      if(!(ballX+(ballSize/2) > AIpongX-(AIpongWidth/2))) {
        AIpongX = AIpongX + (AIpongSpeed * -1);
      } else if(!(ballX-(ballSize/2) < AIpongX+(AIpongWidth/2))) {
        AIpongX = AIpongX + (AIpongSpeed * 1);
      }
    } else {
      // do nothing
    }
  }
}

void pongBehavior() {
  if(ballY > height/2) {
    if(terpantulPong == false) {
      if(!(ballX+(ballSize/2) > pongX-(pongWidth/2))) {
        pongX = pongX + (pongSpeed * -1);
      } else if(!(ballX-(ballSize/2) < pongX+(pongWidth/2))) {
        pongX = pongX + (pongSpeed * 1);
      }
    } else {
     // do nothing 
    }
  }
}

void touchGoalEnemy() {
  if(ballY-(ballSize/2) < 0) {
    scorePong();
  } else if(ballY+(ballSize/2) > height) {
    AIscorePong(); 
  }
}

void checkWin() {
  if(scorePong == 10) {
    scorePong = 10;
    gameScreen = 2;
    gameOverScreen();
  } else if(AIscorePong == 10) {
    AIscorePong = 10;
    gameScreen = 2;
    gameOverScreen();
  }
}

void drawPembatas() {
 fill(0,100);
 rectMode(CENTER);
 rect(pembatasX, pembatasY, pembatasWidth, pembatasHeight);
}

void printScore() {
 textAlign(CENTER);
 text("Player Score : " + scorePong, 60, 15);
 text("AI Score : " + AIscorePong, 45, 35);
}

void scorePong() {
 scorePong++; 
}

void AIscorePong() {
 AIscorePong++; 
}