
Unit BookController;

{$mode objfpc}{$H+}

Interface

Uses 
Utils, Crt, SysUtils;

Const 
  MAX = 1000;
  FILE_NAME = 'library_data.dat';

Type 
  TBook = Record
    isbn: String[13];
    title: String[30];
    author: String[20];
    genre: String[15];
  End;
  TBookList = array[1..MAX] Of TBook;

Var 
  listBookLength: Integer;
  found: Boolean;
  listBook: TBookList;

(* Initial procedure *)
Procedure initial();
(* Create book procedure *)
Procedure createBook();
(* Save data procedure *)
Procedure saveData();
(* Searh book procedure *)
Function bookSearch(isbn: String): Boolean;
(* Get actual book size, book that's not null *)
Function getActualBookSize(): Integer;
(* Sort list book by author *)
Procedure sortByAuthor();
(* Sort list book by title *)
Procedure SortByTitle();
(* Search list of book by author *)
Procedure searchBook();
(* View book procedure *)
Procedure viewBooks();
(* Update book procedure *)
Procedure updateBook();
(* Delete book procedure *)
Procedure deleteBook();

Implementation

Function bookIndex(isbn: String): Integer;

Var 
  i: Integer;
Begin
  found := False;
  i := 0;
  While (i <= listBookLength) And Not (found) Do
    Begin
      i := i + 1;
      If (listBook[i].isbn = isbn) Then
        found := True;
    End;
  If found Then
    Result := i;
End;

Procedure SortByTitle();

Var 
  i, j: Integer;
  T: TBook;
Begin
  For i := 1 To listBookLength - 1 Do
    For j := i + 1 To listBookLength Do
      If listBook[i].title > listBook[j].title Then
        Begin
          t := listBook[i];
          listBook[i] := listBook[j];
          listBook[j] := t;
        End;
End;

Procedure sortByAuthor();

Var 
  i, j: Integer;
  T: TBook;
Begin
  For i := 1 To listBookLength - 1 Do
    For j := i + 1 To listBookLength Do
      If listBook[i].author > listBook[j].author Then
        Begin
          t := listBook[i];
          listBook[i] := listBook[j];
          listBook[j] := t;
        End;
End;

Function getActualBookSize(): Integer;

Var 
  totalBook, j: Integer;
Begin
  // check actual total book
  totalBook := 0;
  For j := 1 To listBookLength Do
    Begin
      If listBook[j].title <> Default(String) Then
        Begin
          totalBook := totalBook + 1;
        End;
    End;
  Result := totalBook;
End;

Function bookSearch(isbn: String): Boolean;

Var 
  i: Integer;
Begin
  found := False;
  i := 0;
  While (i <= listBookLength) And (Not (found)) Do
    Begin
      i := i + 1;
      If (listBook[i].isbn = isbn) And (listBook[i].title <> '') Then
        found := True;
    End;
  If found Then
    Result := True
  Else
    Result := False;
End;

Procedure saveData;

Var 
  f: file Of TBook;
  i: Integer;
Begin
  Assign(f, FILE_NAME);
  //Hubungkan ke file
  rewrite(f);
  //buat file baru
  For i := 1 To listBookLength Do
    Write(f, listBook[i]);
  Close(f);
End;

Procedure readData();

Var 
  f: file Of TBook;
Begin
  Assign(f, FILE_NAME);
     {$i-}
  //menonaktifkan pemeriksaan IO
  reset(f);
  // Buka file
     {$i+}
  //Aktifkan kembali pemeriksaan IO
  If IOresult <> 0 Then      // Jika File Tidak Ditemukan
    rewrite(f);
  //buat file baru
  listBookLength := 0;
  //Banyak Data Kembali Ke 0
  While Not EOF(f) Do
    //selama belum end-of-file dari f
    Begin
      listBookLength := listBookLength + 1;
      Read(f, listBook[listBookLength]);
      //baca file simpan diakhir
    End;
  Close(f);
End;

Procedure createBook();

Var 
  title, isbn, author, genre: String;
  ulangi, save, keluar: char;
  totalData: Integer;
Begin
  Repeat
    Repeat
      clrscr;
      showHeader('Tambah Buku');

      totalData := getActualBookSize();

      GotoXY(20, 5);
      Write('Mengisi data ke-', totalData + 1);

      Text(5, 7, 'ISBN : ');
      readln(isbn);

      // ISBN Check
      If (bookSearch(isbn) = True) Then
        Begin
          GotoXY(5, 8);
          Write('Buku dengan ISBN: ', isbn,
                ' sudah tersedia (tekan <Enter> untuk melanjutkan)');
          ReadKey;
        End
      Else If (Length(isbn) <> 13) Then
             Begin
               GotoXY(5, 8);
               Write(

'ISBN harus berupa 13 angka (tekan <Enter> untuk melanjutkan, tekan <ESC> untuk keluar)'
               );
               keluar := ReadKey;
               If (keluar = #27) Then
                 Begin
                   Exit;
                   Exit;
                 End;
             End;

    Until (bookSearch(isbn) = False) And Not (Length(isbn) <> 13);

    // repeat if title == null
    repeat
      Text(5, 8, 'Judul buku: ');
      readln(title);

      if title = '' then
      ShowMessage(5, 9, 'Judul buku tidak boleh kosong', Yellow, 700);

    until title <> '';

    // repeat if author == null
    repeat
      Text(5, 9, 'Penulis: ');
      readln(author);

      if author = '' then
      ShowMessage(5, 10, 'Penulis buku tidak boleh kosong', Yellow, 700);

    until author <> '';

    // repeat if genre == null
    repeat
      Text(5, 10, 'Genre: ');
      readln(genre);

      if genre = '' then
      ShowMessage(5, 11, 'Genre buku tidak boleh kosong', Yellow, 700);

    until genre <> '';

    save := getConfirmation(5, 12, 'Simpan buku?', Yellow);
    DelLine;
    If (upcase(save) = 'Y') Then
      Begin
        listBookLength := listBookLength + 1;
        listBook[listBookLength].isbn := isbn;
        listBook[listBookLength].title := title;
        listBook[listBookLength].author := author;
        listBook[listBookLength].genre := genre;

        saveData();
        ShowMessage(5, 12, 'Berhasil menyimpan data!', Green, 1500);
      End;
    ulangi := getConfirmation(5, 12, 'Tambah buku lagi?', Yellow);
  Until (upcase(ulangi) = 'N');
End;

Procedure searchBook();

Var 
  isbn: String;
  doRepeat, back: char;
  index: Integer;
Begin
  Repeat
    Repeat
      clrscr;
      showHeader('Cari Buku');

      Text(5, 7, 'Masukan ISBN: ');
      readln(isbn);
      GoToXY(5, 7);
      DelLine;

      // Cek ISBN
      If (bookSearch(isbn) = True) Then
        Begin
          ShowMessage(5, 9, 'Buku berhasil ditemukan!', Green, 500);
        End
      Else If (Length(isbn) <> 13) Then
             Begin
               GotoXY(5, 8);
               Write(

'ISBN harus berupa 13 angka (tekan <Enter> untuk melanjutkan, tekan <ESC> untuk keluar)'
               );
               back := ReadKey;
               If (back = #27) Then
                 Begin
                   Exit;
                   Exit;
                 End;
             End
      Else
        Begin
          GotoXY(5, 8);
          Write('Buku dengan ISBN: ',
                isbn,

  ' tidak ditemukan (tekan <Enter> untuk melanjutkan, tekan <ESC> untuk keluar)'
          );
          back := ReadKey;
          If (back = #27) Then
            Begin
              Exit;
              Exit;
            End;
        End;
    Until (bookSearch(isbn) = True);

    index := bookIndex(isbn);
    GotoXY(5, 7);
    Write('ISBN: ', listBook[index].isbn);
    GotoXY(5, 8);
    Write('Judul Buku: ', listBook[index].title);
    GotoXY(5, 9);
    Write('Pengarang: ', listBook[index].author);
    GotoXY(5, 10);
    Write('Genre: ', listBook[index].genre);

    Text(5, 12, 'Ingin mencari data lagi? (Y/N): ');
    doRepeat := ReadKey();
  Until upcase(doRepeat) = 'N';
End;

Procedure viewBooks();

Var 
  i, j, totalData: Integer;

Var 
  hotkey: char;
Begin
  clrscr;
  showHeader('Data Buku');

  totalData := getActualBookSize();

  // message
  GotoXY(20, 5);
  Write('Tekan <Enter> untuk kembali');

  // Condition when there's no data
  If totalData = 0 Then
    Begin
      Text(5, 7, 'Tidak ada buku!');
      ReadKey;
    End
  Else
    Begin

      // sort data
      Text(5, 7, 'Tekan <1> Untuk mensortir data berdasarkan judul buku');
      Text(5, 8, 'Tekan <2> Untuk mensortir data berdasarkan penulis');

      TextColor(Brown);
      Text(5, 10,


'+----+---------------+-------------------------------+----------------------+-----------------+'
      );
      Text(5, 11,


'| NO |      ISBN     |          JUDUL BUKU           |        PENULIS       |       GENRE     |'
      );
      Text(5, 12,


'+----+---------------+-------------------------------+----------------------+-----------------+'
      );
      TextColor(White);
      j := 0;
      For i := 1 To listBookLength Do
        Begin
          If listBook[i].title <> Default(String) Then
            Begin
              j := j + 1;
              GotoXY(5, j + 12);
              Write('|', j: 3, ' ',
                    '| ', listBook[i].isbn, ' ',
                    '| ', format('%-30s', [listBook[i].title]), '',
              '| ', format('%-20s', [listBook[i].author]), ' ',
              '| ', format('%-15s', [listBook[i].genre]), ' |');
            End;
        End;
      Text(5, getActualBookSize() + 13,


'+----+---------------+-------------------------------+----------------------+-----------------+'
      );
      hotKey := ReadKey;

      // check hotkey
      // handle F1
      If hotKey = '1' Then
        Begin
          SortByTitle;
          viewBooks;
        End
      Else If hotKey = '2' Then
             Begin
               sortByAuthor;
               viewBooks;
             End;

    End;

End;

Procedure updateBook();

Var 
  isbn: String;
  save, doRepeat, back: char;
  newISBN, newTitle, newAuthor, newGenre: String;
  index: Integer;
Begin
  Repeat
    Repeat
      clrscr;
      showHeader('Edit Buku');

      Text(5, 7, 'ISBN: ');
      readln(isbn);

      // Cek ISBN
      If (bookSearch(isbn) = True) Then
        Begin
          ShowMessage(5, 9, 'Buku berhasil ditemukan!', Green, 1000);
        End
      Else If (Length(isbn) <> 13) Then
             Begin
               GotoXY(5, 8);
               Write(

'ISBN harus berupa 13 angka (tekan <Enter> untuk melanjutkan, tekan <ESC> untuk keluar)'
               );
               back := ReadKey;
               If (back = #27) Then
                 Begin
                   Exit;
                   Exit;
                 End;
             End
      Else
        Begin
          GotoXY(5, 8);
          Write('Buku dengan ISBN: ',
                isbn,

  ' tidak ditemukan (tekan <Enter> untuk melanjutkan, tekan <ESC> untuk keluar)'
          );
          back := ReadKey;
          If (back = #27) Then
            Begin
              Exit;
              Exit;
            End;
        End;
    Until (bookSearch(isbn) = True);

    index := bookIndex(isbn);
    TextColor(DarkGray);
    GotoXY(5, 7);
    Write('ISBN: ', listBook[index].isbn);
    GotoXY(5, 8);
    Write('Judul Buku: ', listBook[index].title);
    GotoXY(5, 9);
    Write('Pengarang: ', listBook[index].author);
    GotoXY(5, 10);
    Write('Genre: ', listBook[index].genre);
    TextColor(White);

    Text(20, 5, 'Kosongkan data jika tidak ingin diubah!');

    // Input edited data
    // check ISBN data
    Repeat
      GotoXY(5, 12);
      DelLine;
      Text(5, 12, 'ISBN: ');
      readln(newISBN);

      // check length & availability ISBN
      If (Length(newISBN) <> 13) Then
        Begin
          // if empty then break
          If newISBN = '' Then
            Break;

          GotoXY(5, 13);
          ShowMessage(5, 13, 'ISBN harus berupa 13 angka', Yellow, 1000);

          GotoXY(5, 12);
          DelLine;
        End
      Else If bookSearch(newISBN) = True Then
             Begin
               // if the ISBN is still same then continue
               If newISBN = listBook[index].isbn Then
                 Break;

               ShowMessage(5, 13, 'ISBN sudah terpakai', Yellow, 1000);
             End;
    Until (bookSearch(newISBN) = False) And (Length(newISBN) = 13);

    Text(5, 13, 'Judul Buku: ');
    readln(newTitle);
    Text(5, 14, 'Pengarang : ');
    readln(newAuthor);
    Text(5, 15, 'Genre : ');
    readln(newGenre);

    Text(5, 17, 'Simpan perubahan? (Y/N): ');
    save := ReadKey();

    // Change the data
    If (upcase(save) = 'Y') Then
      Begin
        If (newISBN = '') Then
          newISBN := listBook[index].isbn;
        If (newTitle = '') Then
          newTitle := listBook[index].title;
        If (newAuthor = '') Then
          newAuthor := listBook[index].author;
        If (newGenre = '') Then
          newGenre := listBook[index].genre;

        listBook[index].isbn := newISBN;
        listBook[index].title := newTitle;
        listBook[index].author := newAuthor;
        listBook[index].genre := newGenre;
        saveData();

        DelLine;
        ShowMessage(5, 17, 'Buku berhasil di-update!', Green, 1500);
      End;
    Text(5, 17, 'Ingin mengubah data lagi? (Y/N): ');
    doRepeat := ReadKey();
  Until upcase(doRepeat) = 'N';
End;

Procedure deleteBook();

Var 
  isbn: String;
  confirmation, doRepeat, back: char;
  index: Integer;

Begin
  Repeat
    Repeat
      clrscr;
      showHeader('Hapus Buku');

      Text(5, 7, 'ISBN: ');
      readln(isbn);

      // Cek ISBN
      If (bookSearch(isbn) = True) Then
        Begin
          ShowMessage(5, 9, 'Buku berhasil ditemukan!', Green, 1000);
        End
      Else If (Length(isbn) <> 13) Then
             Begin
               GotoXY(5, 8);
               Write(

'ISBN harus berupa 13 angka (tekan <Enter> untuk melanjutkan, tekan <ESC> untuk keluar)'
               );
               back := ReadKey;
               If (back = #27) Then
                 Begin
                   Exit;
                 End;
             End
      Else
        Begin
          GotoXY(5, 8);
          Write('Buku dengan ISBN: ',
                isbn,

  ' tidak ditemukan (tekan <Enter> untuk melanjutkan, tekan <ESC> untuk keluar)'
          );
          back := ReadKey;
          If (back = #27) Then
            Begin
              Exit;
            End;
        End;
    Until (bookSearch(isbn) = True);

    // show selected book
    index := bookIndex(isbn);
    TextColor(DarkGray);
    GotoXY(5, 7);
    Write('ISBN: ', listBook[index].isbn);
    GotoXY(5, 8);
    Write('Judul Buku: ', listBook[index].title);
    GotoXY(5, 9);
    Write('Pengarang: ', listBook[index].author);
    GotoXY(5, 10);
    Write('Genre: ', listBook[index].genre);
    TextColor(White);

    GotoXY(5, 12);
    DelLine;
    Text(5, 12, 'Apakah anda ingin menghapus data ini? (Y/N):');
    confirmation := ReadKey();

    If (upcase(confirmation) = 'Y') Then
      Begin
        listBook[index].isbn := Default(String);
        listBook[index].title := Default(String);
        listBook[index].author := Default(String);
        listBook[index].genre := Default(String);

        saveData;
        GotoXY(5, 12);
        DelLine;
        ShowMessage(5, 12, 'Berhasil menghapus buku!', Green, 1500);
      End;

    Text(5, 12, 'Ingin menghapus buku lagi? (Y/N): ');
    doRepeat := ReadKey();
  Until (upcase(doRepeat) = 'N');

End;

Procedure initial();
Begin
  listBookLength := 0;
  readData();
  clrscr;
End;

End.
