
Program perpustakaan_pascal;

Uses 
Crt,
SysUtils, Utils, BookController;

Var 
  menuSelection: Char;

Begin
  Repeat
    clrscr;
    initial();
    showHeader('Pilihan Menu');

    // Menu selection
    TextColor(LightGray);
    Text(5, 7, '1. Tambah Buku');
    Text(5, 8, '2. Lihat Buku');
    Text(5, 9, '3. Edit Buku');
    Text(5, 10, '4. Hapus Buku');
    Text(5, 11, '5. Cari Buku');

    // Author identifier
    Text(5, 27, 'Nama : Bagas Wastu Wiratama');
    Text(5, 28, 'Kelas: IF-4');
    Text(5, 29, 'NIM  : 10120128');
    TextColor(White);

    Text(5, 13, 'Pilih Menu: ');
    menuSelection := ReadKey;

    Case menuSelection Of 
      '1': createBook();
      '2': viewBooks();
      '3': updateBook();
      '4': deleteBook();
      '5': searchBook();
      Else
        Continue;
    End;
  Until (menuSelection = '0');

  readln;
End.
