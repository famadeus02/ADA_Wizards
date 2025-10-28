with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with Ada.Real_Time;  use Ada.Real_Time;
with MicroBit.Types; use MicroBit.Types;

with ProtectedObjects; use ProtectedObjects;

package body Think is


task body ThinkTask is

   -- Look at link for how-to on transitions between states
   -- http://www.inspirel.com/articles/Ada_On_Cortex_Finite_State_Machines_2.html
   --  type TransitionTable is array(Act_States, Sensors_State) of Act_States;



   -- Subtype of Act_States, only allows left/right keywords
   subtype Turns is Act_States range Left .. Right;

   -- Variables for task
   raw_LeftSensor, raw_RightSensor : Distance_cm;
   Sensors : Sensors_State;
   currentState : Act_States := Initialize; -- Initial Act_State
   currentTurn : Act_States := Left; -- Initial turn status

   -- Variables for timing
   ComputeTime : constant Boolean := True;
   iterationAmount : constant Integer := 9;
   iterationCounter : Integer := 0;
   elapsedTime : Time_Span := Time_Span_Zero;
   startTime : Time := Clock;

   DEADLINE : constant Time_Span := Milliseconds (150);

begin
--  Put_Line ("TASK THINKING START");
loop
   startTime := Clock;
   --  Put_Line ("THINKING");

   raw_LeftSensor := DistanceValues.ReadLeftSensor;
   raw_RightSensor := DistanceValues.ReadRightSensor;
   ParseSensor (raw_LeftSensor, raw_RightSensor, Sensors);

   case Sensors is
      when None => currentState := Forward;
         --  Put_Line ("NO Sense");
      when Left =>
         currentState := Right;
         currentTurn := Right;
         --  Put_Line ("LEFT Sense");
      when Right =>
         currentState := Left;
         currentTurn := Left;
         --  Put_Line ("RIGHT Sens");
      when Both => currentState := Rotate;
         --  Put_Line ("BOTH sense");
   end case;


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
         --  delay 0.5; -- Small delay to make results readable
      end if;
   end if;
   -- ###Average of 10 compute time

   delay until startTime + DEADLINE;

end loop;
end ThinkTask;

procedure ParseSensor (raw_distanceL, raw_distanceR : Distance_cm; sensors : out Sensors_State) is

      -- Car has a deadzone on the sides, which are covered if the sensor range MINIMUM_DISTANCE is HIGHER then 18,3 cm
      MINIMUM_DISTANCE : constant Distance_cm := 19;
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

      -- Plagiat av Finite state machine papiret? Helt lik som en seksjon i første delen.
      -- Men også veldig universal
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
