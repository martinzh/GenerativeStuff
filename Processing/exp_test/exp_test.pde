// ============================== //// ============================== //
// Experimento sencillo con tipografias
// creacion inteligente
// Martin Zumaya Hernandez
// 21 - Feb - 2017
// ============================== //// ============================== //


// import the required libraries
import processing.pdf.*;        // library for PDF export
import geomerative.*;           // library for text manipulation and point extraction

float nextPointSpeed = 0.35;    // speed at which the sketch cycles through the points
boolean saveOneFrame = false;   // variable used to save a single frame as a PDF page
RShape shape;                   // holds the base shape created from the text
RPoint[][] allPaths;            // holds the extracted points

int f_size = 250;
int w = 10;

int cont = 0;
float prob = 0.2;
float prob_line = 0.75;
float max_Dist = 125;

// ============================== //// ============================== //

void setup() {
    size(1280, 720);
    // size(800, 720);
    frameRate(10);

    // initialize the Geomerative library
    RG.init(this);

    // create font used by Geomerative
    RFont font = new RFont("./data/FreeSans.ttf", f_size);
    // RFont font = new RFont("./data/SharpSansDispNo2-Bold.ttf", f_size);

    // create base shape from text using the loaded font

    // shape = font.toShape("CREACIÓN");
    // shape = font.toShape("creación");

    // shape = font.toShape("INTELIGENTE");
    shape = font.toShape("inteligente");

    // shape = font.toShape("test");

    // center the shape in the middle of the screen
    shape.translate(width/2 - shape.getWidth()/2, height/2 + shape.getHeight()/2);

    // set Segmentator (read: point retrieval) settings
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH); // use a uniform distance between points
    RCommand.setSegmentLength(10); // set segmentLength between points

    // extract paths and points from the base shape using the above Segmentator settings
    allPaths = shape.getPointsInPaths();
}

void draw() {
    // begin recording to PDF
    if (saveOneFrame == true) {
        beginRecord(PDF, "UsingGeomerative-" + timestamp() + ".pdf");
    }

    // clear the background
    background(255);

// ============================== //// ============================== //
// VARIATION 1
// ============================== //// ============================== //

    // draw the extracted points as black points
    // stroke(0);
    // strokeWeight(2);

    // beginShape(POINTS);
    // for (RPoint[] singlePath : allPaths) {
    //     for (RPoint p : singlePath) {
    //         vertex(p.x, p.y);
    //         //   ellipse(p.x, p.y, w, w);
    //     }
    // }
    // endShape();
    //
    // // draw thin transparant lines between two points within a path (a letter can have multiple paths)
    // // dynamically set the 'opposite' point based on the current frameCount
    // int fc = int(frameCount * nextPointSpeed);
    // // int fc = int(cont * nextPointSpeed);
    //
    // stroke(0, 125);
    // strokeWeight(0.75);
    //
    // for (RPoint[] singlePath : allPaths) {
    //     beginShape(LINES);
    //     for (int i=0; i<singlePath.length; i++) {
    //         RPoint p = singlePath[i];
    //         vertex(p.x, p.y);
    //         RPoint n = singlePath[(fc+i)%singlePath.length];
    //         vertex(n.x, n.y);
    //     }
    //     endShape();
    // }

// ============================== //// ============================== //
// VARIATION 2
// ============================== //// ============================== //

    for (RPoint[] singlePath : allPaths) {
        for (RPoint p : singlePath) {
            if(random(0, 1.0) <= prob){
                stroke(0, 150 + randomGaussian()*20);
                strokeWeight(1.5 + randomGaussian()*0.25);
                int ww = 10 + int(randomGaussian()*10);
                ellipse(p.x, p.y, ww, ww);
            }
        }
    }

    for (RPoint[] singlePath : allPaths) {
        beginShape(LINES);
        for (int i=0; i < singlePath.length; i++) {

            stroke(0, 150 + randomGaussian()*20);
            strokeWeight(1.0 + randomGaussian()*0.15);

            RPoint p = singlePath[i];
            int j = (i + int(random(0, 10))) % singlePath.length;
            RPoint n = singlePath[j];
            if( pow((p.x-n.x),2) + pow((p.y-n.y),2) < pow(max_Dist,2)){
                vertex(p.x, p.y);
                vertex(n.x, n.y);
            }
        }
        endShape();
    }

// ============================== //// ============================== //

    // end recording to PDF
    if (saveOneFrame) {
    endRecord();
    saveOneFrame = false;
    }
}

// ============================== //// ============================== //

void keyPressed() {
  if (key == 's') {
      saveOneFrame = true; // set the variable to true to save a single frame as a PDF file / page
  }
}

// ============================== //// ============================== //

String timestamp() {
  return year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
}
