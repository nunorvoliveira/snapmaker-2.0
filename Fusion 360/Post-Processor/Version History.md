
# Version History

After the initial commit, the following changes were implemented.

A complete list can be seen on the post file itself.

## 20220403.1
- Changed the ACTION_PAUSE_RAISE_Z command to raise the Z axis to machine coordinates Z=334mm instead of the
  previous absolute value of Z=9999mm to keep the preview of the generated g-code realistic and to allow for a
  correct time estimation for the CNC program.
  
- In addition, the speed for raising the Z axis was increased from 200mm/min to 3000mm/min and the speed for
  lowering the Z axis after the pause was increased from 200mm/min to 1500mm/min.
  
- These 2 values are configurable on the post processor file on the "User configuration" section and are named:
    PAUSE_RAISE_Z_FEED_RATE_UP
    PAUSE_RAISE_Z_FEED_RATE_DOWN
    
- Big thanks to Ksdmg for pointing this out!
