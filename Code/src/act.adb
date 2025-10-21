with Ada.Real_Time;  use Ada.Real_Time;
with MicroBit; use MicroBit;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.Types; use MicroBit.Types;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with DFR0548;
with think;

package body Act is

   subtype Speed is Integer range -4_095 .. 4_095;

   procedure Set_Forward (Forward : Speed) is
   begin
      if Forward > 0 then
         MotorDriver.Drive(DFR0548.Forward, (Forward, Forward, Forward, Forward));
      elsif Forward < 0 then
         MotorDriver.Drive(DFR0548.Backward, (-Forward, -Forward, -Forward, -Forward));
      else
         MotorDriver.Drive(DFR0548.Stop);
      end if;
   end Set_Forward;

   procedure Set_Right (Right : Speed) is
   begin
      if Right > 0 then
         -- Left wheels forward, right wheels stop
         MotorDriver.Drive(DFR0548.Forward, (0, 0, Right, Right));
      elsif Right < 0 then
         -- Right wheels backward, left wheels stop
         MotorDriver.Drive(DFR0548.Backward, (-Right, -Right, 0, 0));
      else
         MotorDriver.Drive(DFR0548.Stop);
      end if;
   end Set_Right;

   procedure Set_Left (Left : Speed) is
   begin
      if Left > 0 then
         -- Right wheels forward, left wheels stop
         MotorDriver.Drive(DFR0548.Forward, (Left, Left, 0, 0));
      elsif Left < 0 then
         -- Left wheels backward, right wheels stop
         MotorDriver.Drive(DFR0548.Backward, (0, 0, -Left, -Left));
      else
         MotorDriver.Drive(DFR0548.Stop);
      end if;
   end Set_Left;

   procedure Set_Rotation (Rotation : Speed) is
   begin
      if Rotation > 0 then
         -- Left wheels forward, right wheels backward
         MotorDriver.Drive(DFR0548.Forward, (0, 0, Rotation, Rotation));
         MotorDriver.Drive(DFR0548.Backward, (-Rotation, -Rotation, 0, 0));
      elsif Rotation < 0 then
         -- Right wheels forward, left wheels backward
         MotorDriver.Drive(DFR0548.Forward, (Rotation, Rotation, 0, 0));
         MotorDriver.Drive(DFR0548.Backward, (0, 0, -Rotation, -Rotation));
      else
         MotorDriver.Drive(DFR0548.Stop);
      end if;
   end Set_Rotation;

   procedure Stop is
   begin
      MotorDriver.Drive(DFR0548.Stop);
   end Stop;

   task body Act is
      nextTime : Time := Clock;
   begin
      loop
      -- Move forward for 2ms
         Set_Forward (think.speedValue);
         nextTime := nextTime + Milliseconds(20);
         delay until nextTime;
      -- From Think get which sensor something is in front of (left or right)
        if
         think.obstacleLeft
         then
            -- Turn right for 2ms
            Set_Right (think.rightValue);
            nextTime := nextTime + Milliseconds(20);
            delay until nextTime;
         elsif
         think.obstacleRight
         then
            -- Turn left for 2ms
            Set_Left (think.leftValue);
            nextTime := nextTime + Milliseconds(20);
            delay until nextTime;
         end if;
         -- Rotate for 2ms
         Set_Rotation (think.rotationValue);
         nextTime := nextTime + Milliseconds(20);
         delay until nextTime;
      end loop;
   end Act;

end Act;
