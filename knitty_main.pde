// Don't forget to place the libraries under sketchbook/libraries/G4P and sketchbook/libraries/sDrop
import g4p_controls.*;    // http://sourceforge.net/projects/g4p/
import sojamo.drop.*;    //  http://www.sojamo.de/libraries/drop/

PImage knittyLogoImage;
PImage patternImage;  // Declare PImage
PImage patternImageWorkingSet;
String myPattern = "";

int totalWidth = 180; //all needles
int workingWidth = 100; // number of working needles
int scalingfactor = 6; //display one pixel x scalingfactor
int rows = 120;
int columns = 180;
int displayWorkingRow = 90;
int gridStartX = 114;
int gridStartY = 90;

boolean  knittigInProgress = false;
boolean  SetBorderToggle = false;

String patternImageName = "spaceinvader_03.gif";
//backspace_text


int movePatternX = 0;
int movePatternY = 0;

int patternScaleX = 1;
int patternScaleY = 1;

int patternGridX = 1;
int patternGridY = 1;
int patternGridXgap = 0;
int patternGridYgap = 0;

boolean mirrorPatternArray1 = false;
boolean mirrorPatternArray2 = false;

int backgroundColour = 240;
int headerColour = 240;
int workingAreaColour = 200;
int displayWorkingRowColour = 170;
int blackColour = 0;

int GP4colorScheme = 6;
int GP4colorSchemeActive = 0;


int mouseOffsetX = 0;
int mouseOffsetY = 0;
int mouseStartX;
int mouseStartY;
int mousePatternStartX;
int mousePatternStartY;
boolean mouseLocked = false;

boolean GUIlocked = false;


GButton  btnOpenPatterImageFile,
         btnKnitInvers,
         btnPatternImageMirror,
         btnKnitStart,
         btnOneRowBack,
         btnKnitOneRow,
         btnKnitPause,
         btnPatternScaleYplus,
         btnPatternScaleYminus,
         btnPatternScaleXplus,
         btnPatternScaleXminus,
         btnPatternGridYplus,
         btnPatternGridYminus,
         btnPatternGridXplus,
         btnPatternGridXminus,
         btnPatternGridGapYplus,
         btnPatternGridGapYminus,
         btnPatternGridGapXplus,
         btnPatternGridGapXminus,
         btnSetWorkingWidth,
         btnSetCursor,
         btnSetBorder,
         btnConnectArduino,
         btnMirrorPatternArray1,
         btnMirrorPatternArray2;


GLabel  btnPatternScaleText,
        btnPatternText,
        btnPatternGridText,
        btnPatternGridGapText,
        btnSetWorkingWidthText,
        btnSetCursorText;

GTextField  txtfieldWorkingWidth,
            txtfieldSetCursor;

GTextArea txaInformationBox;

SDrop drop;  //drop pictures


void setup() {
    size(1200,700 );
    // The image file must be in the data folder of the current sketch
    // to load successfully

    loadPatternImage(patternImageName);

    //load Logo
    knittyLogoImage = loadImage("knitty_logo_80px.gif");

    displayButtonsGUI(); //GUI tab



    drop = new SDrop(this);
}

void draw() {

    parserSerialStream();

    background(backgroundColour);


    drawWorkingArea();
    drawPattern();
    drawGrid();

    //clear when knitting
    if (GUIlocked == true) {
        // clear header
        fill(blackColour);
        rect(0,gridStartY,gridStartX,height);

    }

}

void loadPatternImage(String patternImageName) {

    patternImage = loadImage(patternImageName);  // Load the image into the program
    patternImageWorkingSet = loadImage(patternImageName);  // Load the image into the program
    makePatternImageTransparent();

    mirrorPatternImageX();

    movePatternX = 0;
    movePatternY = 0;

}



void drawPattern() {
    /*   for( int i=0; i < patternGridX; i++ ){
         for(int j=0; j < patternGridY; j++){

         pushMatrix();
         translate((movePatternX-i*patternGridXgap)*scalingfactor-((i*patternImage.width*scalingfactor+scalingfactor)*patternScaleX),((movePatternY-j*patternGridYgap)*scalingfactor-((j*patternImage.height*scalingfactor+scalingfactor)*patternScaleY)));
         image(patternImage, gridStartX+(totalWidth/2-patternImage.width/2+1)*scalingfactor, gridStartY+(displayWorkingRow-patternImage.height+2)*scalingfactor, patternImage.width*scalingfactor*patternScaleX, patternImage.height*scalingfactor*patternScaleY);
         noSmooth();
         popMatrix();
         }
         }
     */


    for(int j=0; j < patternGridY; j++) {
        for( int i=0; i < patternGridX; i++ ) {

            //mirror pattern in array
            if(mirrorPatternArray1 == true) {
                if(i % 2 == 0) {
                    if(j % 2 == 0) {
                        mirrorPatternImageX();
                    }
                    if(j % 2 != 0 && mirrorPatternArray2 == true) {
                        mirrorPatternImageX();
                    }

                } else {
                    if(j % 2 != 0 && mirrorPatternArray2 == false) {
                        mirrorPatternImageX();
                    }
                }
            }

            //place pattern in array
            pushMatrix();
            translate((movePatternX+i*patternGridXgap)*scalingfactor+((i*patternImage.width*scalingfactor+scalingfactor)*patternScaleX),((movePatternY-j*patternGridYgap)*scalingfactor-((j*patternImage.height*scalingfactor+scalingfactor)*patternScaleY)));
            image(patternImage, gridStartX+(totalWidth/2-patternImage.width/2+1)*scalingfactor, gridStartY+(displayWorkingRow-patternImage.height+2)*scalingfactor, patternImage.width*scalingfactor*patternScaleX, patternImage.height*scalingfactor*patternScaleY);
            noSmooth();
            popMatrix();

            //demirror pattern in array
            if(mirrorPatternArray1 == true) {
                if(i % 2 == 0) {
                    if(j % 2 == 0) {
                        mirrorPatternImageX();
                    }
                    if(j % 2 != 0 && mirrorPatternArray2 == true) {
                        mirrorPatternImageX();
                    }

                } else {
                    if(j % 2 != 0 && mirrorPatternArray2 == false) {
                        mirrorPatternImageX();
                    }
                }
            }



        }
    }

}

