import SimpleOpenNI.*;
import deadpixel.keystone.*;
import ddf.minim.*;

Minim minim;
AudioPlayer bass1,rexS,brontoS,paraS,tegoS,triS;
SimpleOpenNI  openni;

Keystone ks;
CornerPinSurface surface;
HotRegion hot1, hot2,hot3,hot4,hot5,hot6, hotrex1,hotrex2,hotbronto1,hotbronto2,hotTri1,hotTri2, hotTego1,hotTego2,hotPara1,hotPara2;

PGraphics offscreen;
PImage background,image,mainImage,trex, bronto,Tri,stegossaurus,para,erva1;

PImage questionBronto0,  questionPara,  questionPtero0,  questionRex0, questionTego0,  questionTri0,
       questionBronto1,  questionParassa1, questionPtero1,  questionRex1,  questionTego1,  questionTri1,
       questionBronto2,  questionParassa2,  questionPtero2,  questionRex2,  questionTego2,  questionTri2;
       
PImage questionWrongBronto, questionWrongPara, questionWrongPtero, questionWrongStego, questionWrongTRex,questionWrongTri,questionRight,questionRight1,questionRight2,
questionRight3,questionRight4,gameover;



Timer startTimer,startTimer1;
int gameScreen = 0;
int currentRegion = 0;

boolean flag1 = true,
        flag3 = true,
        brontoQuestion = true,
        triQuestion = true,
        tegoQuestion = true,
        paraQuestion = true,
        flag4 = true,
        flag5 = true;
        
long lastTime = 0;
int dinosCount = 5;;
int score=0;
// ------Flags dos Dinos------ //
int flag2 = 0;
int brontoFlag = 0;
int triFlag = 0;
int tegoFlag = 0;
int paraFlag = 0;
// -------------------------- //
int cropLeft = 10; 
int cropRight = 10;
int cropTop = 10;
int cropBottom = 90;
boolean cropping = false;
float a = 405;
float a1 = 405;
float a2 = 405;
float a3 = 405;
float a4 = 405;
float a5 = 405;
float a6 = 405;
float a7 = 405;
float a8 = 405;
float a9 = 405;

int inteiro = 0;

SandboxCalibrator calibrator;

SandboxImageLayer terra, erva,pedras;
SandboxImageLayer imageLayer, catImageLayer, catShitImageLayer, brownImageLayer, springImageLayer;

