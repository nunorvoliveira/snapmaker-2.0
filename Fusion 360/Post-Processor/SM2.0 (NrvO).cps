/* POST LICENSE, SOURCE, INFORMATION, DESCRIPTION, VERSION HISTORY

    LICENSE: This file is distributed under GNU General Public License v3.0

    SOURCE: This file is publicly available at GitHub: https://github.com/nunorvoliveira/snapmaker-2.0
    
    Fusion 360 post processor configuration file for Snapmaker 2.0 (Marlin flavor)

    Created by Nuno Vaz Oliveira to overcome problems and difficulties from Snapmaker post processor

    VERSION HISTORY
    ===============
    20230414.1
     - Enable machine simulation

    20230108.1
     - Minor cosmetic updates

    20230104.1
     - Changed order of operations. Now, the spin up operation takes place only after raising the Z axis to the initial
       position. This prevents the material from being scratched by the tool.
     - Big thanks to 'seppo' for submitting this idea!

    20220403.1
     - Changed the ACTION_PAUSE_RAISE_Z command to raise the Z axis to machine coordinates Z=334mm instead of the
       previous absolute value of Z=9999mm to keep the preview of the generated g-code realistic and to allow for a
       correct time estimation for the CNC program.
     - In addition, the speed for raising the Z axis was increased from 200mm/min to 3000mm/min and the speed for
       lowering the Z axis after the pause was increased from 200mm/min to 1500mm/min.
     - These 2 values are configurable on the post processor file on the "User configuration" section and are named:
         PAUSE_RAISE_Z_FEED_RATE_UP
         PAUSE_RAISE_Z_FEED_RATE_DOWN
     - Big thanks to 'Ksdmg' for pointing this out!

    20220320.2
     - Changed the onSection() initial positioning to move Z-axis up first, then move X-axis and Y-axis and then Z-axis down

    20220320.1
     - Grouped properties in 3 different categories:
        - Formatting options           (Line numbers, spaces, etc...)
        - Feed rate manipulation       (Custom feed rate, use it?, use G0, etc...)
        - Information to add           (Write machine?, Program?, Post?, Warnings?, Extra info?)

    20220319.1
     - Change feedrate options to a combobox with options:
        - Use feed rate as output by Fusion 360                   (Do nothing)
        - Change feed rate to custom valus when retracted         (Replace fusion 360 feed rate with custom value when retracted)
        - Change G01 to G00 and ignore feed rates when retracted  (Replace fusion 360 G01 moves with G00 moves when retracted)

    20220314.1
     - Added onDwell(seconds) function as example on Autodesk Post Processor Training Guide
     - Added the possibility to setup a manual NC command to pause the job with or without raizing the Z
       axis. The commands are of type Action and the Action text is one of the following:
        - ACTION_PAUSE           -> Pause the spindle and resume after user confirmation
        - ACTION_PAUSE_RAISE_Z   -> Pause the spindle, raise Z, and resume after user confirmation

    20220313.1
     - Added M400 before stopping the spindle to make sure all operations completed successfully
     - Implemented tool rotation to support both CW and CCW tools as defined on Fusion 360. This is currently not
       supported by Snapmaker (at least on A350, but is already implemented for futureproof)
     - Added new option on Fusion 360 to allow user to decide if program information shoud be added
     - Added new option on Fusion 360 to allow user to decide if operation name shoud be added

    20220312.3
     - Changed the post to include an option inside Fusion 360 to allow user to remove or
       not the Fusion 360 rapid move limitation
     - Added a replacement option to replace G1 with G0 when replacing ther retracted feed
       rate
     - Added an option to use additional comments on the file to allow for better
       understanding of the program execution

    20220312.2
     - Added post processor information to the comments on the top of the file

    20220312.1
     - Added a property object with additional information
     - Changed the properties read mode to be compatible with the new property object

    20220310.1
     - Added a property to the post processor to allow users to select the desired
       feed rate for the retracted height. This is changeable on the Fusion 360 post page

    20220302.1
     - Implemented some code to intercept the retract height and overcome the
       Fusion 360 rapid move limit to allow it to travel fast at 6000mm/min
     - Improved the onComment() function to eliminate the Fusion 360 free warning message

    20220301.1
     - Implemented code to read the defined spindle speed and process this speed to be
       compatible with the Fusion 360 defined setting.

    20220207.1
     - Improved the OnClose() code. Tool head does not go to working origin before
       raising the Z axis as it could hit some clamps

    20220117.1
     - First contact ever with a post processor and begining of an investigation journey.
     - Starting to build first functions according to Autodesk Post Processor Training Guide.pdf
*/

// Post processor version in format year month day . version => yyyymmdd.v and author name
{
    POST_VERSION                       = "v20230108.1";
    AUTHOR_NAME                        = "Nuno Vaz Oliveira";
}

// User configuration. Please change only these values on this file
{
    MIN_SPINDLE_SPEED                  = "3000";               // Minimum spindle speed. The lower it gets the less torque. 600 is possible but useless...
    MAX_SPINDLE_SPEED                  = "12000";              // Maximum spindle speed. On Snapmaker 2.0 this is 12000rpm
    DWELL_TIME_SPIN_UP                 = "2";                  // Dwell time for spin up in seconds. Used immediately after spindle start
    DWELL_TIME_SPIN_DOWN               = "3";                  // Dwell time for spin down in seconds. Used immediately after spindle stop
    PAUSE_RAISE_Z_FEED_RATE_UP         = 3000;                 // Feed rate to raise Z axis on ACTION_PAUSE_RAISE_Z command
    PAUSE_RAISE_Z_FEED_RATE_DOWN       = 1500;                 // Feed rate to return Z axis to position after ACTION_PAUSE_RAISE_Z command
}

