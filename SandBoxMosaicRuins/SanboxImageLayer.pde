class SandboxImageLayer {

  PImage image;
  PImage mask;
  int x, y, w, h;

  int depth;
  int threshold;

  public SandboxImageLayer(PImage image, int x, int y, int w, int h, int depth, int threshold) {
    this.image = image;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.depth = depth;
    this.threshold = threshold;
  }

  public void draw(PGraphics g) {
    image.mask(mask);
    g.image(image, x, y, w, h);
    // g.image(mask, x, y, w, h);
    g.strokeWeight(1);
    g.noFill();
    g.stroke(255);
    g.rect(x, y, w, h);
  }

  public void run(PImage depthImage, PVector []map3D) {
    mask = new PImage(w, h, RGB);

    for (int i = y; i < y+h; i++) {
      for (int j = x; j < x+w; j++) {
        //int v = (int)red(depth.pixels[i*depth.width+j]);
        float v = map3D[i*depthImage.width+j].z;

        if (Math.abs(v-depth) < threshold) {
          //println(v);
          mask.pixels[(i-y)*w+(j-x)] = color(255);
        }
      }
    }
    mask.resize(image.width, image.height);
  }
}
