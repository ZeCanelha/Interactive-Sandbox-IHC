class SandboxCalibrator {

    int croppedWidth, croppedHeight, cropTop = 0, cropRight = 0, cropBottom = 0, cropLeft = 0;

    float angleZCalibration;
    float angleXCalibration;

    int depthMap[];
    PVector realWorldMap[];
    PImage depthImage;


    SandboxCalibrator() {
        load();
    }

    void load() {
        String[] config = loadStrings("config.txt");
        println("Loaded config:");
        println(config);
        cropTop = int(config[0]);
        cropRight = int(config[1]);
        cropBottom = int(config[2]);
        cropLeft = int(config[3]);
        croppedWidth = (640-cropLeft-cropRight);
        croppedHeight = (480-cropBottom-cropTop);

        angleXCalibration = float(config[4]);
        angleZCalibration = float(config[5]);
    }

    void run(SimpleOpenNI openni) {



        /* Crop the depth map*/
        depthMap = new int[croppedWidth * croppedHeight]; 
        for (int i = cropTop; i < 480-cropBottom; i++) {
            arrayCopy(openni.depthMap(), i*640+cropLeft, depthMap, (i-cropTop)*croppedWidth, croppedWidth);
        }

        /* Crop the 3D map*/
        realWorldMap = new PVector[croppedWidth * croppedHeight]; 
        for (int i = cropTop; i < 480-cropBottom; i++) {
            arrayCopy(openni.depthMapRealWorld(), i*640+cropLeft, realWorldMap, (i-cropTop)*croppedWidth, croppedWidth);
        }

        /* Crop the depth image*/
        depthImage = openni.depthImage().get(cropLeft, cropTop, 640-cropRight-cropLeft, 480-cropBottom-cropTop);

        /* rotate 3d coord*/

        for (int i = 0; i < realWorldMap.length; i++) {
            PVector v = new PVector(realWorldMap[i].y, realWorldMap[i].z);
            v.rotate(angleXCalibration);
            realWorldMap[i].z = v.y;
            realWorldMap[i].y = v.x;

            v = new PVector(realWorldMap[i].x, realWorldMap[i].z);
            v.rotate(angleZCalibration);
            realWorldMap[i].z = v.y;
            realWorldMap[i].x = v.x;
        }
    }
}
