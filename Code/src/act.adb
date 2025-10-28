with Ada.Real_Time;  use Ada.Real_Time;
with MicroBit; use MicroBit;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.Types; use MicroBit.Types;
with MotorDriverMOD; use MotorDriverMOD;

package body Act is

   CAR_SPEED : constant Speeds := (4095,4095,4095,4095);

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
   currentState : Act_States := Initialize;
   startTime : Time;
   DEADLINE : constant Time_Span := Milliseconds (300);
begin
   Put_Line ("TASK ACT START!!");
   loop
      startTime := Clock;
      currentState := ThinkResults.GetCurrentState;

      case currentState is
         when Forward =>
            Set_Forward;
            Put_Line ("FORWARDS");
         when Left =>
            Set_Left;
            Put_Line ("LEFT");
         when Right =>
            Set_Right;
            Put_Line ("RIGHT");
         when Initialize =>
            Stop;
         when Rotate =>
            null;
      end case;

      Put_Line ("Act Task - Current State: " & Act_States'Image(currentState));
      delay until startTime + DEADLINE;

   end loop;
end Act;

end Act;
