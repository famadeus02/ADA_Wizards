with Ada.Real_Time;  use Ada.Real_Time;
with MicroBit; use MicroBit;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.Types; use MicroBit.Types;
with MotorDriverMOD; use MotorDriverMOD;

with MicroBit.DisplayRT;
with MicroBit.DisplayRT.Symbols;

package body Act is

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
   -- Task variables
   currentState : Act_States := Initialize;
   startTime : Time;
   DEADLINE : constant Time_Span := Milliseconds (150);

   -- Variables for timing
   ComputeTime : constant Boolean := False;
   iterationAmount : constant Integer := 9;
   iterationCounter : Integer := 0;
   elapsedTime : Time_Span := Time_Span_Zero;
begin
   --  Put_Line ("TASK ACT START!!");
   loop
      startTime := Clock;
      currentState := ThinkResults.GetCurrentState;

      DisplayRT.Clear;
      case currentState is
         when Forward =>
            Set_Forward;
            DisplayRT.Symbols.Up_Arrow;
            --  Put_Line ("FORWARDS");
         when Left =>
            Set_Left;
            DisplayRT.Symbols.Right_Arrow;
            --  Put_Line ("LEFT");
         when Right =>
            Set_Right;
            DisplayRT.Symbols.Left_Arrow;
            --  Put_Line ("RIGHT");
         when Initialize =>
            Stop;
         when Rotate =>
            null;
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