// Fusion 360 Kernel Settings
{
    allowedCircularPlanes              = 0;                                                                // Not supported by Snapmaker 2.0
    allowHelicalMoves                  = true;                                                             // Supported by Snapmaker 2.0
    capabilities                       = CAPABILITY_MILLING | CAPABILITY_MACHINE_SIMULATION;                                               // All that Snapmaker 2.0 can handle
    certificationLevel                 = 2;                                                                // As recommended on Autodesk Post Processor Training Guide
    description                        = "Snapmaker 2.0 (Marlin) by " + AUTHOR_NAME;                       // Shows up on Fusion 360 post window
    extension                          = ".cnc";                                                           // As exported by Luban
    setCodePage("ascii");                                                                                  // As recommended on Autodesk Post Processor Training Guide
    highFeedrate                       = 6000;                                                             // Specifies the high feed mapping mode for rapid moves
    legal                              = "Copyright (C) 2022 " + AUTHOR_NAME;
    longDescription                    = "Milling post for Snapmaker 2.0" + POST_VERSION + ", created by " + AUTHOR_NAME;
    maximumCircularRadius              = spatial(1000, MM);                                                // As recommended on Autodesk Post Processor Training Guide
    maximumCircularSweep               = toRad(180);                                                       // As recommended on Autodesk Post Processor Training Guide
    minimumCircularSweep               = toRad(0.01);                                                      // As recommended on Autodesk Post Processor Training Guide
    minimumChordLength                 = spatial(0.01, MM);                                                // As recommended on Autodesk Post Processor Training Guide
    minimumCircularRadius              = spatial(0.01, MM);                                                // As recommended on Autodesk Post Processor Training Guide
    minimumRevision                    = 24000;                                                            // As recommended on Autodesk Post Processor Training Guide
    tolerance                          = spatial(0.002, MM);                                               // As recommended on Autodesk Post Processor Training Guide
    vendor                             = "Snapmaker";                                                      // Shows up on Fusion 360 post window
    vendorUrl                          = "http://www.snapmaker.com";
}

// Properties that are changeable on Fusion 360 post process page. New improved version with tooltips and proper writing
properties = {
    writeWarnings                      : {
        title                          : "Write warnings as comments",
        description                    : "Output comments with warnings for unsupported and ignored functions.",
        group                          : "informationSection",
        type                           : "boolean",
        value                          : true,
        scope                          : "post"
    },
    writeOperationName                 : {
        title                          : "Write operation name",
        description                    : "Output operation name before the operation starts and immediately before spindle turns on.",
        group                          : "informationSection",
        type                           : "boolean",
        value                          : true,
        scope                          : "post"
    },
    writeProgram                       : {
        title                          : "Write program information",
        description                    : "Output additional comments to the file with program name and comments.",
        group                          : "informationSection",
        type                           : "boolean",
        value                          : true,
        scope                          : "post"
    },
    writeExtraComments                 : {
        title                          : "Write extra comments",
        description                    : "Output additional comments to the file to have a better understanding of the post-processor execution steps. Clearing this will produce the cleanest g-code file after the header.",
        group                          : "informationSection",
        type                           : "boolean",
        value                          : true,
        scope                          : "post"
    },
    writePost                          : {
        title                          : "Write post-processor",
        description                    : "Output the post-processor description and version in the header of the code.",
        group                          : "informationSection",
        type                           : "boolean",
        order:0,
        value                          : true,
        scope                          : "post"
    },
    retractFeedRate                    : {
        title                          : "Custom feed rate when retracted",
        description                    : "Enter the feed rate to use when retracted in mm/min. This will avoid slow feedrate on rapid moves of Fusion 360 free. This is ignored if \"2 -> Replace G1 with G0\" is selected.",
        group                          : "rapidSection",
        type                           : "integer",
        range                          : [ 1000 , 7000 ],
        value                          : 6000,
        scope                          : "post"
    },
    feedRateMode                       : {
        title                          : "Rapid feed rate mode",
        description                    : "Selech how to handle the retracted feed rate when retracted. 0 -> Don't change and use Fusion 360 values. 1 -> Use custom feed rate filled below as \"Custom feed rate when retracted\". 2 -> Replace G1 with G0 and ignore feed rates",
        type                           : "enum",
        group                          : "rapidSection",
        values                         : [
            { title                    : "0 -> Don't change",                id:"0"},
            { title                    : "1 -> Use custom feed rate",        id:"1"},
            { title                    : "2 -> Replace G1 with G0",          id:"2"}
        ],
        value                          : "0",
        scope                          : "post"
    },
    writeMachine                       : {
        title                          : "Write machine",
        description                    : "Output the machine settings in the header of the code.",
        group                          : "informationSection",
        type                           : "boolean",
        value                          : true,
        scope                          : "post"
    },
    showSequenceNumbers                : {
        title                          : "Use sequence numbers",
        description                    : "Use sequence numbers for each block of outputted code.",
        group                          : "formattingSection",
        type                           : "boolean",
        value                          : false,
        scope                          : "post"
    },
    sequenceNumberStart                : {
        title                          : "Start sequence number",
        description                    : "The number at which to start the sequence numbers.",
        group                          : "formattingSection",
        type                           : "integer",
        value                          : 10,
        scope                          : "post"
    },
    sequenceNumberIncrement            : {
        title                          : "Sequence number increment",
        description                    : "The amount by which the sequence number is incremented by in each block.",
        group                          : "formattingSection",
        type                           : "integer",
        value                          : 1,
        scope                          : "post"
    },
    separateWordsWithSpace             : {
        title                          : "Separate words with space",
        description                    : "Adds spaces between words when selected.",
        group                          : "formattingSection",
        type                           : "boolean",
        value                          : true,
        scope                          : "post"
    }
};

