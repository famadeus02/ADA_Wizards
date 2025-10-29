with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with Ada.Real_Time;  use Ada.Real_Time;
with MicroBit.Types; use MicroBit.Types;
with ProtectedObjects; use ProtectedObjects;


package body Think is

task body ThinkTask is

   -- Subtype of Act_States, only allows left/right keywords.
   subtype Turns is Act_States range Left .. Right;

   -- Task variables:
   raw_LeftSensor, raw_RightSensor : Distance_cm;
   Sensors : Sensors_State;
   currentState : Act_States := Initialize; -- Initial Act_State
   currentTurn : Act_States := Left; -- Initial turn status
   startTime : Time := Clock;
   DEADLINE : constant Time_Span := Milliseconds (150);

   -- Timing variables:
   ComputeTime : constant Boolean := True;
   iterationAmount : constant Integer := 9;
   iterationCounter : Integer := 0;
   elapsedTime : Time_Span := Time_Span_Zero;



begin
--  Put_Line ("TASK THINK START");
loop
   startTime := Clock;
   --  Put_Line ("THINKING");

   raw_LeftSensor := DistanceValues.ReadLeftSensor;
   raw_RightSensor := DistanceValues.ReadRightSensor;
   ParseSensor (raw_LeftSensor, raw_RightSensor, Sensors);

   -- Updating 'currentState' and 'currentTurn' based on sensor readings:
   case Sensors is
      when None => currentState := Forward;
         --  Put_Line ("NON Sensed");
      when Left =>
         currentState := Right;
         currentTurn := Right;
         --  Put_Line ("LEFT Sensed");
      when Right =>
         currentState := Left;
         currentTurn := Left;
         --  Put_Line ("RIGHT Sensed");
      when Both => currentState := Rotate;
         --  Put_Line ("BOTH Sensed");
   end case;

   -- When in state rotate, it will continue turning in the direction it began turning:
   if currentState = Rotate then
      ThinkResults.UpdateActState (currentTurn);
   else
      ThinkResults.UpdateActState (currentState);
   end if;

   --  ###Average of 10 compute time
   if ComputeTime then
      elapsedTime := elapsedTime + ( Clock - startTime );
      iterationCounter := iterationCounter + 1;
      if iterationCounter = iterationAmount then

         iterationCounter := 0;
         elapsedTime := elapsedTime / iterationAmount;
         Put_Line ( "Average comp. time  THINK TASK: "  & To_Duration(elapsedTime)'Image & " Seconds"); -- time elapsed
         elapsedTime := Time_Span_Zero;
         --  delay 0.5; -- Small delay used to make results readable in the Serial Monitor.
      end if;
   end if;
   -- ###Average of 10 compute time

   delay until startTime + DEADLINE;

end loop;
end ThinkTask;


procedure ParseSensor (raw_distanceL, raw_distanceR : Distance_cm; sensors : out Sensors_State) is

      -- Car has a deadzone on the sides, which are covered if the sensor range MINIMUM_DISTANCE is HIGHER than 18,3cm.
      MINIMUM_DISTANCE : constant Distance_cm := 19;
      l_true, r_true : Boolean := False;
   begin

      -- Checking if the reading from the sensors is 0, which means out of range.
      --  Or if its within reading range but outside of minimum distance.
      if raw_distanceL = 0 or raw_distanceL > MINIMUM_DISTANCE then
         l_true := False;
      else
         l_true := True;
      end if;

      if raw_distanceR = 0 or raw_distanceR > MINIMUM_DISTANCE then
         r_true := False;
      else
         r_true := True;
      end if;

      -- Using sensor inputs to define variables:
      if not l_true and not r_true then
         sensors := None;
      elsif l_true and not r_true then
         sensors := Left;
      elsif not l_true and r_true then
         sensors := Right;
      elsif l_true and r_true then
         sensors := Both;
      else
         sensors := Both;
      end if;

   end ParseSensor;
end Think;
