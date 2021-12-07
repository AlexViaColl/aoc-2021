with Ada.Command_Line;
with Ada.Containers.Vectors;
with Ada.Containers;
with Ada.Direct_IO;
with Ada.Directories;
with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure Day_07 is
    package Integer_Vectors is new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => Integer);
    use Integer_Vectors;

    function Read_File(File_Path: String) return String is
        File_Size : Natural := Natural(Ada.Directories.Size(File_Path));
    
        subtype File_String    is String (1 .. File_Size);
        package File_String_IO is new Ada.Direct_IO(File_String);
    
        File     : File_String_IO.File_Type;
        Contents : File_String;
    
    begin
        File_String_IO.Open(File, Mode => File_String_IO.In_File, Name => File_Path);
        File_String_IO.Read(File, Item => Contents);
        File_String_IO.Close(File);

        -- Ada.Text_IO.Put(Contents);
        return Contents;
    end Read_File;

    function Get_Positions(Contents: String) return Vector is
        Start: Natural;
        Idx: Natural;
        Cnt: Natural;
        V: Vector;
    begin
        Cnt := Ada.Strings.Fixed.Count(Source  => Contents, Pattern => ",");
        Idx := 0;
        Start := 1;
        for I in 1 .. Cnt loop
            Idx := Ada.Strings.Fixed.Index(Source => Contents, Pattern => ",", From => Idx + 1);
            V.Append(Integer'Value(Contents(Start..Idx - 1)));
            Start := Idx + 1;
        end loop;
        V.Append(Integer'Value(Contents(Start..Contents'Last)));
        return V;
    end Get_Positions;

    function Total(Value: Integer) return Integer is
    begin
        if Value <= 1 then
            return Value;
        else
            return Value + Total(Value - 1);
        end if;
    end Total;

    procedure Part1(File_Path: String) is
        Contents: String := Read_File(File_Path);
        Median: Natural;
        Fuel: Natural;
        V: Vector;

        package Integer_Vectors_Sorting is new Integer_Vectors.Generic_Sorting;
        use Integer_Vectors_Sorting;
    begin
        V := Get_Positions(Contents);
        Sort(V);

        Median := V(Natural(V.Length) / 2);

        Fuel := 0;
        for E of V loop
            Fuel := Fuel + abs(E - Median);
        end loop;

        Ada.Text_IO.Put_Line("Part 1: " & Integer'Image(Fuel));
    end Part1;

    procedure Part2(File_Path: String) is
        Contents: String := Read_File(File_Path);
        Min: Natural;
        Max: Natural;
        Fuel: Natural;
        Min_Fuel: Natural;
        V: Vector;

        package Integer_Vectors_Sorting is new Integer_Vectors.Generic_Sorting;
        use Integer_Vectors_Sorting;
    begin
        V := Get_Positions(Contents);
        Sort(V);

        Min := V.First_Element;
        Max := V.Last_Element;

        Min_Fuel := 99999999;
        for I in Min .. Max loop
            Fuel := 0;
            for Pos of V loop
                Fuel := Fuel + Total(abs(Pos - I));
            end loop;

            if Fuel < Min_Fuel then
                Min_Fuel := Fuel;
            end if;
        end loop;

        Ada.Text_IO.Put_Line("Part 2: " & Integer'Image(Min_Fuel));
    end Part2;

begin
    for I in 1..Ada.Command_Line.Argument_Count loop
        Part1(Ada.Command_Line.Argument(I));
        Part2(Ada.Command_Line.Argument(I));
    end loop;
end Day_07;