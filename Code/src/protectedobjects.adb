with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with MicroBit.Types; use MicroBit.Types;


package body ProtectedObjects is

   protected body ThinkResults is

      function GetCurrentState return Act_States is
      begin
         return currentState;
      end GetCurrentState;

      procedure UpdateActState(newState : Act_States) is
      begin
         currentState := newState;
      end UpdateActState;

   end ThinkResults;



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



end ProtectedObjects;
