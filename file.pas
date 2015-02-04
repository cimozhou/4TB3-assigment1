program filetest;

 
Uses sysutils;
 
var
 File1: TextFile;
 File2: TextFile;
 Str: String;
 
 Procedure ReadFile;
 begin
  Writeln('File Reading:');
  AssignFile(File1, 'Test.c');
  Try
    Reset(File1);
    repeat
      Readln(File1, Str); // Reads the whole line from the file
      Writeln(Str); // Writes the line read
    until(EOF(File1)); // EOF(End Of File) The the program will keep reading new lines until there is none.
    CloseFile(File1);
  except
    on E: EInOutError do
    begin
     Writeln('File handling error occurred. Details: '+E.ClassName+'/'+E.Message);
    end;    
  end;
  WriteLn('Program finished. Press enter to stop.');  
  Readln;
end;

Procedure EditFile;

 
begin
  WriteLn('Append file');

  Try
    AssignFile(File2, 'Test2.c');
    Append(File2); 
    Writeln(File2,'adding some text...');
    CloseFile(File2);
  except
    on E: EInOutError do
    begin
     Writeln('File handling error occurred. Details: '+E.ClassName+'/'+E.Message);
    end;    
  end;
  WriteLn('Program finished. Press enter to stop.');  
  Readln;
end;
begin
  ReadFile;
  EditFile;
end.