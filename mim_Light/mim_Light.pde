import ddf.minim.*;
import processing.video.*;
import processing.serial.*;


Minim minim;
AudioPlayer player;

int numPixels;
int[] backgroundPixels;
Capture video;
int presenceSum = 0;
int tripCount = 0;

Serial port;

void setup() {

  size(640, 480); 

  printArray(Serial.list());
  String arduinoPort = Serial.list()[1]; 

  port = new Serial(this, arduinoPort, 9600); // connect to Arduino

  minim = new Minim(this);
  player = minim.loadFile("Sp_1.mp3");
  player.loop();

  video = new Capture(this, width, height);
  numPixels = video.width * video.height;
  // Create array to store the background image
  video.start();

  backgroundPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  loadPixels();

  frameRate(10);
}

void draw() {
  if (video.available()) {
    video.read(); // Read a new video frame
    video.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...

      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = video.pixels[i];
      color bkgdColor = backgroundPixels[i];

      // Extract the red, green, and blue components of the current pixelÕs color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;

      // Extract the red, green, and blue components of the background pixelÕs color
      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;

      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - bkgdR);
      int diffG = abs(currG - bkgdG);
      int diffB = abs(currB - bkgdB);

      // Add these differences to the running tally
      presenceSum += diffR + diffG + diffB;

      // Render the difference image to the screen
      pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }

    updatePixels(); // Notify that the pixels[] array has changed
    //println(presenceSum*0.00001); // Print out the total amount of movement
  } 
  if (presenceSum*0.00001 > 75) {
    lightsOff();
  } else if (presenceSum*0.00001 < 75) {
    lightsOn();
  }
}

void lightsOff() {
  //if (tripCount > 2) {
  port.write(255);
  println("off");

  player.play();
}
/*else {
 tripCount++;
 }*/


void lightsOn() {
  port.write(0);
  println("on");
  player.pause();

  resetBG();
}

void resetBG() {
  video.loadPixels();
  arraycopy(video.pixels, backgroundPixels);
  presenceSum = 0;
  tripCount = 0;
}