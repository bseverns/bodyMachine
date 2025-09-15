 //<>//
import oscP5.*; //<>//
import netP5.*;
import processing.video.*;
import javax.imageio.*;
import java.io.IOException;
import java.awt.image.*;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.methods.MultipartPostMethod;
import org.apache.commons.httpclient.methods.multipart.FilePart;

TumblrWrite tumblrWrite;
File[] imageFilesToUpload;
final String username = "username@mail.com";
final String password = "password";

Capture video;
int numPixels;
int[] backgroundPixels;

OscP5 oscP5;
NetAddress kinectLight;
NetAddress photoBooth;

boolean lights = false;
boolean uploading = false;

void setup() {
  size(320, 240);
  video = new Capture(this, 320, 240);

  oscP5 = new OscP5(this, 12000);
  kinectLight = new NetAddress("/*kinect iP*/", 12000);
  photoBooth = new NetAddress("/*this iP*/", 12000);

  // Start capturing the images from the camera
  video.start();  


  try {
    tumblrWrite = new TumblrWrite();
  }
  catch(IOException e) {
    e.printStackTrace();
  }
  imageFilesToUpload = new File(sketchPath, "data").listFiles();


  numPixels = video.width * video.height;
  // Create array to store the background image
  backgroundPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  loadPixels();
  background(0);
}

void draw() {
  capture();
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
    saveFrame("######.jpg");
    image(video, 0, 0);
    uploading = true;
    // When a key is pressed, capture the background image into the backgroundPixels
    // buffer, by copying each of the current frame's pixels into it.
    video.loadPixels();
    arrayCopy(video.pixels, backgroundPixels);
  }
  if (uploading == true) {
    upload();
  }
}