void drawWorkingArea() {
    //draw workingArea
    pushMatrix();
    translate (gridStartX+(totalWidth/2-workingWidth/2)*scalingfactor,gridStartY);
    fill(workingAreaColour);
    rect(0,0,workingWidth*scalingfactor,rows*scalingfactor);
    popMatrix();

    //draw displayWorkingRow
    pushMatrix();
    translate (gridStartX,gridStartY+displayWorkingRow*scalingfactor);
    fill(displayWorkingRowColour);
    rect(0,0,totalWidth*scalingfactor,scalingfactor);
    popMatrix();


}


void drawGrid() {

    //clear left side
    pushMatrix();
    translate (0,gridStartY);
    fill(backgroundColour);
    // rect(0,0,gridStartX,rows*scalingfactor);
    rect(0,0,gridStartX+(totalWidth/2-workingWidth/2)*scalingfactor,rows*scalingfactor);
    popMatrix();

    //clear right side
    pushMatrix();
    translate (gridStartX+((totalWidth/2-workingWidth/2)+workingWidth)*scalingfactor,gridStartY);
    fill(backgroundColour);
    // rect(0,0,gridStartX,rows*scalingfactor);
    rect(0,0,(totalWidth/2-workingWidth/2+10)*scalingfactor,rows*scalingfactor);
    popMatrix();

    // clear header
    fill(headerColour);
    rect(0,0,width,gridStartY);


    //Draw Border
    if (SetBorderToggle == true) {
        //draw Border left
        pushMatrix();
        translate (gridStartX+(totalWidth/2-workingWidth/2)*scalingfactor,gridStartY);
        fill(blackColour);
        rect(0,0,scalingfactor,rows*scalingfactor);
        popMatrix();

        // draw Border right
        pushMatrix();
        translate (gridStartX+((totalWidth/2-workingWidth/2-1)+workingWidth)*scalingfactor,gridStartY);
        fill(blackColour);
        rect(0,0,scalingfactor,rows*scalingfactor);
        popMatrix();
    }

    //draw displayWorkingRow left
    pushMatrix();
    translate (gridStartX,gridStartY+displayWorkingRow*scalingfactor);
    fill(displayWorkingRowColour);
    //rect(0,0,totalWidth*scalingfactor,scalingfactor);
    rect(0,0,(totalWidth/2-workingWidth/2)*scalingfactor,scalingfactor);
    popMatrix();

    //draw displayWorkingRow right
    pushMatrix();
    translate (gridStartX+((totalWidth/2-workingWidth/2)+workingWidth)*scalingfactor,gridStartY+displayWorkingRow*scalingfactor);
    fill(displayWorkingRowColour);
    //rect(0,0,totalWidth*scalingfactor,scalingfactor);
    rect(0,0,(totalWidth/2-workingWidth/2)*scalingfactor,scalingfactor);
    popMatrix();

    //draw Grid
    pushMatrix();
    translate (gridStartX,gridStartY);

    for (int x=0; x<totalWidth+1; x++) {
        stroke(0);
        line(x*scalingfactor, 0, x*scalingfactor, rows*scalingfactor);
    }
    for (int y=0; y<rows+1; y++) {
        stroke(0);
        line(0, y*scalingfactor, columns*scalingfactor, y*scalingfactor);
    }
    popMatrix();

    //draw Logo
    image(knittyLogoImage,5,5,knittyLogoImage.width,knittyLogoImage.height);



}


void dropEvent(DropEvent theDropEvent) {
    if ( theDropEvent.isImage() && theDropEvent.isFile() ) {
        try {

            loadPatternImage(theDropEvent.toString());

        } catch(Exception e) {
        }
    }
}

void loadPatternImageFile () {
    selectInput("Select a file to process:", "fileSelected");

}


void fileSelected(File selection) {
    try {
        if (selection != null) {
            loadPatternImage(selection.getAbsolutePath());
        }
    } catch(Exception e) {
    }
}
