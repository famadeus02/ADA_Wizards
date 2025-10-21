with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with MicroBit.Ultrasonic;
with Ada.Real_Time;  use Ada.Real_Time;
with MicroBit.Types; use MicroBit.Types;


package body Sense is


protected body DistanceValues is

function ReadLeftSensor return Distance_cm is
begin
   return leftDistance;
end ReadLeftSensor;

function ReadRightSensor return Distance_cm is
begin
   return rightDistance;
end ReadRightSensor;

procedure UpdateSensors ( l_Distance : Distance_cm; r_Distance : Distance_cm ) is
begin
   leftDistance := l_Distance;
   rightDistance := r_Distance;

end UpdateSensors;

end DistanceValues;



-- Worst Case Compute Time is 0.131927490 Seconds.
-- Happens mainly if ranges of both sensor drasticly change (i think)
-- Best case (No change in distance) is 0.0136
task body Sensor is

package leftSensor is new Ultrasonic(MB_P16, MB_P0); -- Left sensor
package rightSensor is new Ultrasonic(MB_P15, MB_P1); -- Right sensor

iterationAmount : constant Integer := 10;
iterationCounter : Integer := 1;
startTime : Time := Clock;
elapsedTime : Time_Span;


begin
   loop


      startTime := Clock;


      DistanceValues.UpdateSensors (leftSensor.Read, rightSensor.Read ); -- Comp. time ca 50 ms?


      -- Time of 1 compute
      elapsedTime := (Clock - startTime);
      Put_Line ("One reading time: " & To_Duration(elapsedTime)'Image & "Seconds");
      delay 0.5;

      -- Average of 10 compute time
      --  elapsedTime := elapsedTime + ( Clock - startTime );
      --  iterationCounter := iterationCounter + 1;
      --  if iterationCounter = iterationAmount then

      --     iterationCounter := 1;
      --     elapsedTime := elapsedTime / iterationAmount;
      --     Put_Line ( "Average comp. time of reading sensor values: "  & To_Duration(elapsedTime)'Image & " Seconds"); -- time elapsed
      --     elapsedTime := Time_Span_Zero;
      --     delay 0.5;
      --  end if;
   end loop;
end Sensor;


end Sense;