// Properties groups for custom post properties above
groupDefinitions = {
    informationSection                 : {
        title                          : "Information Section",
        description                    : "Configure the comments added to the post. Machine, post, program, warnings, etc...",
        collapsed                      : false,
        order                          : 0
    },
        rapidSection                       : {
        title                          : "Rapid Feed Rate Section",
        description                    : "Selects what manipulation to add to the feed rate when retracted",
        collapsed                      : false,
        order                          : 1,
    },
    formattingSection                  : {
        title                          : "Formatting Section",
        description                    : "Definitions for spacing, line numbers, increments, etc...",
        collapsed                      : false,
        order                          : 2
    },
};

// Formats, Outputs, Modals and Variables
{
    // Linear output and format
    var gFormat                        = createFormat({prefix:"G", decimals:0});                           // Retrieved from examining Luban files
    var mFormat                        = createFormat({prefix:"M", decimals:0});                           // Retrieved from examining Luban files
    var xyzFormat                      = createFormat({decimals:(unit == MM ? 3 : 4), trim:false});        // As recommended on Autodesk Post Processor Training Guide and including extra option as on Snapmaker original post
    var feedFormat                     = createFormat({decimals:(unit == MM ? 1 : 2)});                    // Retrieved from examining Luban files
    var secFormat                      = createFormat({decimals:3, forceDecimal:true});                    // As on Snapmaker original post
    var xOutput                        = createVariable({prefix:"X", force:true}, xyzFormat);              // As recommended on Autodesk Post Processor Training Guide and from examining Luban files
    var yOutput                        = createVariable({prefix:"Y", force:true}, xyzFormat);              // As recommended on Autodesk Post Processor Training Guide and from examining Luban files
    var zOutput                        = createVariable({prefix:"Z", force:true}, xyzFormat);              // As recommended on Autodesk Post Processor Training Guide and from examining Luban files
    var feedOutput                     = createVariable({prefix:"F", force:true}, feedFormat);             // As recommended on Autodesk Post Processor Training Guide and from examining Luban files
    // Circular output
    var iOutput                        = createReferenceVariable({prefix:"I", force:true}, xyzFormat);     // As recommended on Autodesk Post Processor Training Guide and from examining Luban files
    var jOutput                        = createReferenceVariable({prefix:"J", force:true}, xyzFormat);     // As recommended on Autodesk Post Processor Training Guide and from examining Luban files
    // Modals
    var gMotionModal                   = createModal({force:true}, gFormat);                               // As recommended on Autodesk Post Processor Training Guide
    var gAbsIncModal                   = createModal({}, gFormat);                                         // As on Snapmaker original post
    var gUnitModal                     = createModal({}, gFormat);                                         // As on Snapmaker original post
    // Collected state
    var sequenceNumber;                                                                                    // As recommended on Autodesk Post Processor Training Guide
    var currentWorkOffset;                                                                                 // As recommended on Autodesk Post Processor Training Guide

    var pendingRadiusCompensation      = -1;                                                               // As recommended on Autodesk Post Processor Training Guide

    // This variable will read the retrack height to manipulate the output from Fusio 360 free in a way that the
    // feed speed will be set to the correct value for moves on the retract plane and above
    var retractHeight                  = 9999;

    // This variable will track the last Z position
    var lastPositionZ                  = 9999;
}


// Start of machine configuration logic
var compensateToolLength = false; // add the tool length to the pivot distance for nonTCP rotary heads
var virtualTooltip = false; // translate the pivot point to the virtual tool tip for nonTCP rotary heads
// internal variables, do not change
var receivedMachineConfiguration;
var tcpIsSupported;

function activateMachine() {
  // determine if TCP is supported by the machine
  tcpIsSupported = false;
  var axes = [machineConfiguration.getAxisU(), machineConfiguration.getAxisV(), machineConfiguration.getAxisW()];
  for (var i in axes) {
    if (axes[i].isEnabled() && axes[i].isTCPEnabled()) {
      tcpIsSupported = true;
      break;
    }
  }

  // setup usage of multiAxisFeatures
  useMultiAxisFeatures = getProperty("useMultiAxisFeatures") != undefined ? getProperty("useMultiAxisFeatures") :
    (typeof useMultiAxisFeatures != "undefined" ? useMultiAxisFeatures : false);
  useABCPrepositioning = getProperty("useABCPrepositioning") != undefined ? getProperty("useABCPrepositioning") :
    (typeof useABCPrepositioning != "undefined" ? useABCPrepositioning : false);

  if (!machineConfiguration.isMachineCoordinate(0) && (typeof aOutput != "undefined")) {
    aOutput.disable();
  }
  if (!machineConfiguration.isMachineCoordinate(1) && (typeof bOutput != "undefined")) {
    bOutput.disable();
  }
  if (!machineConfiguration.isMachineCoordinate(2) && (typeof cOutput != "undefined")) {
    cOutput.disable();
  }

  if (!machineConfiguration.isMultiAxisConfiguration()) {
    return; // don't need to modify any settings for 3-axis machines
  }

  // retract/reconfigure
  safeRetractDistance = getProperty("safeRetractDistance") != undefined ? getProperty("safeRetractDistance") :
    (typeof safeRetractDistance == "number" ? safeRetractDistance : 0);
  if (machineConfiguration.performRewinds() || (typeof performRewinds == "undefined" ? false : performRewinds)) {
    machineConfiguration.enableMachineRewinds(); // enables the rewind/reconfigure logic
    if (typeof stockExpansion != "undefined") {
      machineConfiguration.setRewindStockExpansion(stockExpansion);
      if (!receivedMachineConfiguration) {
        setMachineConfiguration(machineConfiguration);
      }
    }
  }

  if (machineConfiguration.isHeadConfiguration()) {
    compensateToolLength = typeof compensateToolLength == "undefined" ? false : compensateToolLength;
    virtualTooltip = typeof virtualTooltip == "undefined" ? false : virtualTooltip;
    machineConfiguration.setVirtualTooltip(virtualTooltip);
  }
  setFeedrateMode();

  if (machineConfiguration.isHeadConfiguration() && compensateToolLength) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      var section = getSection(i);
      if (section.isMultiAxis()) {
        machineConfiguration.setToolLength(getBodyLength(section.getTool())); // define the tool length for head adjustments
        section.optimizeMachineAnglesByMachine(machineConfiguration, tcpIsSupported ? 0 : 1);
      }
    }
  } else {
    optimizeMachineAngles2(tcpIsSupported ? 0 : 1);
  }
}

