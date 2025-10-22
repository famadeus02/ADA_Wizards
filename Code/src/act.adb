with Ada.Real_Time;  use Ada.Real_Time;
with MicroBit; use MicroBit;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.Types; use MicroBit.Types;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with DFR0548;
with ProtectedObjects; use ProtectedObjects;
with HAL; use HAL;

package body Act is

   nextTime : Time := Clock;
   Fixed_Speed : constant Speed := 2_000;

   procedure Set_Forward (Forward : Speed) is
      Abs_Forward : Speed;
   begin
      if Forward > 0 then
         MotorDriver.Drive(MicroBit.MotorDriver.Forward,
                          (UInt12(Forward), UInt12(Forward), UInt12(Forward), UInt12(Forward)));
      elsif Forward < 0 then
         Abs_Forward := abs(Forward);
         MotorDriver.Drive(MicroBit.MotorDriver.Backward,
                          (UInt12(Abs_Forward), UInt12(Abs_Forward), UInt12(Abs_Forward), UInt12(Abs_Forward)));
      else
         MotorDriver.Drive(MicroBit.MotorDriver.Stop);
      end if;
   end Set_Forward;

   procedure Set_Rotation (Rotation : Speed) is
      Abs_Rotation : Speed;
   begin
      if Rotation > 0 then
         MotorDriver.Drive(MicroBit.MotorDriver.Forward, (0, 0, UInt12(Rotation), UInt12(Rotation)));
         MotorDriver.Drive(MicroBit.MotorDriver.Backward, (UInt12(Rotation), UInt12(Rotation), 0, 0));
      elsif Rotation < 0 then
         Abs_Rotation := abs(Rotation);
         MotorDriver.Drive(MicroBit.MotorDriver.Forward, (UInt12(Abs_Rotation), UInt12(Abs_Rotation), 0, 0));
         MotorDriver.Drive(MicroBit.MotorDriver.Backward, (0, 0, UInt12(Abs_Rotation), UInt12(Abs_Rotation)));
      else
         MotorDriver.Drive(MicroBit.MotorDriver.Stop);
      end if;
   end Set_Rotation;

   procedure Rotate_Degrees (Degrees : Integer) is
      Rotation_Speed : constant Speed := 1_500;
      Ms_Per_Degree : constant Integer := 10;
      Abs_Degrees : Integer;
      Duration : Time_Span;
      End_Time : Time;
   begin
      if Degrees = 0 then
         return;
      end if;

      Abs_Degrees := abs(Degrees);
      Duration := Milliseconds(Abs_Degrees * Ms_Per_Degree);

      if Degrees > 0 then
         Set_Rotation(Rotation_Speed);
      else
         Set_Rotation(0 - Rotation_Speed);
      end if;

      End_Time := Clock + Duration;
      delay until End_time;

      Stop;
   end Rotate_Degrees;

   procedure Set_Right (Right : Speed) is
      Abs_Right : Speed;
   begin
      if Right > 0 then
         MotorDriver.Drive(MicroBit.MotorDriver.Forward, (0, 0, UInt12(Right), UInt12(Right)));
      elsif Right < 0 then
         Abs_Right := abs(Right);
         MotorDriver.Drive(MicroBit.MotorDriver.Backward, (UInt12(Abs_Right), UInt12(Abs_Right), 0, 0));
      else
         MotorDriver.Drive(MicroBit.MotorDriver.Stop);
      end if;
   end Set_Right;

   procedure Set_Left (Left : Speed) is
      Abs_Left : Speed;
   begin
      if Left > 0 then
         MotorDriver.Drive(MicroBit.MotorDriver.Forward, (UInt12(Left), UInt12(Left), 0, 0));
      elsif Left < 0 then
         Abs_Left := abs(Left);
         MotorDriver.Drive(MicroBit.MotorDriver.Backward, (0, 0, UInt12(Abs_Left), UInt12(Abs_Left)));
      else
         MotorDriver.Drive(MicroBit.MotorDriver.Stop);
      end if;
   end Set_Left;

   procedure Stop is
   begin
      MotorDriver.Drive(MicroBit.MotorDriver.Stop);
   end Stop;

   task body Act is
      nextTime : Time := Clock;
      currentState : ProtectedObjects.Act_States;
      Turn_Angle : constant := 45;
   begin
      loop
         currentState := ProtectedObjects.ThinkResults.GetCurrentState;

         case currentState is
            when Initialize =>
               null;  -- Do nothing during initialization

            when Forward =>
               Set_Forward(Fixed_Speed);

            when Left =>
               Rotate_Degrees(0 - Turn_Angle);  -- Turn left 45 degrees

            when Right =>
               Rotate_Degrees(Turn_Angle);  -- Turn right 45 degrees

            when Rotate =>
               Set_Rotation(Fixed_Speed);  -- Continuous rotation

         end case;

         nextTime := nextTime + Milliseconds(20);
         delay until nextTime;

         Put_Line ("Act Task - Current State: " & Act_States'Image(currentState));

      end loop;
   end Act;

end Act;
