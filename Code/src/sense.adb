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



task body Sensor is

package leftSensor is new Ultrasonic(MB_P16, MB_P0); -- Left sensor
package rightSensor is new Ultrasonic(MB_P15, MB_P1); -- Right sensor

iterationAmount : constant Integer := 10;
iterationCounter : Integer := 0;
startTime : Time := Clock;
elapsedTime : Time_Span;


begin
   loop

      if iterationCounter = iterationAmount then

         iterationCounter := 0;
         elapsedTime := elapsedTime / iterationAmount;
         Put_Line ( "Average comp. time of reading sensor values: "  & To_Duration(elapsedTime)'Image ); -- time elapsed
      end if;

      startTime := Clock;

      DistanceValues.UpdateSensors (leftSensor.Read, rightSensor.Read ); -- Comp. time ca 50 ms?


      elapsedTime := elapsedTime + ( Clock - startTime );
      iterationCounter := iterationCounter + 1;
      --  delay until startTime + Milliseconds (75) ;
   end loop;
end Sensor;


end Sense;
