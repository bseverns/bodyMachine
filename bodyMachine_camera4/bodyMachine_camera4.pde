import oscP5.*;
import netP5.*;
import processing.video.*;

Capture video;
int numPixels;
int[] backgroundPixels;

OscP5 oscP5;
NetAddress kinectLight;
NetAddress photoBooth;

boolean lights = false;

void setup() {
  size(320, 240);

  video = new Capture(this, 320, 240);
  // Start capturing the images from the camera
  video.start();  

  oscP5 = new OscP5(this, 12000);
  kinectLight = new NetAddress("127.0.0.1", 12000);
  photoBooth = new NetAddress("127.0.0.1", 7200);

  numPixels = video.width * video.height;
  // Create array to store the background image
  backgroundPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  loadPixels();
  background(0);
}

void draw() {
  if (video.available()) {
    video.read(); // Read a new video frame
    video.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    int presenceSum = 0;
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = video.pixels[i];
      color bkgdColor = backgroundPixels[i];
      // Extract the red, green, and blue components of the current pixel's color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixel's color
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
      //pixels[i] = color(diffR, diffG, diffB);
      // The following line does the same thing much faster, but is more technical
      pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }
    updatePixels(); // Notify that the pixels[] array has changed
    println(presenceSum); // Print out the total amount of movement
  }
}

/* incoming osc message are forwarded to the oscEvent method. */
//just in case max wants to send us a message
void oscEvent(OscMessage theOscMessage) {

  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  theOscMessage.get(0).intValue(); 
  if (theOscMessage.get(0).intValue()==1) {
    lights = true;
  }
  if (lights == true) {
    saveFrame();
    image(video, 0, 0);
    // When a key is pressed, capture the background image into the backgroundPixels
    // buffer, by copying each of the current frame's pixels into it.
    video.loadPixels();
    arrayCopy(video.pixels, backgroundPixels);
  }
}