function setFeedrateMode(reset) {
  if ((tcpIsSupported && !reset) || !machineConfiguration.isMultiAxisConfiguration()) {
    return;
  }
  machineConfiguration.setMultiAxisFeedrate(
    tcpIsSupported ? FEED_FPM : FEED_INVERSE_TIME,
    9999.99, // maximum output value for inverse time feed rates
    INVERSE_MINUTES, // can be INVERSE_SECONDS or DPM_COMBINATION for DPM feeds
    0.5, // tolerance to determine when the DPM feed has changed
    1.0 // ratio of rotary accuracy to linear accuracy for DPM calculations
  );
  if (!receivedMachineConfiguration || (revision < 45765)) {
    setMachineConfiguration(machineConfiguration);
  }
}

function getBodyLength(tool) {
  for (var i = 0; i < getNumberOfSections(); ++i) {
    var section = getSection(i);
    if (tool.number == section.getTool().number) {
      return section.getParameter("operation:tool_overallLength", tool.bodyLength + tool.holderLength);
    }
  }
  return tool.bodyLength + tool.holderLength;
}

function defineMachine() {
  if (false) { // note: setup your machine here
    var aAxis = createAxis({coordinate:0, table:true, axis:[1, 0, 0], range:[-120, 120], preference:1, tcp:true});
    var cAxis = createAxis({coordinate:2, table:true, axis:[0, 0, 1], range:[-360, 360], preference:0, tcp:true});
    machineConfiguration = new MachineConfiguration(aAxis, cAxis);

    setMachineConfiguration(machineConfiguration);
    if (receivedMachineConfiguration) {
      warning(localize("The provided CAM machine configuration is overwritten by the postprocessor."));
      receivedMachineConfiguration = false; // CAM provided machine configuration is overwritten
    }
  }
  /* home positions */
  // machineConfiguration.setHomePositionX(toPreciseUnit(0, IN));
  // machineConfiguration.setHomePositionY(toPreciseUnit(0, IN));
  // machineConfiguration.setRetractPlane(toPreciseUnit(0, IN));
}
// End of machine configuration logic



// The writeBlock function writes a block of codes to the output NC file. It will add a sequence number to the block,
// if sequence numbers are enabled and add an optional skip character if this is an optional operation.
// A list of formatted codes and/or text strings are passed to the writeBlock function.
// The code list is separated by commas, so that each code is passed as an individual argument, which allows for the
// codes to be separated by the word separator defined by the setWordSeparator function.
function writeBlock() {
    if (prop_showSequenceNumbers) {
        writeWords2("N" + sequenceNumber, arguments);
        sequenceNumber += prop_sequenceNumberIncrement;
    } else {
        writeWords(arguments);
    }
}

// formatComment is used to format comments. The formatComment function will remove any characters in the comment
// that are not allowed, and add any characters that are mandatory. For Snapmakers, a semi-colon at the beginning.
function formatComment(text) {
    return ";" + String(text).replace(/[\(\)]/g, ""); // TODO: Need to double check if ( and ) are bad for comments
}

// The writeComment function is defined in the post processor and is used to output comments to the output NC file.
function writeComment(text) {
    writeln(formatComment(text));
}

// The onComment function is called when the Manual NC command Comment is issued.
// It will format and output the text of the comment to the NC file.
function onComment(message) {

    // Splits comments using ; as separator
    var comments = String(message).split(";");
    // Allow multiple lines of comments per command
    for (comment in comments) {
        // This prevents the warning message from Fusion 360 for Personal Use
        if ( comments[comment] != "When using Fusion 360 for Personal Use, the feedrate of" && 
             comments[comment] != "rapid moves is reduced to match the feedrate of cutting" && 
             comments[comment] != "moves, which can increase machining time. Unrestricted rapid" && 
             comments[comment] != "moves are available with a Fusion 360 Subscription." ) {
            // Write the comment to the file
            writeComment(comments[comment]);
        }
    }

}

