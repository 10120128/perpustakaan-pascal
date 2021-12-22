
Unit Utils;

{$mode objfpc}{$H+}

Interface

Uses Crt;

(* procedure to show an message *)
Procedure ShowMessage(x, y: integer; message: String; color: byte; totalDelay:
                     longint);

(* procedure to show text with gotoxy *)
Procedure Text(x, y: Integer; content: String);
(* procedure for showing header app. X:5 Y:5 *)
Procedure showHeader(title: String);
(* function for get confirmation from user. Returning Y/N *)
Function getConfirmation(x, y: integer; message: String; color: byte): char;

Implementation

Procedure ShowMessage(x, y: integer; message: String; color: byte;
                      totalDelay: longint);
Begin
  TextBackground(color);
  Text(x, y, message);
  Delay(totalDelay);
  TextBackground(Black);
  DelLine;
End;

Procedure Text(x, y: integer; content: String);
Begin
  GotoXY(x, y);
  Write(content);
End;

Procedure showHeader(title: String);
Begin
  TextColor(White);
  Text(5, 2, 'Perpustakaan Buku');

  TextColor(Yellow);
  Text(5, 3, 'v0.0.2');

  TextColor(White);
  Text(40, 2, 'Aplikasi perpustakaan sederhana dengan pascal.');

  TextColor(DarkGray);
  Text(40, 3, 'github.com/bagaswastu/perpustakaan_pascal');
  TextColor(White);

  // menu
  Text(5, 5, '[');
  TextBackground(LightGreen);
  Write(title);
  TextBackground(Black);
  WriteLn(']');
End;

Function getConfirmation(x, y: integer; message: String; color: byte): char;

Var 
  key: char;
Begin
  Repeat
    TextColor(color);
    GotoXY(x, y);
    Write(message, ' (Y/N)');
    TextColor(White);
    key := ReadKey;
  Until (upcase(key) = 'Y') Or (upcase(key) = 'N');
  Result := UpCase(key);
End;

End.
