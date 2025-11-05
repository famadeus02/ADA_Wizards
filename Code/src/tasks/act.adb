with Ada.Real_Time;  use Ada.Real_Time;
with MicroBit; use MicroBit;
with MicroBit.Console; use MicroBit.Console;
with MotorDriverModified; use MotorDriverModified;

with MicroBit.DisplayRT;
with MicroBit.DisplayRT.Symbols;

package body Act is

   -- Speed set to 2000 out of 4095:
   CAR_SPEED : constant Speeds := (2000,2000,2000,2000);

   procedure Set_Forward is
   begin
      MotorDriverModified.Drive(Forward, CAR_SPEED);
   end Set_Forward;

   procedure Set_Right is
   begin
      MotorDriverModified.Drive (Rotating_Right, CAR_SPEED);
   end Set_Right;

   procedure Set_Left is
   begin
      MotorDriverModified.Drive (Rotating_Left, CAR_SPEED);
   end Set_Left;

   procedure Stop is
   begin
      MotorDriverModified.Drive (Stop);
   end Stop;


task body Act is

   -- Task variables:
   currentState : Act_States := Initialize;
   startTime : Time;
   PERIODE : constant Time_Span := Milliseconds (150);

   -- Timing variables:
   ComputeTime : constant Boolean := True;
   iterationAmount : constant Integer := 9;
   iterationCounter : Integer := 0;
   elapsedTime : Time_Span := Time_Span_Zero;

begin
   loop
      startTime := Clock;
      currentState := ThinkResults.GetCurrentState; -- Fetches the current state.

      DisplayRT.Clear;
      case currentState is
         when Forward =>
            Set_Forward;
            DisplayRT.Symbols.Up_Arrow;
         when Left =>
            Set_Left;
            DisplayRT.Symbols.Right_Arrow;
         when Right =>
            Set_Right;
            DisplayRT.Symbols.Left_Arrow;
         when Initialize =>
            Stop;
         when Rotate =>
            null; -- Rotate will be LEFT or RIGHT but has to be included to avoid errors.
      end case;


      --  ###Average of 10 compute time
      if ComputeTime then
         elapsedTime := elapsedTime + ( Clock - startTime );
         iterationCounter := iterationCounter + 1;
         if iterationCounter = iterationAmount then

            iterationCounter := 0;
            elapsedTime := elapsedTime / iterationAmount;
            Put_Line ( "Average comp. time  ACT TASK: "  & To_Duration(elapsedTime)'Image & " Seconds"); -- time elapsed
            elapsedTime := Time_Span_Zero;
         end if;
      end if;
      -- ###Average of 10 compute time

      delay until startTime + PERIODE;

   end loop;

end Act;

end Act;