// The onOpen function is called at start of each CAM operation and can be used to define settings used in the
// post processor and output the startup blocks:
//   1. Define settings based on properties
//   2. Define the multi-axis machine configuration
//   3. Output program name and header
//   4. Perform checks for duplicate tool numbers and work offsets
//   5. Output initial startup codes
function onOpen() {

  receivedMachineConfiguration = (typeof machineConfiguration.isReceived == "function") ? machineConfiguration.isReceived() :
  ((machineConfiguration.getDescription() != "") || machineConfiguration.isMultiAxisConfiguration());
if (typeof defineMachine == "function") {
  defineMachine(); // hardcoded machine configuration
}
activateMachine(); // enable the machine optimizations and settings


    // Read properties from post to internal variables
    prop_writeWarnings                 = getProperty("writeWarnings");
    prop_writeOperationName            = getProperty("writeOperationName");
    prop_writeProgram                  = getProperty("writeProgram");
    prop_writeExtraComments            = getProperty("writeExtraComments");
    prop_writePost                     = getProperty("writePost");
    prop_feedRateMode                  = getProperty("feedRateMode");
    prop_retractFeedRate               = getProperty("retractFeedRate");
    prop_writeMachine                  = getProperty("writeMachine");
    prop_showSequenceNumbers           = getProperty("showSequenceNumbers");
    prop_sequenceNumberStart           = getProperty("sequenceNumberStart");
    prop_sequenceNumberIncrement       = getProperty("sequenceNumberIncrement");
    prop_separateWordsWithSpace        = getProperty("separateWordsWithSpace");
    // Expand prop_feedRateMode to other variables (this makes the code compatible with previous version where "prop_feedRateMode" wasn't implemented yet
    prop_useRetractFeedRate            = ( prop_feedRateMode == 1 ? true : false );
    prop_useG0notG1                    = ( prop_feedRateMode == 2 ? true : false );

    // Process property separateWordsWithSpace
    if (!prop_separateWordsWithSpace) {
        setWordSeparator("");
    }

    // Read property sequenceNumberStart
    sequenceNumber = prop_sequenceNumberStart;

    // Write program info
    if (prop_writeProgram) {
        writeComment(localize("Program"));
        if (programName) {
            writeComment(localize(" -> Name") + "        : " + programName);
        }
        if (programComment) {
            writeComment(localize(" -> Comment") + "     : " + programComment);
        }
    }

    // Get machine info
    var description = "Snapmaker 2.0 (Marlin)";
    var vendor = "Snapmaker";
    var vendorUrl = "http://www.snapmaker.com";
    var model = machineConfiguration.getModel();

    // Write machine info
    if (prop_writeMachine && (vendor || model || description)) {
        writeComment(localize("Machine"));
        if (vendor) {
            writeComment(localize(" -> Vendor") + "      : " + vendor);
        }
        if (vendorUrl) {
            writeComment(localize(" -> Vendor URL") + "  : " + vendorUrl);
        }
        if (model) {
            writeComment(localize(" -> Model") + "       : " + model);
        }
        if (description) {
            writeComment(localize(" -> Description") + " : "  + description);
        }
    }

    // Write post info
    if (prop_writePost) {
        writeComment(localize("Post-Processor"));
        writeComment(localize(" -> Author") + "      : "  + AUTHOR_NAME);
        writeComment(localize(" -> Version") + "     : "  + POST_VERSION);
        writeComment(localize(" -> Description") + " : "  + longDescription);
    }
    if (prop_writeExtraComments) writeln("");

    // Check unit and process it as on Snapmaker original post
    switch (unit) {
        case IN:
            error(localize("Please select millimeters as unit when post processing. Inch mode is not supported."));
            return;
        case MM:
            // Define working unit as millimeters
            if (prop_writeExtraComments) writeComment(localize("Set units to millimeters"));
            writeBlock(gUnitModal.format(21));
            break;
    }

    // Set absolute coordinates
    if (prop_writeExtraComments) writeComment(localize("Set working units as absolute positioning system"));
    writeBlock(gAbsIncModal.format(90));

    // Adds a space between top section and tool paths
    if (prop_writeExtraComments) writeln("");
    
    activateMachine(); // enable the machine optimizations and settings

    // Forces the output of the linear axes (X, Y, Z) on the next motion block
    forceXYZ();

}

// The onSection function is called at start of each CAM operation and controls the output of the following blocks:
//   1. End of previous section
//   2. Operation comments and notes
//   3. Tool change
//   4. Work plane
//   5. Initial position
function onSection() {                                         // Start of an operation

    // Separates this line from the read parameters from the onParameter() function
    if (prop_writeExtraComments) writeln("");

    // Writes the comment for the current operation
    if (prop_writeOperationName) {
        if (hasParameter("operation-comment")) {
            var comment = getParameter("operation-comment");
            if (comment) {
                writeComment("Operation name: " + comment);
            }
        }
    }

    // specifies that the tool has been retracted to the safe plane
    var retracted = false;

    // Forces the output of the linear axes (X, Y, Z) on the next motion block
    forceXYZ();

    // pure 3D - This piece of code is from the Autodesk Post Processor Training Guide. Left here as it's also present on Snapmaker original post. Needed? Not sure...
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
        error(localize("Tool orientation is not supported."));
        return;
    }
    setRotation(remaining);

    // Forces output on all axes and feedrate on the next motion block
    forceAny();

    // Gets the initial position of the tool path that is about to start
    var initialPosition = getFramePosition(currentSection.getInitialPosition());

    // Chech if we are not retracted or if it's the first tool path (section) and if so, raises the Z-axis to
    // the Z value of the starting tool path to prevent tool collision if going to the next starting point diagonally
    if (!retracted || isFirstSection()) {
        if (getCurrentPosition().z < initialPosition.z || isFirstSection()) {
            // Save last Z position (Added by me)
            lastPositionZ = zOutput.format(initialPosition.z);
            // Move to starting position
            if (prop_writeExtraComments) writeComment(localize("Raize Z axis to safe position"));
            writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
        }
    }

    // Forces the output of gMotionModal on the next call (Kept from Snapmaker original post)
    gMotionModal.reset();

    // Converts the spindle RPM to a correct value between MIN_SPINDLE_SPEED and MAX_SPINDLE_SPEED
    // and converts it to a percentage
    var tSpeed = tool.spindleRPM;
    if (tSpeed < MIN_SPINDLE_SPEED) {
        tSpeed = MIN_SPINDLE_SPEED;
    }
    if (tSpeed > MAX_SPINDLE_SPEED) {
        tSpeed = MAX_SPINDLE_SPEED;
    }
    var tSpeedPercent = tSpeed * 100 / MAX_SPINDLE_SPEED;
    if (prop_writeExtraComments) writeComment("Set tool speed to " + tool.spindleRPM + "RPM, or " + Math.ceil(tSpeedPercent) + "% in " + ((toolClockWise == 1) ? "CW" : "CCW") + " direction");
    writeBlock(mFormat.format(4-toolClockWise) + " P" + Math.ceil(tSpeedPercent));
    // Dwell to allow the spindle to spin up
    if (prop_writeExtraComments) writeComment(localize("Dwell for " + DWELL_TIME_SPIN_UP + " seconds to allow the spindle to spin up"));
    writeBlock("G4 S" + DWELL_TIME_SPIN_UP);

    // Save last Z position (Added by me)
    lastPositionZ = zOutput.format(initialPosition.z);
    // Move to starting position
    writeBlock(
        gAbsIncModal.format(90),
        gMotionModal.format(0),
        xOutput.format(initialPosition.x),
        yOutput.format(initialPosition.y),
        zOutput.format(initialPosition.z)
    );

}

