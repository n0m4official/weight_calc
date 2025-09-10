with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Main is

   -- Each item loaded in the plane
   type Load_Item is record
      Name   : Unbounded_String;      -- this fucking thing took me 7 hours to fix, and changing it broke everything. IDFK how or why.
      Weight : Float;
      Arm    : Float;
   end record;

   -- Aircraft profile
   type Aircraft_Profile is record
      Name         : Unbounded_String;
      Empty_Weight : Float;
      Empty_Arm    : Float;
      Min_CG       : Float;
      Max_CG       : Float;
   end record;

   -- Max items to carry
   Max_Items : constant Positive := 20;
   Items     : array(1..Max_Items) of Load_Item;
   Count     : Natural := 0;

   -- These three refused to work for so long that I actually started crying
   Total_Weight : Float;
   Total_Moment : Float;
   CG           : Float;

   Plane : Aircraft_Profile;
   
   -- Moment of an item
   function Moment(Item : Load_Item) return Float is
   begin
      return Item.Weight * Item.Arm;
   end Moment;

begin
   -- Temporary test: create a dummy aircraft
   Plane.Name := To_Unbounded_String("Cessna 172");
   Plane.Empty_Weight := 1500.0;
   Plane.Empty_Arm    := 37.0;
   Plane.Min_CG       := 34.0;
   Plane.Max_CG       := 42.0;

   -- Start with empty plane as first item
   Count := 1;
   Items(Count).Name   := Plane.Name;
   Items(Count).Weight := Plane.Empty_Weight;
   Items(Count).Arm    := Plane.Empty_Arm;

   -- Ask user for fuel (why did this one take me 7 fucking hours to fix, i had to rewrite this shit 10 fucking times)
   declare
      Fuel_Weight, Fuel_Arm : Float;
   begin
      Put("Enter fuel weight (lbs): ");
      Get(Fuel_Weight);
      Skip_Line;
      Put("Enter fuel arm (inches): ");
      Get(Fuel_Arm);
      Skip_Line;

      Count := Count + 1;
      Items(Count).Name   := To_Unbounded_String("Fuel");
      Items(Count).Weight := Fuel_Weight;
      Items(Count).Arm    := Fuel_Arm;
   end;

   -- Add passengers/cargo
   loop
      Count := Count + 1;
      exit when Count > Max_Items;

      declare
         Name_Buffer : String(1..100);
         Last        : Natural;
         W, A        : Float;
      begin
         Put("Enter item name (or empty to finish): ");
         Get_Line(Name_Buffer, Last);
         exit when Last = 0;
         Items(Count).Name := To_Unbounded_String(Name_Buffer(1..Last));

         Put("Enter weight (lbs): ");
         Get(W);
         Skip_Line;
         Put("Enter arm (inches): ");
         Get(A);
         Skip_Line;

         Items(Count).Weight := W;
         Items(Count).Arm    := A;
      end;
   end loop;

   -- Calculate totals
   Total_Weight := 0.0;
   Total_Moment := 0.0;
   for I in 1..Count loop
      Total_Weight := Total_Weight + Items(I).Weight;
      Total_Moment := Total_Moment + Moment(Items(I));
   end loop;

   CG := Total_Moment / Total_Weight;

   -- Display results
   Put_Line("=== Results ===");
   Put_Line("Total Weight = " & Float'Image(Total_Weight) & " lbs");
   Put_Line("Center of Gravity = " & Float'Image(CG) & " in");

   -- Check CG limits
   if CG < Plane.Min_CG then
      Put_Line("WARNING: CG IS TOO FAR FORWARD!");
   elsif CG > Plane.Max_CG then
      Put_Line("WARNING: CG IS TOO FAR AFT!");
   else
      Put_Line("CG is within safe limits.");
   end if;

end Main;
