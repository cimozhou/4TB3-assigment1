Program Example50;

{ Program to demonstrate the Read(Ln) function. }

Type
	State = ( Normal, Strings, Character, Block_comment, Line_comment);
	Token = ( None, Slash, Star, SingleQuotation, DoubleQuotation);


Var S : String;
    C : Char;
	Currentchar : Char;
    F : File of char;
	F2 : File of char;
	fileString: Array of Char;
	newfileString: Array of Char;
	i : Integer;
	sum3 : Integer;
	sum2 : Integer;
	sum : Integer;
	Currentstate : State;
	Currenttoken: Token;
	Lasttoken: Token;
	
Procedure ReadFile;
begin
  Assign (F,'test1.c');
  Reset (F);
  C:='A';
  sum := 0;
  While not Eof(f) do
    Begin
	SetLength(fileString, sum+1);
    Read (F,C);
    Write (C);
	fileString[sum] := C;
	sum := sum + 1;

    end;
 Writeln;
 Close (F);
end;

Procedure RemoveComment;
begin
	Currenttoken := None;
	Lasttoken := None;
	Currentstate :=Normal;
	sum3 := 0;
	for i:=1 to length(fileString) do
	  begin
	  
	  Currentchar := fileString[i-1];
	  
	  case Currentchar of
		'"' : 
			Begin
			if Currentstate = Normal  then
				Begin
				Currenttoken := DoubleQuotation;
				Currentstate := Strings;
				SetLength(newfileString, sum3+1);
				newfileString[sum3] := Currentchar;
				sum3 := sum3 + 1;
				End
			else if Currentstate = Strings  then 
				Begin
				Currenttoken := None;
				Currentstate :=Normal;
				SetLength(newfileString, sum3+1);
				newfileString[sum3] := Currentchar;
				sum3 := sum3 + 1;
				End;
			End;
		#10 : 
			Begin
			if (Currentstate = Line_comment) then
				Begin
				Currenttoken := None;
				Currentstate :=Normal;
				End;
			End;
		'/' :
			Begin
			if (Currentstate = Block_comment) and (Currenttoken = Star) then
				Begin
				Currenttoken := None;
				Currentstate :=Normal;
				End
			else if (Currentstate = Strings) then
				Begin
					SetLength(newfileString, sum3+1);
					newfileString[sum3] := Currentchar;
					sum3 := sum3 + 1;
				End
			else if (Currentstate = Character) then
				Begin
					SetLength(newfileString, sum3+1);
					newfileString[sum3] := Currentchar;
					sum3 := sum3 + 1;
				End
			else if (Currentstate = Normal) and (Currenttoken = Slash) then
				Begin
                    Currentstate := Line_comment;
                    Currenttoken := None;
				End
			else
				Begin
					Currenttoken := Slash;
				End;
			End;	
		'*' :
			Begin
			if (Currentstate = Normal) and (Currenttoken = Slash) then
				Begin
				Currenttoken := None;
				Currentstate :=Block_comment;
				End
			else if(Currentstate = Block_comment) then 
				Begin
				Currenttoken := Star;
				End
			else if (Currentstate = Strings) or (Currentstate = Character) or (Currentstate = Normal) then
				Begin
				SetLength(newfileString, sum3+1);
				newfileString[sum3] := Currentchar;
				sum3 := sum3 + 1;
				End;
				
			End;
		else 
			Begin
			if (Currentstate = Strings) or (Currentstate = Character)then
				Begin
				SetLength(newfileString, sum3+1);
				newfileString[sum3] := Currentchar;
				sum3 := sum3 + 1;
				End
			else if(Currentstate = Normal) and (Currenttoken = Slash)then
				Begin
				SetLength(newfileString, sum3+2);
				newfileString[sum3] := '/';
				newfileString[sum3+1] := Currentchar;
				sum3 := sum3 + 2;
				Currenttoken := None;
				End
			else if(Currentstate = Normal) then
				Begin
				SetLength(newfileString, sum3+1);
				newfileString[sum3] := Currentchar;
				sum3 := sum3 + 1;
				End;
			End;
		 end;
		
	  end;
end;



Procedure EditFile;
begin
  Assign (F2,'test2.c');
  Rewrite (F2);
  sum2 := 0;
  for i:=1 to length(newfileString) do
	  begin
	  Write (F2,newfileString[sum2]); { No writeln allowed here ! }
	  sum2 := sum2 + 1;
	  end;
  Close (F2);
end;


begin
  ReadFile;
  RemoveComment;
  EditFile;
end.
