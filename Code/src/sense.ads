with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with MicroBit.Ultrasonic;
with MicroBit.Types; use MicroBit.Types;


package Sense is

   protected DistanceValues is
      function ReadLeftSensor return Distance_cm;
      function ReadRightSensor return Distance_cm;

      procedure UpdateSensors (l_Distance : Distance_cm; r_Distance : Distance_cm);


   private
      leftDistance : Distance_cm;
      rightDistance : Distance_cm;
   end DistanceValues;

   task Sensor with Priority => 1;


end Sense;