// The onSectionEnd function can be used to define the end of an operation, but in most post processors this is handled
// in the onSection function. The reason for this is that different output will be generated depending on if there is a
// tool change, WCS change, or Work Plane change and this logic is handled in the onSection function (see the
// insertToolCall variable), though it could be handled in the onSectionEnd function if desired by referencing the
// getNextSection and isLastSection functions.
function onSectionEnd() {

    // Separates this section from next section or from bottom section
    if (prop_writeExtraComments) writeln("");

    // Forces all axes and the feedrate on the next motion block
    forceAny();

}

// The force functions are used to force the output of the specified axes and/or feedrate the next time they are
// supposed to be output, even if it has the same value as the previous value.
// Forces the output of the linear axes (X, Y, Z) on the next motion block.
function forceXYZ() {

    // Forces the output of the linear axe X on the next motion block
    xOutput.reset();
    // Forces the output of the linear axe Y on the next motion block
    yOutput.reset();
    // Forces the output of the linear axe Z on the next motion block
    zOutput.reset();

}

// The force functions are used to force the output of the specified axes and/or feedrate the next time they are
// supposed to be output, even if it has the same value as the previous value.
// Forces all axes and the feedrate on the next motion block
function forceAny() {

    // Forces the output of the linear axes (X, Y, Z) on the next motion block
    forceXYZ();
    // Forces the output of the feedrate on the next motion block
    feedOutput.reset();

}

// The onDwell function can be called by a Manual NC command, directly from HSM, or from the post processor.
// The Manual NC command that calls onDwell is described in the Manual NC Commands chapter. Internal calls to
// onDwell are usually generated when expanding a cycle. The post processor itself will call onDwell directly to
// output a dwell block.
function onDwell(seconds) {

    // Check if secconds is excessive and output a warning
    if (seconds > 99999.999) {
        warning(localize("Dwelling time is out of range."));
    }
    // Clamp secconds between 0.001 and 99999.999 (1 millisecond to 1 day 3 hours 46 minutes and 39.999 seconds)
    seconds = clamp(0.001, seconds, 99999.999);
    // Output informative comment
    if (prop_writeExtraComments) writeComment("Manual command OnDwell was requested for " + seconds + " second(s)");
    // Execute dwell
    writeBlock(gFormat.format(4), "S" + secFormat.format(seconds));

}

// The onSpindleSpeed function is used to output changes in the spindle speed during an operation, typically
// from the post processor engine when expanding a cycle.
// This is not supported by the Snapmaker Original and 2.0 and it's only implemented to prevent bad Gcode output.
function onSpindleSpeed(spindleSpeed) {

    // Spindle speed change during operation is not supported
    if (prop_writeWarnings) writeComment("WARNING: Unsupported onSpindleSpeed(spindleSpeed) during toolpath was invoked and ignored");

}

// Almost all parameters used for creating a machining operation in HSM are passed to the post processor.
// Common parameters are available using built in post processor variables (currentSection, tool, cycle, etc.) as
// well as being made available as parameters. Other parameters are passed to the onParameter function.
// This will capture parameters sent to the post-processor and execute needed actions
function onParameter(param_name, param_value) {

    // Read parameter "operation:retractHeight_value"
    // This will be used to increase the feed rate on planes at retracted height or above
    if (param_name == "operation:retractHeight_value") {
        retractHeight = param_value;
        if (prop_writeExtraComments) writeComment("Parameter \"operation:retractHeight_value\" read successfully with a value of " + retractHeight);
    }

    // Read parameter "operation:tool_clockwise"
    // This will be used to have the tool rotating in the correct direction. CW or CCW
    if (param_name == "operation:tool_clockwise") {
        toolClockWise = param_value;
        if (prop_writeExtraComments) writeComment("Parameter \"operation:tool_clockwise\" read successfully with a value of " + ((toolClockWise == 1) ? "CW" : "CCW"));
    }

    // Read parameter "action"
    // This will be used to have special command executed manually
    if (param_name == "action") {
        // Checks what parameter was passed
        switch (param_value) {
            case "ACTION_PAUSE":               // User passed command to pause the job. M76
                if (prop_writeExtraComments) writeComment("Manual NC command action \"ACTION_PAUSE\" invoked");
                if (prop_writeExtraComments) writeComment("Executing job pause");
                // Write block with Pause command
                writeBlock(mFormat.format(76));
                if (prop_writeExtraComments) writeln("");
                break;
            case "ACTION_PAUSE_RAISE_Z":      // User passed command to pause the job and raise Z. Raise, M76, Un-Raise
            if (prop_writeExtraComments) writeComment("Manual NC command action \"ACTION_PAUSE_RAISE_Z\" invoked");
                if (prop_writeExtraComments) writeComment("Raising Z");
                // Raises Z axix to machine coordinates Z=334mm
                writeBlock(gMotionModal.format(53), gMotionModal.format(1), zOutput.format(334), feedOutput.format(PAUSE_RAISE_Z_FEED_RATE_UP));
                // Enforces absolute positioning coordinate system
                writeBlock(gAbsIncModal.format(90));
                if (prop_writeExtraComments) writeComment("Executing job pause");
                // Write block with Pause command
                writeBlock(mFormat.format(76));
                if (prop_writeExtraComments) writeComment("Reverting Z to previous location");
                // Lowers Z axix to last Z value
                writeBlock(gMotionModal.format(1), lastPositionZ, feedOutput.format(PAUSE_RAISE_Z_FEED_RATE_DOWN));
                if (prop_writeExtraComments) writeln("");
                break;
            default:
                if (prop_writeWarnings) writeComment("WARNING: Unknown action parameter \"" + param_value + "\" was invoked and ignored");
                if (prop_writeWarnings) writeln("");
        }
    }

}

