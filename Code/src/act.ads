with priorities; use priorities;
with ProtectedObjects; use ProtectedObjects;

package Act is
   task Act with
   Priority => Priorities.Act;

   procedure Set_Forward;

   procedure Set_Right;

   procedure Set_Left;

   procedure Stop;
end Act;
