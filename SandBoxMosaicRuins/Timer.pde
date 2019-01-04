class Timer{
  
  float Time;
  
  Timer(float set){
    Time = set;
  }
  
  float getTime(){
    return (Time);
  }
  
  void setTime(float set){
    Time = set;
  }
  
  void countUp(){
    Time += 1/frameRate;
  }
  
  void countDown(){
    Time -= 1/frameRate;
  }
}
