with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with MicroBit.Ultrasonic;
with Ada.Real_Time;  use Ada.Real_Time;
with MicroBit.Types; use MicroBit.Types;
with Ada.Execution_Time; use Ada.Execution_Time;


package body Sense is


protected body distanceValues is

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

end distanceValues;



task body Sensor is

package leftSensor is new Ultrasonic(MB_P16, MB_P0); -- Left sensor
package rightSensor is new Ultrasonic(MB_P15, MB_P1); -- Right sensor
startTime : Time := Clock;

begin
   loop
      startTime := Clock;

      distanceValues.UpdateSensors (leftSensor.Read, rightSensor.Read ); -- Comp. time ca 50 ms?


      delay until startTime + Milliseconds (75) ;
   end loop;
end Sensor;


end Sense;