// The onRadiusCompensation function is called when the radius (cutter) compensation mode changes.
// It will typically set the pending compensation mode, which will be handled in the motion functions (onRapid,
// onLinear, onCircular, etc.). Radius compensation, when enabled in an operation, will be enabled on the move
// approaching the part and disabled after moving off the part.
function onRadiusCompensation() {

    // As recommended on Autodesk Post Processor Training Guide
    pendingRadiusCompensation = radiusCompensation;

}

// The onRapid function handles rapid positioning moves (G00) while in 3-axis mode. The tool position is passed
// as the _x, _y, _z arguments. The format of the onRapid function is pretty basic, it will handle a change in
// radius compensation, may determine if the rapid moves should be output at a high feedrate (due to the machine
// making dogleg moves while in rapid mode), and output the rapid move to the NC file.
function onRapid(_x, _y, _z) {

    // Format tool position for output
    var x = xOutput.format(_x);
    var y = yOutput.format(_y);
    var z = zOutput.format(_z);

    // Ignore if tool does not move
    if (x || y || z) {
        // Handle radius compensation
        if (pendingRadiusCompensation >= 0) {
            error(localize("Radius compensation mode cannot be changed at rapid traversal."));
            return;
        }
        // Save last Z position (Added by me)
        if (z) {
            lastPositionZ = z;
        }
        // Output move in rapid mode
        writeBlock(gMotionModal.format(0), x, y, z);
        // Forces the output of the feedrate on the next motion block
        feedOutput.reset();
    }

}

// The onLinear function handles linear moves (G01) at a feedrate while in 3-axis mode. The tool position is passed
// as the _x, _y, _z arguments. The format of the onLinear function is pretty basic, it will handle a change in
// radius compensation and outputs the linear move to the NC file.
function onLinear(_x, _y, _z, feed) {

    // Checks for retrack to overcome Fusion 360 limitation
    var isRetractedHeight = false;
    if (_z >= retractHeight) {
        isRetractedHeight = true;
    }

    // Force move when radius compensation changes
    if (pendingRadiusCompensation >= 0) {
        // Forces the output of the linear axe X on the next motion block
        xOutput.reset();
        // Forces the output of the linear axe Y on the next motion block
        yOutput.reset();
    }
    // Format tool position for output
    var x = xOutput.format(_x);
    var y = yOutput.format(_y);
    var z = zOutput.format(_z);
    var f = feedOutput.format(feed);

    // This will set the feed value to the specified above "retrctFeedRate"
    // on planes equal or above the retrached height in Z axis
    if (isRetractedHeight && !prop_useG0notG1) {
        if (prop_useRetractFeedRate) {
            f = feedOutput.format(prop_retractFeedRate);
        }
    }

    // Ignore if tool does not move
    if (x || y || z) {
        // Handle radius compensation changes
        if (pendingRadiusCompensation >= 0) {
            error(localize("Radius compensation mode is not supported."));
            return;
        // Output non-compensation change move at feedrate
        } else {
            if (isRetractedHeight && prop_useG0notG1) {
                // Ignore feed rate as we are on retracted height and use G0
                if (prop_writeExtraComments) writeComment("Ignoring feed rate " + f + " and using G0 instead of G1");
                // Save last Z position (Added by me)
                if (z) {
                    lastPositionZ = z;
                }
                // output next block
                writeBlock(gMotionModal.format(0), x, y, z);
                // Forces the output of the feedrate on the next motion block
                feedOutput.reset();
            } else {
                if (isRetractedHeight && prop_useRetractFeedRate) {
                    // Ignore feed rate as we are on retracted height and use user defined feed rate
                    if (prop_writeExtraComments) writeComment("Ignoring Fusion 360 feed rate and using defined feed rate of " + f);
                }
                // Save last Z position (Added by me)
                if (z) {
                    lastPositionZ = z;
                }
                // Normal case. Use feed rate specified and output next block
                writeBlock(gMotionModal.format(1), x, y, z, f);
            }
        }
    } else if (f) {
        if (getNextRecord().isMotion()) {                      // Try not to output feed without motion
            // Forces the output of the feedrate on the next motion block
            feedOutput.reset();
        } else {
            // output next block
            writeBlock(gMotionModal.format(1), f);
        }
    }

}

// The onRapid5D function handles rapid positioning moves (G00) in multi-axis operations. The tool position is
// passed as the _x, _y, _z arguments and the rotary angles as the _a, _b, _c arguments. If a machine configuration
// has not been defined, then _a, _b, _c contains the tool axis vector. The onRapid5D function will be called for all
// rapid moves in a multi-axis operation, even if the move is only a 3-axis linear move without rotary movement.
// This is not supported by the Snapmaker Original and 2.0 and it's only implemented to prevent bad Gcode output.
function onRapid5D(_x, _y, _z, _a, _b, _c) {

    // Rapid positioning moves (G00) in multi-axis operations is not supported
    error(localize("Multi-axis motion is not supported."));
    if (prop_writeWarnings) writeComment("WARNING: Unsupported \"onRapid5D(_x, _y, _z, _a, _b, _c)\" was invoked and ignored");

}

