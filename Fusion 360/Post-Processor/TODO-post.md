
# TODO: *POST-PROCESSOR*

Here we'll have a list of features that I've consider implementing on the *post-processor* in the future, after the initial release.

Incomplete features are identified with an :o: and features already implemented are shown with a :heavy_check_mark:.

## Planned features

<!-- #Use :o: for incomplete tasks and :heavy_check_mark: for completed ones --> 
⭕ Implement property for machine type to allow different parameters as below:
    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⭕ Spindle value;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⭕ Z to retract to on pause command;
    
⭕ Set G0 feed rate on option to replace G1 with G0;

⭕ Update onSection() to remove redundant code;

⭕ Add an option to move the table forward (Y axis to the max value) after CNC to make the machined part more accessible;

⭕ Add an option to manually activate the *open-door* sensors via *g-code*;
