
# Fusion 360

## What is Fusion 360

Fusion 360 is a cloud-based 3D modeling, CAD, CAM, CAE, and PCB software platform for product design and manufacturing.

- Design and engineer products to ensure aesthetics, form, fit, and function.

- Reduce the impact of design, engineering, and PCB changes and ensure manufacturability with simulation and generative design tools.

- Directly edit existing features or model fixtures with the only truly integrated CAD + CAM software tool.

## Fusion 360 and Snapmaker

Fusion 360 can be set up to work with Snapmaker. To do that, we need to tell Fusion 360 what is our machine, what are our tools, and what *post-processor* we want to use.

### What is a *post-processor*

A *post-processor*, sometimes simply referred to as a *post*, is the link between the CAM system and your CNC machine. A CAM system will typically output a neutral intermediate file that contains information about each toolpath operation like tool data, type of operation (drilling, milling, turning, etc.), and tool center line data. This intermediate file is fed into the *post-processor* where it's translated into the language that a CNC machine understands. In most cases this language is a form of ISO/EIA standard G-code, even though some controls have their own proprietary language or use a more conversational language.

## Resources

On this repository we have folders with different resources for the Snapmaker 2.0 CNC module to work with Fusion 360.  
You can browse the [_Machine Library_](/Fusion%20360/Machine%20Library), the [_Post-Processor_](/Fusion%20360/Post-Processor), and the [_Tool Library_](/Fusion%20360/Tool%20Library) directories for resources.
