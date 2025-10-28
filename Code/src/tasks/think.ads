with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with MicroBit.Types; use MicroBit.Types;
with Priorities;


package Think is

   type Sensors_State is (None, Left, Right, Both); -- Sensor states,

   procedure ParseSensor (raw_distanceL, raw_distanceR : Distance_cm; sensors : out Sensors_State);

   task ThinkTask with Priority => Priorities.Think;

end Think;
