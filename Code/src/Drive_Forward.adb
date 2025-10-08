with MicroBit.MotorDriver; use MicroBit.MotorDriver; --using the procedures defined here
with DFR0548;  -- using the types defined here

with MicroBit.Console; use MicroBit.Console; -- for serial port communication
use MicroBit; --for pin names

procedure Main is

begin
   MotorDriver.Servo(1,90);
   delay 1.0; -- equivalent of Time.Sleep(1000) = 1 second

   loop
      -- DEMONSTRATION ROUTINE 4 MOTORS (useful for checking your wiring)
      MotorDriver.Drive(Forward,(4095,0,0,0)); --right front wheel to M4
      Console.Put_Line("RF");
      delay 1.0;
      MotorDriver.Drive(Forward,(0,4095,0,0)); --right back wheel to M3
      Console.Put_Line("RB");
      delay 1.0;
      MotorDriver.Drive(Forward,(0,0,4095,0)); --left front wheel to M2
      Console.Put_Line("LF");
      delay 1.0;
      MotorDriver.Drive(Forward,(0,0,0,4095)); --left back wheel to M1
      Console.Put_Line("LB");
      delay 1.0;
      MotorDriver.Drive(Stop);

      -- DEMONSTRATION ROUTINE SERVO
      for I in reverse DFR0548.Degrees range 0..90 loop
         MotorDriver.Servo(1,I);
          delay 0.02; --20 ms
      end loop;

      for I in DFR0548.Degrees range 90..180 loop
         MotorDriver.Servo(1,I);
         delay 0.02; --20 ms
      end loop;

      for I in reverse DFR0548.Degrees range 90..180 loop
         MotorDriver.Servo(1,I);
          delay 0.02; --20 ms
      end loop;

   end loop;
end Main;