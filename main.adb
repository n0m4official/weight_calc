with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

procedure main is

   ------------------------------
   -- Define load item structure
   ------------------------------
   type Load_Item is record
      Name   : String (1..20);
      Weight : Float;
      Arm    : Float;
   end record;

   type Load_List is array (Positive range <>) of Load_Item;

   function Moment(Item : Load_Item) return Float is
   begin
      return Item.Weight * Item.Arm;
   end Moment;

   ------------------------------
   -- Variables for user input
   ------------------------------
   Max_Items : constant Positive := 20;  -- maximum items user can enter
   Items     : array(1..Max_Items) of Load_Item;
   Count     : Natural := 0;             -- fixed warning

   Total_Weight : Float := 0.0;
   Total_Moment : Float := 0.0;
   CG           : Float;

   Temp_Name  : String(1..20);
   Last       : Natural;
   Temp_W     : Float;
   Temp_A     : Float;
   More_Items : Character;

begin
   Put_Line("=== Weight & Balance Calculator ===");

   loop
      Count := Count + 1;
      if Count > Max_Items then
         Put_Line("Maximum number of items reached.");
         exit;
      end if;

      -- Get item name
      Put("Enter item name: ");
      Get_Line(Temp_Name, Last);

      -- Get weight
      Put("Enter weight (lbs): ");
      Get(Temp_W);

      -- Get arm
      Put("Enter arm (inches): ");
      Get(Temp_A);

      -- Save into array (use only actual string length)
      Items(Count).Name   := (others => ' ');
      Items(Count).Name(1..Last) := Temp_Name(1..Last);
      Items(Count).Weight := Temp_W;
      Items(Count).Arm    := Temp_A;

      -- Ask user if they want to add another item
      Put("Add another item? (Y/N): ");
      Get(More_Items);
      New_Line;
      exit when More_Items = 'N' or More_Items = 'n';
   end loop;

   -- Calculate totals
   for I in 1..Count loop
      Total_Weight := Total_Weight + Items(I).Weight;
      Total_Moment := Total_Moment + Moment(Items(I));
   end loop;

   CG := Total_Moment / Total_Weight;

   -- Display results
   Put_Line("");
   Put_Line("=== Results ===");
   Put_Line("Total Weight = " & Float'Image(Total_Weight) & " lbs");
   Put_Line("Center of Gravity = " & Float'Image(CG) & " in");

end main;
