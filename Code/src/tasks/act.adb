with Ada.Real_Time;  use Ada.Real_Time;
with MicroBit; use MicroBit;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.Types; use MicroBit.Types;
with MotorDriverMOD; use MotorDriverMOD;


package body Act is

   -- Speed set to 2000 out of 4095:
   CAR_SPEED : constant Speeds := (2000,2000,2000,2000);

   procedure Set_Forward is
   begin
      MotorDriverMOD.Drive(Forward, CAR_SPEED);
   end Set_Forward;

   procedure Set_Right is
   begin
      MotorDriverMOD.Drive (Rotating_Right, CAR_SPEED);
   end Set_Right;

   procedure Set_Left is
   begin
      MotorDriverMOD.Drive (Rotating_Left, CAR_SPEED);
   end Set_Left;

   procedure Stop is
   begin
      MotorDriverMOD.Drive (Stop);
   end Stop;


task body Act is
   -- Task variables:
   currentState : Act_States := Initialize;
   startTime : Time;
   DEADLINE : constant Time_Span := Milliseconds (150);

   -- Timing variables:
   ComputeTime : constant Boolean := True;
   iterationAmount : constant Integer := 9;
   iterationCounter : Integer := 0;
   elapsedTime : Time_Span := Time_Span_Zero;

begin
   --  Put_Line ("TASK ACT START");
   loop
      startTime := Clock;
      currentState := ThinkResults.GetCurrentState; -- Fetches the current state.

      -- Acts based on currentstate:
      case currentState is
         when Forward =>
            Set_Forward;
            --  Put_Line ("FORWARD");
         when Left =>
            Set_Left;
            --  Put_Line ("LEFT");
         when Right =>
            Set_Right;
            --  Put_Line ("RIGHT");
         when Initialize =>
            Stop;
         when Rotate =>
            null; -- Rotate will be LEFT or RIGHT but has to be included to avoid errors.
      end case;

      --  Put_Line ("Act Task - Current State: " & Act_States'Image(currentState));

      if ComputeTime then
         elapsedTime := elapsedTime + ( Clock - startTime );
         iterationCounter := iterationCounter + 1;
         if iterationCounter = iterationAmount then

            iterationCounter := 0;
            elapsedTime := elapsedTime / iterationAmount;
            Put_Line ( "Average comp. time  --ACT--  TASK: "  & To_Duration(elapsedTime)'Image & " Seconds"); -- time elapsed
            elapsedTime := Time_Span_Zero;
            --  delay 0.5; -- Small delay to make results readable
         end if;
      end if;

      delay until startTime + DEADLINE;

   end loop;

end Act;

end Act;
