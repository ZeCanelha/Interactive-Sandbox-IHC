class HotRegion {

    int FRAMES = 10;

    int THRESHOLD = 35; //+- 5mm
    SandboxImageLayer image;
    boolean VERBOSE = false;

    String name;
    int x, y, w, h;
    int depth;

    float currentMax, currentMin, currentAvg;


    float avgHeights[] = new float[FRAMES];
    int avgHeightsIndex = 0;
    float sumDifSq;

    HotRegionState state = HotRegionState.FULLY_HIDDEN;

    public HotRegion( String name, int x, int y, int w, int h, int depth) {

        this.name = name;

        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.depth = depth;
    }
    
     public HotRegion(SandboxImageLayer image, int x, int y, int w, int h, int depth) {

        this.image = image;

        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.depth = depth;
    }


    public void draw(PGraphics g) {
        //println(isActive);
        g.pushStyle();
        if (state == HotRegionState.FULLY_VISIBLE) {
            g.noStroke();
            g.fill(0, 255, 0);
        } else if (state == HotRegionState.FULLY_HIDDEN) {
            g.stroke(255, 0, 0);
            g.noFill();
        } else {
            g.stroke(0, 255, 0);
            g.noFill();
        }
        //g.fill(#231233);
        g.rect(x, y, w, h);
        if (VERBOSE) {
            g.textSize(20);
            g.fill(255);
            String t = depth+"  "+int(currentMin) + "  " + int(currentMax) + "  " + int(currentAvg);
            g.text(t, x+w/2-textWidth(t)/2, y+h+20);
        }
        g.popStyle();
    }

    public void run(PImage depthImage, PVector []map3D) {
        float min = 2560, max=0, avg=0;
        int sum = 0;
        for (int i = y; i < y+h; i++) {
            for (int j = x; j < x+w; j++) { 
                //if (depthImage.pixels[i*depthImage.width+j] == 0 )continue;
                float v = map3D[i*depthImage.width+j].z;
                sum += v;
                if ( v < min ) {
                    min = v;
                }
                if ( v > max ) {
                    max = v;
                }
            }
        }
        avg = sum/(w*h);
        currentMax = max;
        currentMin = min;
        currentAvg = avg;
        avgHeights[avgHeightsIndex]=avg;
        avgHeightsIndex = (avgHeightsIndex+1)%avgHeights.length;

        // check stability
        float avgAvg = 0;
        for (int i = 0; i < avgHeights.length; i++) {
            avgAvg += avgHeights[i];
        }
        avgAvg /= avgHeights.length;
        sumDifSq = 0;
        for (int i = 0; i < avgHeights.length; i++) {
            sumDifSq += (avgHeights[i]-avgAvg)*(avgHeights[i]-avgAvg);
        }


        //if stable
        if (isStable()) {
            if (currentMax < depth) {
                state = HotRegionState.FULLY_HIDDEN;
            } else if (currentMin > depth+1) {
                state = HotRegionState.FULLY_VISIBLE;
            } else {
                state = HotRegionState.PARTLY_VISIBLE;
            }
        }
    }

    boolean isStable() {
        return sumDifSq < 1000;
    }

    HotRegionState getState() {
        return this.state;
    }

    float getAverageDepth() {
        return this.currentAvg;
    }
}

public enum HotRegionState {
    FULLY_VISIBLE, FULLY_HIDDEN, PARTLY_VISIBLE
}