void setup() {
  fullScreen(P3D, 2);
  openni = new SimpleOpenNI(this);
  if (openni.isInit() == false){
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }
  
  // Configs
  openni.enableDepth();
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(width, height, 20);
  ks.load();
  offscreen = createGraphics(width, height, P3D);
  //Isto foi comentado
  calibrator = new SandboxCalibrator();
    
    
  //-------------- Load das imagens do terreno ------//
  //terra = new SandboxImageLayer(loadImage("relva.jpg"), 0, 0, 600, 350, 785, 22);
  erva1 = loadImage("erva1.png");
  erva = new SandboxImageLayer(erva1, 0, 0, 600, 350, 780,1);
  //pedras = new SandboxImageLayer(loadImage("relva.jpg"), 0, 0, 600, 350, 785, 22);
  
  
  // -------------Load das imagens do dinos --------//
  trex = loadImage("T-Rex.png");
  bronto = loadImage("Bronto.png");
  para = loadImage("parassaurolofo.png");
  stegossaurus = loadImage("Stegossaurus.png");
  Tri = loadImage("Tri.png");
  
  questionBronto0 = loadImage("QuestionBronto.png");
  questionPara = loadImage("QuestionParassaurolofo.png");
  questionRex0 = loadImage("QuestionRex.png");
  questionTego0 = loadImage("Questionstego.png");
  questionTri0 = loadImage("QuestionTri.png");
  questionWrongBronto = loadImage("QuestionWrongBronto.png");
  questionWrongPara = loadImage("QuestionWrongPara.png");  
  questionWrongStego = loadImage("QuestionWrongStego.png");
  questionWrongTRex = loadImage("QuestionWrongT-Rex.png");
  questionRight = loadImage("T-RexRight.png");
  questionRight1 = loadImage("BrontoRight.png");
  questionRight2 = loadImage("TriRight.png");
  questionRight3 = loadImage("StegoRight.png");
  questionRight4 = loadImage("ParaRight.png");
  questionWrongTri = loadImage("QuestionWrongTri.png");
    
  // -------------Load das imagens de fundo --------//
  
  mainImage = loadImage("Menu.png");
  gameover = loadImage("MenuAcabar.png");
  // ------------------------------------------------//    
    
  // -------------Sounds and Music --------//
  minim = new Minim(this);
  bass1 = minim.loadFile("backgroundSound.mp3");
  rexS = minim.loadFile("rex.mp3");
  triS = minim.loadFile("tri.mp3");
  paraS = minim.loadFile("para.mp3");
  brontoS = minim.loadFile("bronto.mp3");
  tegoS = minim.loadFile("stego.mp3");
    
  //----------- Hots regions:------------------------//
  hotrex1 = new HotRegion("hotrex1",130,100,30,30,700);
  hotrex2 = new HotRegion("hotrex2",350,100,30,30,700); 
    
  hotbronto1 = new HotRegion("hotbronto1",220,135,30,30,700);
  hotbronto2 = new HotRegion("hotbronto2",455,135,30,30,700); 
        
  hotTri1 = new HotRegion("hotTri1",195,90,30,30,700);
  hotTri2 = new HotRegion("hotTri2",470,90,30,30,700); 
    
  hotTego1 = new HotRegion("hotTego1",220,109,30,30,700);
  hotTego2 = new HotRegion("hotTego2",500,109,30,30,700);
    
  hotPara1 = new HotRegion("hotPara1",240,85,30,30,700);
  hotPara2 = new HotRegion("hotPara2",500,85,30,30,700);
    
  hot1 = new HotRegion("hot 1",220,13,100,100,700); 
  hot2 = new HotRegion("hot 2",455,135,100,100,700); 
  
  
  //----------- Timer --------------/
  startTimer = new Timer(400);
  
  background(0);
}

