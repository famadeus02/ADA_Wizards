with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with MicroBit.Types; use MicroBit.Types;



package ProtectedObjects is


   -- Used in Act and Think
   type Act_States is (Initialize, Forward, Left, Right, Rotate);
   protected ThinkResults is

      function GetCurrentState return Act_States;

      procedure UpdateActState(newState : Act_States);

   private
      currentState : Act_States;

   end ThinkResults;


   -- Used in Sense and Think
   protected DistanceValues is
      function ReadLeftSensor return Distance_cm;
      function ReadRightSensor return Distance_cm;

      procedure UpdateSensors (l_Distance, r_Distance : Distance_cm);


   private
      leftDistance : Distance_cm;
      rightDistance : Distance_cm;
   end DistanceValues;


end ProtectedObjects;