// The onLinear5D function handles cutting moves (G01) in multi-axis operations. The tool position is passed as the
// _x, _y, _z arguments and the rotary angles as the _a, _b, _c arguments. If a machine configuration has not been
// defined, then _a, _b, _c contains the tool axis vector. The onLinear5D function will be called for all cutting
// moves in a multi-axis operation, even if the move is only a 3-axis linear move without rotary movement.
// This is not supported by the Snapmaker Original and 2.0 and it's only implemented to prevent bad Gcode output.
function onLinear5D(_x, _y, _z, _a, _b, _c, feed) {

    // Cutting moves (G01) in multi-axis operations is not supported
    error(localize("Multi-axis motion is not supported."));
    if (prop_writeWarnings) writeComment("WARNING: Unsupported \"onLinear5D(_x, _y, _z, _a, _b, _c, feed)\" was invoked and ignored");
    
}

// The onCircular function is called whenever there is circular, helical, or spiral motion. The circular move can be
// in any of the 3 standard planes, XY-plane, YZ-plane, or ZX-plane, it is up to the onCircular function to determine
// which types of circular are valid for the machine and to correctly format the output.
function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {

    // Disallow radius compensation
    if (pendingRadiusCompensation >= 0) {
        error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
        return;
    }

    /***
        From this point down, the remaining of this function is identical to Snapmaker original 
        post with the exception of the reading of last Z position to variable lastPositionZ
    ***/
    
    var start = getCurrentPosition();

    if (isFullCircle()) {               // Full 360 degree circles
        if (isHelical()) {
            linearize(tolerance);
            return;
        }

        switch (getCircularPlane()) {
            case PLANE_XY:
                // output next block
                writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), feedOutput.format(feed));
                break;
            default:
                linearize(tolerance);
        }
    } else {
        switch (getCircularPlane()) {
            case PLANE_XY:
                // Save last Z position (Added by me)
                if (z) {
                    lastPositionZ = zOutput.format(z);
                }
                // output next block
                writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), feedOutput.format(feed));
                break;
            default:
                linearize(tolerance);
        }
    }

}

// Define commands supported by Snapmakers
var mapSnapmakerCommand = {
    COMMAND_STOP:                      0,
    COMMAND_END:                       2,
    COMMAND_SPINDLE_CLOCKWISE:         3,
    COMMAND_SPINDLE_COUNTERCLOCKWISE:  4,
    COMMAND_STOP_SPINDLE:              5
};

// The onCommand function can be called by a Manual NC command, directly from HSM, or from the post processor.
function onCommand(command) {

    // Ignore all unsupported commands and process the supported ones
    switch (command) {
        case COMMAND_ACTIVATE_SPEED_FEED_SYNCHRONIZATION:
            return;
        case COMMAND_ALARM:
            return;
        case COMMAND_ALERT:
            return;
        case COMMAND_BREAK_CONTROL:
            return;
        case COMMAND_CALIBRATE:
            return;
        case COMMAN_CHANGE_PALLET:
            return;
        case COMMAND_CLEAN:
            return;
        case COMMAND_CLOSE_DOOR:
            return;
        case COMMAND_COOLANT_OFF:
            return;
        case COMMAND_COOLANT_ON:
            return;
        case COMMAND_DEACTIVATE_SPEED_FEED_SYNCHRONIZATION:
            return;
        case COMMAND_EXACT_STOP:
            return;
        case COMMAND_LOAD_TOOL:
            return;
        case COMMAND_LOCK_MULTI_AXIS:
            return;
        case COMMAND_MAIN_CHUCK_CLOSE:
            return;
        case COMMAND_MAIN_CHUCK_OPEN:
            return;
        case COMMAND_OPEN_DOOR:
            return;
        case COMMAND_OPTIONAL_STOP:
            return;
        case OMMAND_ORIENTATE_SPINDLE:
            return;
        case COMMAND_POWER_OFF:
            return;
        case COMMAND_POWER_ON:
            return;
        case COMMAND_SECONDARY_CHUCK_CLOSE:
            return;
        case COMMAND_SECONDARY_CHUCK_OPEN:
            return;
        case COMMAND_SECONDARY_SPINDLE_SYNCHRONIZATION_ACTIVATE:
            return;
        case COMMAND_SECONDARY_SPINDLE_SYNCHRONIZATION_DEACTIVATE:
            return;
        case COMMAND_START_CHIP_TRANSPORT:
            return;
        case COMMAND_START_SPINDLE:
            onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);
            return;
        case COMMAND_STOP_CHIP_TRANSPORT:
            return;
        case COMMAND_TOOL_MEASURE:
            return;
        case COMMAND_UNLOCK_MULTI_AXIS:
            return;
        case COMMAND_VERIFY:
            return;
    }

    // Handle commands that output a single M-code and were not ignored on the switch statement above
    var stringId = getCommandStringId(command);
    var mcode = mapSnapmakerCommand[stringId];
    if (mcode != undefined) {
        // Output next block
        writeBlock(mFormat.format(mcode));
    } else {
        onUnsupportedCommand(command);
    }

}

// The onClose function is called at the end of the last operation, after onSectionEnd. It is used to define the end
// of an operation, if not handled in onSectionEnd, and to output the end-of-program codes.
function onClose() {

    // Wait for moves to complete
    if (prop_writeExtraComments) writeComment("Wait for moves to finish before running next instruction");
    // Output next block
    writeBlock(mFormat.format(400));
    // Stop spindle
    if (prop_writeExtraComments) writeComment("Stopping spindle");
    // Output next block
    writeBlock(mFormat.format(5));
    // Dwell to allow the spindle to spin down
    if (prop_writeExtraComments) writeComment(localize("Dwell for " + DWELL_TIME_SPIN_DOWN + " seconds to allow the spindle to spin down"));
    // output next block
    writeBlock("G4 S" + DWELL_TIME_SPIN_DOWN);

}
