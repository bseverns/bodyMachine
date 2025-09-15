import oscP5.*; //<>// //<>//
import netP5.*;
import processing.video.*;
import javax.imageio.*;
import java.awt.image.*;
import com.aetrion.flickr.*;

// Fill in your own apiKey and secretKey values.
String apiKey = "7c7975d60817651b557d14c1c784eba3";
String secretKey = "02040d60c3e33e75";

Flickr flickr;
Uploader uploader;
Auth auth;
String frob = "";
String token = "";

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

  // Set up Flickr.
  flickr = new Flickr(apiKey, secretKey, (new Flickr(apiKey)).getTransport());

  // Authentication is the hard part.
  // If you're authenticating for the first time, this will open up
  // a web browser with Flickr's authentication web page and ask you to
  // give the app permission. You'll have 15 seconds to do this before the Processing app
  // gives up waiting fr you.

  // After the initial authentication, your info will be saved locally in a text file,
  // so you shouldn't have to go through the authentication song and dance more than once
  authenticate();

  // Create an uploader
  uploader = flickr.getUploader();

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