void draw() {
  
  if (gameScreen == 0) {
    openni.update();
    calibrator.run(openni);
   
    // Draw the scene, offscreen
    offscreen.beginDraw();
    offscreen.image(erva1, 0, 0, width, height);
    offscreen.image(mainImage, 0, 0, width, height);
    
    // Regions are defined in the original image reference (640x480) so we need to scale them
    offscreen.pushMatrix();
    offscreen.scale(width*1.0/calibrator.depthImage.width, height*1.0/calibrator.depthImage.height);
    
    // Draw the square to start the game
    hot1.run(calibrator.depthImage, calibrator.realWorldMap);
    //hot1.draw(offscreen);
    
    offscreen.popMatrix();
    offscreen.endDraw();
    //background(0);
    surface.render(offscreen);
    initScreen();
  
    
  } else if (gameScreen == 1) {
    bass1.play();
    openni.update();
    calibrator.run(openni);
    
    offscreen.beginDraw();
    startTimer.countDown();
    gameScreen();
    
    int croppedWidth = (640);
    int croppedHeight = (480);
    
    /* Crop the depth map*/
    int depthMap[] = new int[croppedWidth * croppedHeight]; 
    for (int i = cropTop; i < 480-cropBottom; i++) {
      arrayCopy(openni.depthMap(), i*640+cropLeft, depthMap, (i-cropTop)*croppedWidth, croppedWidth);
    }

    /* Crop the 3D map*/
    PVector[] realWorldMap = new PVector[croppedWidth * croppedHeight]; 
    for (int i = cropTop; i < 480-cropBottom; i++) {
      arrayCopy(openni.depthMapRealWorld(), i*640+cropLeft, realWorldMap, (i-cropTop)*croppedWidth, croppedWidth);
    }

    /* Crop the depth image*/
    PImage depthImage = openni.depthImage().get(cropLeft, cropTop, 640-cropRight-cropLeft, 480-cropBottom-cropTop);


    // Draw the scene, offscreen
    offscreen.beginDraw();
    offscreen.image(erva1, 0, 0, width, height);

    if (cropping) {
    offscreen.stroke(#ff0000);
    offscreen.line(0, cropTop, width, cropTop);
    offscreen.line(0, height-cropBottom, width, height-cropBottom);
    offscreen.line(cropLeft, 0, cropLeft, height);
    offscreen.line(width-cropRight, 0, width-cropRight, height);
    } 

  
    // Regions are defined in the original image reference (640x480) so we need to scale them
    offscreen.pushMatrix();
    offscreen.scale(width*1.0/depthImage.width, height*1.0/depthImage.height);
    

    //--------- Cenário dinamico --------------//
     /*
    terra.run(depthImage, realWorldMap);
    terra.draw(offscreen);
    */
    //erva.run(depthImage, realWorldMap);
    //erva.draw(offscreen);
    /*
    pedras.run(depthImage, realWorldMap);
    pedras.draw(offscreen);
    */
    
      
    // If the player have already find all dinos then the game is over
    if(flag2 == 5 && brontoFlag == 5 && triFlag == 5 && paraFlag==5 &&  tegoFlag == 5){
       gameOverScreen();
    }
    
    // 1 if dino is already draw
    // 2 if the delay is completed
    if (flag2==1 || flag2==2) {
      if(flag2==1){
        dinosCount-=1;
        delay(1500);
        flag2=2;
      }
      
      offscreen.beginDraw();
      //offscreen.image(erva1, 0, 0, width, height);

      offscreen.background(0);
     
      // Question POP-UP 
      // DINO -> REX
      offscreen.image(erva1, 0, 0, width, height);
      offscreen.image(questionRex0, 0, 0, 640, 480); 
    
      hotrex1.run(calibrator.depthImage, calibrator.realWorldMap);
      hotrex1.draw(offscreen);
      hotrex2.run(calibrator.depthImage, calibrator.realWorldMap);
      hotrex2.draw(offscreen);
      
      if(hotrex1.isStable() && flag3 && hotrex1.getState() == HotRegionState.PARTLY_VISIBLE ){
        a= startTimer.getTime(); 
        flag3=false;
        
         
      }
      
      if(hotrex2.isStable() && flag3 && hotrex2.getState() == HotRegionState.PARTLY_VISIBLE ){ 
         a1= startTimer.getTime();
         flag3=false;  
        
      }
     
      if(!flag3 && hotrex1.getState() == HotRegionState.FULLY_VISIBLE  && startTimer.getTime() > a - 5 ){
        offscreen.beginDraw();
        offscreen.background(0);
        offscreen.image(erva1, 0, 0, width, height);
        offscreen.image(questionRight, 0, 0, 640, 480);
        offscreen.endDraw();
        
      } else if(!flag3 && hotrex2.getState() == HotRegionState.FULLY_VISIBLE && startTimer.getTime() > a1 - 5){
        offscreen.beginDraw();
        offscreen.background(0);
        offscreen.image(erva1, 0, 0, width, height);
        offscreen.image(questionWrongTRex, 0, 0, 640, 480);
        offscreen.endDraw();
      }
      
       if(startTimer.getTime() <= a - 5 && startTimer.getTime() <= a1 - 5 && !flag3){
        print("aqui");
        //if(!flag3 && hotrex1.isStable() && hotrex1.getState() == HotRegionState.FULLY_VISIBLE  && hotrex2.isStable() && hotrex2.getState() == HotRegionState.FULLY_VISIBLE){
        offscreen.beginDraw();
        offscreen.background(0);
        flag2=5;
        //}
       
       
       }
     
      
    }
    
    // DINO -> BRONTO
    if (brontoFlag==1 || brontoFlag==2) {
      if(brontoFlag ==1){
        dinosCount-=1;
        delay(1500);
        brontoFlag = 2;
      }
      
      offscreen.beginDraw();
      offscreen.background(0);
    
      offscreen.image(erva1, 0, 0, width, height);
      offscreen.image(questionBronto0, 0, 0, 640, 480); //"pop-up" da question 
      hotbronto1.run(calibrator.depthImage, calibrator.realWorldMap);
      hotbronto1.draw(offscreen);
      hotbronto2.run(calibrator.depthImage, calibrator.realWorldMap);
      hotbronto2.draw(offscreen);
      
      if(hotbronto1.isStable() && brontoQuestion && hotbronto1.getState() == HotRegionState.PARTLY_VISIBLE ){
         a2= startTimer.getTime();  
         brontoQuestion=false;     
      }
      
      if(hotbronto2.isStable() && brontoQuestion && hotbronto2.getState() == HotRegionState.PARTLY_VISIBLE ){
        a3= startTimer.getTime(); 
        brontoQuestion=false;  
      }
     
      if(!brontoQuestion && hotbronto1.getState() == HotRegionState.FULLY_VISIBLE && startTimer.getTime() > a2 - 5){
        offscreen.beginDraw();
        offscreen.background(0);
        offscreen.image(questionRight1, 0, 0, 640, 480);
        offscreen.endDraw();
      } else if(!brontoQuestion && hotbronto2.getState() == HotRegionState.FULLY_VISIBLE && startTimer.getTime() > a3 - 5){
        offscreen.beginDraw();
        offscreen.background(0);
        offscreen.image(questionWrongBronto, 0, 0, 640, 480);
        offscreen.endDraw();
        
      }
            
      //if(!brontoQuestion && hotbronto1.isStable() && hotbronto1.getState() == HotRegionState.FULLY_VISIBLE  && hotbronto2.isStable() && hotbronto2.getState() == HotRegionState.FULLY_VISIBLE){
        if(startTimer.getTime() <= a2 - 5 && startTimer.getTime() <= a3 - 5 && !brontoQuestion){
        offscreen.beginDraw();
        offscreen.background(0);
        brontoFlag=5;
      }   
     }
     
     // DINO -> Tri
     
   
     if (triFlag==1 || triFlag==2) {
      
      if(triFlag ==1){
        dinosCount-=1;
        delay(1500);
        triFlag = 2;
      }
      
      
      offscreen.beginDraw();
      offscreen.background(0);
    
      offscreen.image(erva1, 0, 0, width, height);
      offscreen.image(questionTri0, 0, 0, 640, 480); //"pop-up" da question 
      hotTri1.run(calibrator.depthImage, calibrator.realWorldMap);
      hotTri1.draw(offscreen);
      hotTri2.run(calibrator.depthImage, calibrator.realWorldMap);
      hotTri2.draw(offscreen);
      
      if(hotTri1.isStable() && triQuestion && hotTri1.getState() == HotRegionState.PARTLY_VISIBLE ){
         a4= startTimer.getTime();  
         triQuestion=false;
          
      }
      
      if(hotTri2.isStable() && triQuestion && hotTri2.getState() == HotRegionState.PARTLY_VISIBLE ){ 
        a5= startTimer.getTime();   
        triQuestion=false;  
      }
     
      if(!triQuestion && hotTri1.getState() == HotRegionState.FULLY_VISIBLE && startTimer.getTime() > a4 - 5 ){
        offscreen.beginDraw();
        offscreen.background(0);
        offscreen.image(questionRight2, 0, 0, 640, 480);
        offscreen.endDraw();
      } else if(!triQuestion && hotTri2.getState() == HotRegionState.FULLY_VISIBLE && startTimer.getTime() > a5 - 5){
        offscreen.beginDraw();
        offscreen.background(0);
        offscreen.image(questionWrongTri, 0, 0, 640, 480);
        offscreen.endDraw();
      }
        
        if(startTimer.getTime() <= a4 - 5 && startTimer.getTime() <= a5 - 5 && !triQuestion){     
      //if(!triQuestion && hotTri1.isStable() && hotTri1.getState() == HotRegionState.FULLY_VISIBLE  && hotTri2.isStable() && hotTri2.getState() == HotRegionState.FULLY_VISIBLE){
        offscreen.beginDraw();
        offscreen.background(0);
        triFlag=5;
      }
      
     }
    
    // DINO -> Stego
     if (tegoFlag==1 || tegoFlag==2) {
      
      if(tegoFlag ==1){
        dinosCount-=1;
        delay(1500);
        tegoFlag = 2;
      }
      
      
      offscreen.beginDraw();
      offscreen.background(0);
    
      offscreen.image(erva1, 0, 0, width, height);
      offscreen.image(questionTego0, 0, 0, 640, 480); //"pop-up" da question 
      hotTego1.run(calibrator.depthImage, calibrator.realWorldMap);
      hotTego1.draw(offscreen);
      hotTego2.run(calibrator.depthImage, calibrator.realWorldMap);
      hotTego2.draw(offscreen);
      
      if(hotTego1.isStable() && tegoQuestion && hotTego1.getState() == HotRegionState.PARTLY_VISIBLE ){
        a6= startTimer.getTime();  
        tegoQuestion=false;      
      }
      
      if(hotTego2.isStable() && tegoQuestion && hotTego2.getState() == HotRegionState.PARTLY_VISIBLE ){
        a7= startTimer.getTime();  
        tegoQuestion=false;  
      }
     
      
      if(!tegoQuestion && hotTego1.getState() == HotRegionState.FULLY_VISIBLE && startTimer.getTime() > a6 - 5 ){
        offscreen.beginDraw();
        offscreen.background(0);
        offscreen.image(questionRight3, 0, 0, 640, 480);
        offscreen.endDraw();
      } else if(!tegoQuestion && hotTego2.getState() == HotRegionState.FULLY_VISIBLE && startTimer.getTime() > a7 - 5){
        offscreen.beginDraw();
        offscreen.background(0);
        offscreen.image(questionWrongStego, 0, 0, 640, 480);
        offscreen.endDraw();
      }
            
      //if(!tegoQuestion && hotTego1.isStable() && hotTego1.getState() == HotRegionState.FULLY_VISIBLE  && hotTego2.isStable() && hotTego2.getState() == HotRegionState.FULLY_VISIBLE){
      if(startTimer.getTime() <= a6 - 5 && startTimer.getTime() <= a7 - 5 && !tegoQuestion){  
        offscreen.beginDraw();
        offscreen.background(0);
        tegoFlag=5;
      }   
     }
    
    // DINO -> Para
    
    if (paraFlag==1 || paraFlag==2) {
      
      if(paraFlag ==1){
        dinosCount-=1;
        delay(1500);
        paraFlag = 2;
      }
      
      
      offscreen.beginDraw();
      offscreen.background(0);
    
      offscreen.image(erva1, 0, 0, width, height);
      offscreen.image(questionPara, 0, 0, 640, 480); //"pop-up" da question 
      hotPara1.run(calibrator.depthImage, calibrator.realWorldMap);
      hotPara1.draw(offscreen);
      hotPara2.run(calibrator.depthImage, calibrator.realWorldMap);
      hotPara2.draw(offscreen);
      
      if(hotPara1.isStable() && paraQuestion && hotPara1.getState() == HotRegionState.PARTLY_VISIBLE ){
        a8= startTimer.getTime(); 
        paraQuestion=false;    
      }
      
      if(hotPara2.isStable() && paraQuestion && hotPara2.getState() == HotRegionState.PARTLY_VISIBLE ){
        a9= startTimer.getTime();  
        paraQuestion=false;  
      }
     
      if(!paraQuestion && hotPara1.getState() == HotRegionState.FULLY_VISIBLE && startTimer.getTime() > a8 - 5 ){
        offscreen.beginDraw();
        offscreen.background(0);
        offscreen.image(questionRight4, 0, 0, 640, 480);
        offscreen.endDraw();
      } else if(!paraQuestion && hotPara2.getState() == HotRegionState.FULLY_VISIBLE && startTimer.getTime() > a9 - 5  ){
        offscreen.beginDraw();
        offscreen.background(0);
        offscreen.image(questionWrongPara, 0, 0, 640, 480);
        offscreen.endDraw();
      }
            
      //if(!paraQuestion && hotPara1.isStable() && hotPara1.getState() == HotRegionState.FULLY_VISIBLE  && hotPara2.isStable() && hotPara2.getState() == HotRegionState.FULLY_VISIBLE){
      if(startTimer.getTime() <= a8 - 5 && startTimer.getTime() <= a9 - 5 && !paraQuestion){  
        offscreen.beginDraw();
        offscreen.background(0);
        paraFlag=5;
      } 
     }
   
    offscreen.popMatrix();

    /*
    // Show depth of the cursor point
    PVector surfaceMouse = surface.getTransformedMouse();
    int mX = (int)map(surfaceMouse.x, 0, width-1, 0, calibrator.croppedWidth-1);
    mX = constrain(mX, 0, calibrator.croppedWidth-1);
    int mY = (int)map(surfaceMouse.y, 0, height-1, 0, calibrator.croppedHeight-1);
    mY = constrain(mY, 0, calibrator.croppedHeight-1);
    // println(mX, mY, red(depthImage.pixels[mY*depthImage.width+mX]));
    offscreen.stroke(0, 0, 255);
    offscreen.strokeWeight(5);
    offscreen.noFill();
    offscreen.ellipse(surfaceMouse.x, surfaceMouse.y, 75, 75);
    offscreen.fill(255, 0, 0);
    offscreen.textSize(63);
    offscreen.text(""+calibrator.realWorldMap[mY*calibrator.croppedWidth+mX].z, surfaceMouse.x, surfaceMouse.y);
    */
    offscreen.endDraw();
    //erva = new SandboxImageLayer(erva1, 0, 0, 600, 350, 780,22);
    background(0);
    surface.render(offscreen);
    
    float aux = realWorldMap[110*croppedWidth+535].z;
    float aux1 = realWorldMap[65*croppedWidth+45].z;
    float aux2 = realWorldMap[115*croppedWidth+240].z;
    float aux3 = realWorldMap[230*croppedWidth+90].z;
    float aux4 = realWorldMap[230*croppedWidth+555].z;
    
    //flag2 = 1 ->dinossauro descoberto
     
   
    if (aux >772 && aux <780 && flag2==0) {
      image(trex, 955, 120, 240, 240);
      rexS.play();
    
      flag2=1;
     }
    
    //canto superior esquerdo
    if(aux1 >785 && aux1 < 790 && brontoFlag==0){
      image(bronto, 85, 90, 240, 240);
      brontoS.play();
      brontoFlag=1;
    }
    //meio
    if(aux2 >778 && aux2 <788  && triFlag==0){
      image(Tri, 475, 230, 240, 240);
      triS.play();
      triFlag = 1;  
    }
     
    //canto esquerdo baixo
    if(aux3 >779 && aux3 < 789 && tegoFlag == 0){
      image(stegossaurus, 120, 460, 240, 240);
      tegoS.play();
      tegoFlag = 1;
    }
     
    if(aux4 > 780 && aux4 < 790 && paraFlag == 0){
      image(para, 920, 440, 260, 255);
      paraS.play();
      paraFlag = 1;
    }
      
    String sf = nf(startTimer.getTime(), 1, 1);
    textAlign(CENTER);
    textSize(38);
    text("Tempo: "+sf,1000,118);
    textSize(38);
    text("Dinossauros por encontrar: "+dinosCount,400,118);
    //text("SCORE:"+score+ " ",900,40);
    fill(0); 
    if(startTimer.getTime() <= 0){
      gameOverScreen();
    }
  } else if (gameScreen == 2) {
    gameOverScreen();
   
  }
    
}

void initScreen() {
  
 
  if (hot1.isStable() && hot1.getState() == HotRegionState.PARTLY_VISIBLE) {
    gameScreen= 1;
  }
  
}

void gameScreen() {
  //background(255);
  bass1.play();
}

void gameOverScreen() {    
      
       offscreen.image(gameover, 0, 0, 620, 400);
    
       bass1.close();
       hot2.run(calibrator.depthImage, calibrator.realWorldMap);
       if (hot2.isStable() && hot2.getState() == HotRegionState.PARTLY_VISIBLE) {
        flag2 = 0;
        brontoFlag = 0;
        triFlag = 0;
        tegoFlag = 0;
        paraFlag = 0;
        dinosCount = 5;
        flag1 = true;
        flag3 = true;
        brontoQuestion = true;
        triQuestion = true;
        tegoQuestion = true;
        paraQuestion = true;
        flag4 = true;
        flag5 = true;
        offscreen.beginDraw();
        background(0);
        gameScreen= 0 ;
        startTimer.setTime(400);
        
       }
  // codes for game over screen
  
}
