with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with MicroBit.Ultrasonic;
with Ada.Real_Time;  use Ada.Real_Time;
with MicroBit.Types; use MicroBit.Types;
with ProtectedObjects; use ProtectedObjects;


package body Sense is

task body Sensor is

   -- Task variables:
   package leftSensor is new Ultrasonic(MB_P16, MB_P0); -- Left sensor
   package rightSensor is new Ultrasonic(MB_P15, MB_P1); -- Right sensor
   leftDist, rightDist : Distance_cm;
   startTime : Time := Clock;
   DEADLINE : constant Time_Span := Milliseconds (150);


   -- Timing variables:
   ComputeTime : constant Boolean := True;
   iterationAmount : constant Integer := 9;
   iterationCounter : Integer := 0;
   elapsedTime : Time_Span := Time_Span_Zero;


begin
   loop

      startTime := Clock;
      leftDist := leftSensor.Read;
      rightDist := rightSensor.Read;

      DistanceValues.UpdateSensors (leftDist, rightDist ); -- Comp. time ca 50 ms?


      --  ###Average of 10 compute time
      if ComputeTime then
         elapsedTime := elapsedTime + ( Clock - startTime );
         iterationCounter := iterationCounter + 1;
         if iterationCounter = iterationAmount then

            iterationCounter := 0;
            elapsedTime := elapsedTime / iterationAmount;
            Put_Line ( "Average comp. time  SENSE TASK: "  & To_Duration(elapsedTime)'Image & " Seconds"); -- time elapsed
            elapsedTime := Time_Span_Zero;
         end if;
      end if;
      -- ###Average of 10 compute time

      delay until startTime + DEADLINE;

   end loop;

end Sensor;

end Sense;
