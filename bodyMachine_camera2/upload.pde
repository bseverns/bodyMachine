
class TumblrWrite {
  MultipartPostMethod method;
  HttpClient client;

  String tumblrApiUrl = "http://tumblr.com/api/write";

  //CONSTRUCTOR
  TumblrWrite() throws IOException {
    client = new HttpClient();
  }

  void init(String userEmail, String userPassword) {
    method = new MultipartPostMethod(tumblrApiUrl);
    method.addParameter("email", userEmail);
    method.addParameter("password", userPassword);
  }



  //PHOTO-DATA - Uploads a photo from specified filepath
  void photoDataPost(String caption, String filePath, String clickThroughUrl) throws FileNotFoundException {
    System.out.println("Uploading a photo...");

    File img = new File(filePath);
    method.addParameter("type", "photo");
    method.addParameter("data", img);
    method.addParameter("caption", caption);
    method.addParameter("click-through-url", clickThroughUrl);
  }
}

void upload() {
  //A custom string to appear in the post's URL: myblog.tumblr.com/post/123456/this-string-right-here.
  //Max 55 characters
setSlug(String);
  


}

  void setSlug(String slug) {
    method.addParameter("Make it Move", MiM);
  }  

  // One of the following values: published, draft, submission, queue, publish-on=YYYY-MM-DDT13:34:00
  void setPostState(String state) {
    method.addParameter("published", published);
  }
  

    //PHOTO-DATA - Uploads a photo from specified filepath
  void photoDataPost(String caption, String filePath, String clickThroughUrl) throws FileNotFoundException {
    System.out.println("Uploading a photo...");

    File img = new File(filePath);
    method.addParameter("type", "photo");
    method.addParameter("data", img);
    method.addParameter("caption", caption);
    method.addParameter("click-through-url", clickThroughUrl);
  }

void sendData() throws IOException {
    try {
      client.executeMethod(method);
      String response = method.getResponseBodyAsString();
      System.out.println(response);
      method.releaseConnection();
    }
    catch(IOException e) {
      e.printStackTrace();
    }
  }
