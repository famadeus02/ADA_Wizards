with Ada.Real_Time;  use Ada.Real_Time;
with MicroBit; use MicroBit;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.Types; use MicroBit.Types;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with DFR0548;
with think;

package body Act is

   nextTime : Time := Clock;
   Fixed_Speed : constant Speed := 2_000;

   procedure Set_Forward (Forward : Speed) is
   begin
      if Forward > 0 then
         MotorDriver.Drive(DFR0548.Forward, (Forward, Forward, Forward, Forward));
      elsif Forward < 0 then
         -- Use abs() to get absolute value
         MotorDriver.Drive(DFR0548.Backward, (Forward, Forward, Forward, Forward));
      else
         MotorDriver.Drive(DFR0548.Stop);
      end if;
   end Set_Forward;

   procedure Set_Rotation (Rotation : Speed) is
      Abs_Rotation : Speed;
   begin
      if Rotation > 0 then
         -- Rotate clockwise: left wheels forward, right wheels backward
         MotorDriver.Drive(DFR0548.Forward, (0, 0, Rotation, Rotation));
         MotorDriver.Drive(DFR0548.Backward, (Rotation, Rotation, 0, 0));
      elsif Rotation < 0 then
         -- Rotate counter-clockwise: right wheels forward, left wheels backward
         Abs_Rotation := abs(Rotation);
         MotorDriver.Drive(DFR0548.Forward, (Rotation, Rotation, 0, 0));
         MotorDriver.Drive(DFR0548.Backward, (0, 0, Rotation, Rotation));
      else
         MotorDriver.Drive(DFR0548.Stop);
      end if;
   end Set_Rotation;

   procedure Rotate_Degrees (Degrees : Integer) is
      Rotation_Speed : constant Speed := 1_500;
      Ms_Per_Degree : constant Integer := 10; -- Might need calibration
      Abs_Degrees : Integer;
      Duration : Time_Span;
      End_Time : Time;
   begin
      if Degrees = 0 then
         return;
      end if;

      Abs_Degrees := abs(Degrees);
      Duration := Milliseconds(Degrees * Ms_Per_Degree);

      if Degrees > 0 then
         -- Rotate clockwise
         Set_Rotation(Rotation_Speed);
      else
         -- Rotate counter-clockwise - pass negative to trigger elsif branch
         Set_Rotation(0 - Rotation_Speed);
      end if;

      End_Time := Clock + Duration;
      delay until End_Time;

      Stop;
   end Rotate_Degrees;

   procedure Set_Right (Right : Speed) is
      Abs_Right : Speed;
   begin
      if Right > 0 then
         MotorDriver.Drive(DFR0548.Forward, (0, 0, Right, Right));
      elsif Right < 0 then
         Abs_Right := abs(Right);
         MotorDriver.Drive(DFR0548.Backward, (Right, Right, 0, 0));
      else
         MotorDriver.Drive(DFR0548.Stop);
      end if;
   end Set_Right;

   procedure Set_Left (Left : Speed) is
      Abs_Left : Speed;
   begin
      if Left > 0 then
         MotorDriver.Drive(DFR0548.Forward, (Left, Left, 0, 0));
      elsif Left < 0 then
         Abs_Left := abs(Left);
         MotorDriver.Drive(DFR0548.Backward, (0, 0, Left, Left));
      else
         MotorDriver.Drive(DFR0548.Stop);
      end if;
   end Set_Left;

   procedure Stop is
   begin
      MotorDriver.Drive(DFR0548.Stop);
   end Stop;

   task body Act is
      nextTime : Time := Clock;
      Current_State : think.Command_Type;
      Turn_Angle : constant := 45;
   begin
      loop
         Current_State := think.Get_Command;

         case Current_State is
            when think.Forward_Cmd =>
               Set_Forward(Fixed_Speed);

            when think.Backward_Cmd =>
               Set_Forward(0 - Fixed_Speed);

            when think.Turn_Left_Cmd =>
               Rotate_Degrees(0 - Turn_Angle);  -- Counter-clockwise

            when think.Turn_Right_Cmd =>
               Rotate_Degrees(Turn_Angle);  -- Clockwise

            when think.Set_Left_Cmd =>
               Set_Left(Fixed_Speed);

            when think.Set_Right_Cmd =>
               Set_Right(Fixed_Speed);

            when think.Stop_Cmd =>
               Stop;

         end case;

         nextTime := nextTime + Milliseconds(20);
         delay until nextTime;

      end loop;
   end Act;

end Act;
