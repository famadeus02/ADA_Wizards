with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with MicroBit.Ultrasonic;
with MicroBit.Types; use MicroBit.Types;
with Priorities;

package Sense is

   task Sensor with Priority => Priorities.Sense;


end Sense;
