with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with Ada.Real_Time;  use Ada.Real_Time;
with MicroBit.Types; use MicroBit.Types;

with ProtectedObjects; use ProtectedObjects;

package body PrintSense is
   task body PrintSense is
   startTime : Time;
   myDistance : Distance_cm := 0;
   begin
      Put_Line ("START PRINT SENSE");
      loop
         startTime := Clock;
         myDistance := DistanceValues.ReadLeftSensor;
         Put_Line ("My distance: " & myDistance'Image);
         delay until startTime + Milliseconds (500);
      end loop;
   end PrintSense;
end PrintSense;
