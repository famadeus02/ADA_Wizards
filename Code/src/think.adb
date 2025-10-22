with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with Ada.Real_Time;  use Ada.Real_Time;
with MicroBit.Types; use MicroBit.Types;

with ProtectedObjects; use ProtectedObjects;

package body Think is
   procedure ParseSensor (raw_distanceL, raw_distanceR : Distance_cm; sensors : out Sensors_State) is
      MINIMUM_DISTANCE : constant Distance_cm := 10;
      l_true, r_true : Boolean := False;
   begin

      -- Check if reading from sensor is 0 which means out of range,
      --  or within reading range but outside of minimum distance.
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

      if not l_true and not r_true then
         sensors := None;
      elsif l_true and not r_true then
         sensors := Left;
      elsif not l_true and r_true then
         sensors := Right;
      elsif l_true and r_true then
         sensors := Both;
      else
         null;
      end if;

   end ParseSensor;


task body ThinkTask is

   -- Look at link for how-to on transitions between states
   -- http://www.inspirel.com/articles/Ada_On_Cortex_Finite_State_Machines_2.html
   --  type TransitionTable is array(Act_States, Sensors_State) of Act_States;


   -- Subtype of Act_States, only allows left/right keywords
   subtype Turns is Act_States range Left .. Right;

   -- Variables for task
   raw_LeftSensor, raw_RightSensor : Distance_cm;
   Sensors : Sensors_State;
   currentState : Act_States := Stop; -- Initial Act_State
   currentTurn : Turns := Left; -- Initial turn status

   -- Variables for timing
   iterationAmount : constant Integer := 10;
   iterationCounter : Integer := 1;
   startTime : Time := Clock;
   elapsedTime : Time_Span;

begin
loop

   raw_LeftSensor := DistanceValues.ReadLeftSensor;
   raw_RightSensor := DistanceValues.ReadRightSensor;
   ParseSensor (raw_LeftSensor, raw_RightSensor, Sensors);

   case Sensors is
      when None => currentState := Forward;
      when Left =>
         currentState := Right;
         currentTurn := Right;
      when Right =>
         currentState := Left;
         currentTurn := Left;
      when Both => currentState := Rotate;
   end case;


   if currentState = Rotate then
      ThinkResults.UpdateActState (currentTurn);
   else
      ThinkResults.UpdateActState (currentState);
   end if;

end loop;
end ThinkTask;
end Think;
