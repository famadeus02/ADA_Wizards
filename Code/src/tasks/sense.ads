with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with Priorities;


package Sense is

   task Sensor with Priority => Priorities.Sense;

end Sense;
