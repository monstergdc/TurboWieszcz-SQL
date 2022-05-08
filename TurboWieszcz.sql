
----------------------------------------------------------------
-- TurboWieszcz++ in MSSQL, v1.0
-- (c)2022 Noniewicz.com, Jakub Noniewicz aka MoNsTeR/GDC
-- based directly on (translated from): previous version written in pure C
-- which was based directly on: previous version written in Lazarus
-- which was based directly on:
-- previous version written for Commodore C-64 sometime in 1993
-- by me (Jakub Noniewicz) and Freeak (Wojtek Kaczmarek)
-- which was based on:
-- idea presented in "Magazyn Amiga" magazine and implemented by Marek Pampuch.
-- also inspired by version written for iPhone by Tomek (Grych) Gryszkiewicz.

-- Tested on: Microsoft SQL Server Express: 2012, 2014, 2016, 2019
-- Note: will not work on MSSQL 2008 and below due to use of CONCAT.
----------------------------------------------------------------
-- created: 20220507
-- updated: 20220508


USE [master]
GO

create database [TurboWieszcz] COLLATE Polish_CI_AS
go

use [TurboWieszcz]
go

----------------------------------------------------------------
-- Generate Turbo Wieszcz poem
-- parameters:
--   @cnt - count of stenza (1-32)
--   @tryb_rym - rhym mode: 0 = ABAB, 1 = ABBA, 2 = AABB
--   @powtorzeniaOk - 1 = repeats OK, 0 = no
-- return value:
--   @poem - poem text content
----------------------------------------------------------------

CREATE procedure [dbo].[TurboWieszcz](@cnt int, @tryb_rym smallint, @powtorzeniaOk bit, @poem VARCHAR(MAX) OUTPUT)
as
begin
  set @poem = ''
  if @cnt < 1 or @cnt > 32 return
  if @tryb_rym < 0 or @tryb_rym > 2 return

  SET NOCOUNT ON

  declare @data TABLE (z smallint not null, w smallint not null, txt varchar(100) not null)
  declare @titles TABLE (n int identity (1, 1) not null, txt varchar(100) not null, primary key (n))
  declare @ENDINGS TABLE (e int not null, n int not null, txt varchar(10) not null)
  declare @TRYB2ORDER TABLE (r int not null, w int not null, v int not null)

  -- po 10
  insert into @data (z, w, txt) values (0, 0, 'Czy na te zbrodnie nie bêdzie kary?') --updated
  insert into @data (z, w, txt) values (0, 1, 'Opustosza³y bagna, moczary')
  insert into @data (z, w, txt) values (0, 2, 'Na nic siê mod³y zdadz¹ ni czary')
  insert into @data (z, w, txt) values (0, 3, 'Z krwi mordowanych s¹cz¹ puchary')
  insert into @data (z, w, txt) values (0, 4, 'To nietoperze, wê¿e, kalmary')
  insert into @data (z, w, txt) values (0, 5, 'Pró¿no nieszczêœni sypi¹ talary')
  insert into @data (z, w, txt) values (0, 6, 'Za co nam znosiæ takie ciê¿ary')
  insert into @data (z, w, txt) values (0, 7, 'Z³owrogo iskrz¹ kóbr okulary')
  insert into @data (z, w, txt) values (0, 8, 'Pró¿no swe mod³y wznosi wikary') --new
  insert into @data (z, w, txt) values (0, 9, 'Pustosz¹ sny twoje z³e nocne mary') --new
  insert into @data (z, w, txt) values (0, 10, 'Pró¿no nieszczêœnik sypie talary') --grych
  insert into @data (z, w, txt) values (0, 11, 'Przedziwnie tka siê ¿ycia logarytm') --grych
  insert into @data (z, w, txt) values (0, 12, 'Ju¿ Strach wypuœci³ swoje ogary') --grych
  insert into @data (z, w, txt) values (0, 13, 'Niebawem zginiesz w szponach poczwary') --grych
  insert into @data (z, w, txt) values (0, 14, 'Wbijaj¹ pale z³ote kafary') --grych
  insert into @data (z, w, txt) values (0, 15, '¯ycie odkrywa swoje przywary') --grych
  insert into @data (z, w, txt) values (0, 16, 'Na dnie ponurej, pustej pieczary') --grych
  insert into @data (z, w, txt) values (0, 17, 'Apokalipsy nadesz³y czary') --frk
  insert into @data (z, w, txt) values (0, 18, 'Upad³y anio³ wspomina chwa³ê') --frk
  insert into @data (z, w, txt) values (0, 19, '¯ycie ukrywa swoje przywary') --grych LAME but used
  insert into @data (z, w, txt) values (0, 20, 'Dziwnych owadów wzlatuj¹ chmary') --new 201505
  insert into @data (z, w, txt) values (0, 21, 'Bombowce bior¹ nasze namiary') --201505 restored
  insert into @data (z, w, txt) values (0, 22, 'Nie da siê chwyciæ z czartem za bary') --201505 restored
  insert into @data (z, w, txt) values (0, 23, 'Pró¿no frajerzy sypi¹ talary')
  insert into @data (z, w, txt) values (0, 24, 'Nie da sie wyrwaæ czartom towaru')
  insert into @data (z, w, txt) values (0, 25, 'Po co nam s¹czyæ pod³e browary')
  insert into @data (z, w, txt) values (0, 26, 'Diler ju¿ nie dostarczy towaru')
  insert into @data (z, w, txt) values (0, 27, 'Lokomotywa nie ma ju¿ pary')
  insert into @data (z, w, txt) values (0, 28, 'Gdy nie ka¿dego staæ na browary')
  insert into @data (z, w, txt) values (0, 29, 'Po¿ar³ Hilary swe okulary')
  insert into @data (z, w, txt) values (0, 30, 'Spowi³y nas truj¹ce opary')
  insert into @data (z, w, txt) values (0, 31, 'To nie jest calka ani logarytm')

  -- po 8
  insert into @data (z, w, txt) values (1, 0, 'Ju¿ na arenê krew tryska')
  insert into @data (z, w, txt) values (1, 1, 'Ju¿ piana cieknie im z pyska')
  insert into @data (z, w, txt) values (1, 2, 'Ju¿ hen w oddali gdzieœ b³yska')
  insert into @data (z, w, txt) values (1, 3, 'Œmieræ w k¹cie czai siê bliska')
  insert into @data (z, w, txt) values (1, 4, 'Niesamowite duchów igrzyska')
  insert into @data (z, w, txt) values (1, 5, 'Ju¿ zaciskaj¹c ³apiska')
  insert into @data (z, w, txt) values (1, 6, 'Zamiast pozostaæ w zamczyskach')
  insert into @data (z, w, txt) values (1, 7, 'Rzeka wylewa z ³o¿yska')
  insert into @data (z, w, txt) values (1, 8, 'Nieszczêœæ wyla³a siê miska') --new
  insert into @data (z, w, txt) values (1, 9, 'Ju¿ zaciskaj¹c zêbiska') --my
  insert into @data (z, w, txt) values (1, 10, 'Otwarta nieszczêœæ walizka') --grych
  insert into @data (z, w, txt) values (1, 11, 'Niczym na rzymskich boiskach') --grych
  insert into @data (z, w, txt) values (1, 12, 'Czart wznieca swe paleniska') --my
  insert into @data (z, w, txt) values (1, 13, 'A w mroku œwiec¹ zêbiska') --grych - fix
  insert into @data (z, w, txt) values (1, 14, 'Zewsz¹d dochodz¹ wyzwiska') --grych
  insert into @data (z, w, txt) values (1, 15, 'Œwiêtych g³ód wiary przyciska') --my
  insert into @data (z, w, txt) values (1, 16, 'Ponuro patrzy z ich pyska') --grych
  insert into @data (z, w, txt) values (1, 17, 'Mg³a stoi na uroczyskach') --frk
  insert into @data (z, w, txt) values (1, 18, 'Koœci pogrzebi¹ urwiska') --frk
  insert into @data (z, w, txt) values (1, 19, 'G³ód wiary tak nas przyciska') --grych - BAD - fixed
  insert into @data (z, w, txt) values (1, 20, 'Runê³y skalne zwaliska')
  insert into @data (z, w, txt) values (1, 21, 'Czart rozpala paleniska') --grych - BAD fixed 201505
  insert into @data (z, w, txt) values (1, 22, 'A w mroku s³ychaæ wyzwiska') --added 20151129
  insert into @data (z, w, txt) values (1, 23, 'Znów pusta ¿ebraka miska')
  insert into @data (z, w, txt) values (1, 24, 'Diabelskie to s¹ igrzyska')
  insert into @data (z, w, txt) values (1, 25, 'Nie powiedz diab³u nazwiska')
  insert into @data (z, w, txt) values (1, 26, 'Najg³oœniej s³ychaæ wyzwiska')
  insert into @data (z, w, txt) values (1, 27, 'Diabelskie maj¹ nazwiska')
  insert into @data (z, w, txt) values (1, 28, 'Tam uciekaj¹ ludziska')
  insert into @data (z, w, txt) values (1, 29, 'Tak rzecze stara hipiska')
  insert into @data (z, w, txt) values (1, 30, 'Gdzie dawne ludzi siedliska')
  insert into @data (z, w, txt) values (1, 31, 'Najg³oœniej piszczy hipiska')

  -- po 10
  insert into @data (z, w, txt) values (2, 0, 'Rw¹ pazurami swoje ofiary')
  insert into @data (z, w, txt) values (2, 1, 'Nic nie pomo¿e tu druid stary')
  insert into @data (z, w, txt) values (2, 2, 'To nocne zjawy i senne mary')
  insert into @data (z, w, txt) values (2, 3, 'NiegroŸne przy nich lwowskie batiary')
  insert into @data (z, w, txt) values (2, 4, 'Pod wodz¹ ksiê¿nej diablic Tamary')
  insert into @data (z, w, txt) values (2, 5, 'Z dala straszliwe tr¹bia fanfary')
  insert into @data (z, w, txt) values (2, 6, 'Sk¹d ich przywiod³y piek³a bezmiary')
  insert into @data (z, w, txt) values (2, 7, 'Zaœ dooko³a ³uny, po¿ary')
  insert into @data (z, w, txt) values (2, 8, 'A twoje cia³o rozszarpie Wilk Szary') --new
  insert into @data (z, w, txt) values (2, 9, 'Tu nie pomo¿e ju¿ si³a wiary') --my
  insert into @data (z, w, txt) values (2, 10, 'Tak cudzych nieszczêœæ pij¹ nektary') --grych
  insert into @data (z, w, txt) values (2, 11, 'Wszystko zalewa wrz¹cy liparyt') --grych
  insert into @data (z, w, txt) values (2, 12, 'Zabójcze s¹ ich niecne zamiary') --my
  insert into @data (z, w, txt) values (2, 13, 'Zatrute dusze ³¹cz¹ siê w pary') --grych
  insert into @data (z, w, txt) values (2, 14, 'Œwiat pokazuje swoje wymiary') --grych
  insert into @data (z, w, txt) values (2, 15, 'Z ¿yciem siê teraz weŸmiesz za bary') --my
  insert into @data (z, w, txt) values (2, 16, 'Brak uczuæ, chêci, czasem brak wiary') --grych
  insert into @data (z, w, txt) values (2, 17, 'Wspomnij, co mówi³ Mickiewicz stary') --frk
  insert into @data (z, w, txt) values (2, 18, 'Spalonych lasów strasz¹ hektary') --frk
  insert into @data (z, w, txt) values (2, 19, 'Z ¿yciem siê dzisiaj weŸmiesz za bary') --grych - BAD - fixed
  insert into @data (z, w, txt) values (2, 20, 'Ksi¹dz pozostaje nagle bez wiary') --jn 201505 new
  insert into @data (z, w, txt) values (2, 21, 'Papie¿ zaczyna odprawiaæ czary') --jn 201505 new
  insert into @data (z, w, txt) values (2, 22, 'Tu nie pomo¿e paciorek, stary') --jn 201505 new
  insert into @data (z, w, txt) values (2, 23, 'NiegroŸne przy nich nawet Atari')
  insert into @data (z, w, txt) values (2, 24, 'Takie s¹ oto piek³a bezmiary')
  insert into @data (z, w, txt) values (2, 25, 'A teraz nagle jesteœ ju¿ stary')
  insert into @data (z, w, txt) values (2, 26, 'Mordercy licz¹ swoje ofiary')
  insert into @data (z, w, txt) values (2, 27, 'I bez wartoœci s¹ ju¿ dolary')
  insert into @data (z, w, txt) values (2, 28, 'Gdzie siê podzia³y te nenufary')
  insert into @data (z, w, txt) values (2, 29, 'Upada oto d¹b ten prastary')
  insert into @data (z, w, txt) values (2, 30, 'Bystro œmigaj¹ nawet niezdary')
  insert into @data (z, w, txt) values (2, 31, 'Ju¿ nieruchome ich awatary')

  -- po 8
  insert into @data (z, w, txt) values (3, 0, 'Wnet na nas te¿ przyjdzie kryska')
  insert into @data (z, w, txt) values (3, 1, 'Znik¹d ¿adnego schroniska')
  insert into @data (z, w, txt) values (3, 2, 'Powietrze tnie œwist biczyska')
  insert into @data (z, w, txt) values (3, 3, 'Rodem z czarciego urwiska')
  insert into @data (z, w, txt) values (3, 4, 'I sw¹d nieznoœny siê wciska')
  insert into @data (z, w, txt) values (3, 5, 'Huk, jak z wielkiego lotniska')
  insert into @data (z, w, txt) values (3, 6, 'Z³owroga brzmi¹ ich nazwiska')
  insert into @data (z, w, txt) values (3, 7, 'W k¹cie nieœmia³o ktoœ piska')
  insert into @data (z, w, txt) values (3, 8, 'Ktoœ obok morduje liska') --new
  insert into @data (z, w, txt) values (3, 9, 'Krwi¹ ociekaj¹ zêbiska') --my
  insert into @data (z, w, txt) values (3, 10, 'Woko³o dzikie piar¿yska') --grych, 20151129 fix JN
  insert into @data (z, w, txt) values (3, 11, 'I ¿¹dza czai siê niska') --grych
  insert into @data (z, w, txt) values (3, 12, 'Diabe³ ciê dzisiaj wyzyska') --grych
  insert into @data (z, w, txt) values (3, 13, 'P³on¹ zag³ady ogniska') --grych
  insert into @data (z, w, txt) values (3, 14, 'Gwa³t niech siê gwa³tem odciska!') --grych
  insert into @data (z, w, txt) values (3, 15, 'Stoisz na skraju urwiska') --my
  insert into @data (z, w, txt) values (3, 16, 'Tam szatan czarta wyiska') --grych
  insert into @data (z, w, txt) values (3, 17, 'Uciekaj, przysz³oœæ jest mglista') --frk, 20151025 changed
  insert into @data (z, w, txt) values (3, 18, 'Nadziei z³udzenie pryska') --frk
  insert into @data (z, w, txt) values (3, 19, 'Wydziobi¹ oczy ptaszyska') --grych - BAD fixed
  insert into @data (z, w, txt) values (3, 20, 'Padaj¹ ³by na klepisko') --new 201505 - restored
  insert into @data (z, w, txt) values (3, 21, 'Œmieræ zbiera ¿niwo w ko³yskach') --new 201505 - restored
  insert into @data (z, w, txt) values (3, 22, 'Coœ znowu zgrzyta w ³o¿yskach') --jn new 201505
  insert into @data (z, w, txt) values (3, 23, 'Spadasz z wielkiego urwiska')
  insert into @data (z, w, txt) values (3, 24, 'Lawa spod ziemi wytryska')
  insert into @data (z, w, txt) values (3, 25, 'Woko³o grzmi albo b³yska')
  insert into @data (z, w, txt) values (3, 26, 'Fa³szywe z³oto po³yska')
  insert into @data (z, w, txt) values (3, 27, 'Najwiêcej czart tu uzyska')
  insert into @data (z, w, txt) values (3, 28, 'Owieczki Z³y tu pozyska')
  insert into @data (z, w, txt) values (3, 29, 'Owieczki spad³y z urwiska')
  insert into @data (z, w, txt) values (3, 30, 'Snuj¹ siê dymy z ogniska')
  insert into @data (z, w, txt) values (3, 31, 'To czarne lec¹ ptaszyska')

  insert into @titles (txt) values ('Zag³ada')
  insert into @titles (txt) values ('To ju¿ koniec')
  insert into @titles (txt) values ('Œwiat ginie')
  insert into @titles (txt) values ('Z wizyt¹ w piekle')
  insert into @titles (txt) values ('Kataklizm')
  insert into @titles (txt) values ('Dzieñ z ¿ycia...')
  insert into @titles (txt) values ('Masakra')
  insert into @titles (txt) values ('Katastrofa')
  insert into @titles (txt) values ('Wszyscy zginiemy...')
  insert into @titles (txt) values ('Pokój?')
  insert into @titles (txt) values ('Koniec')
  insert into @titles (txt) values ('Koniec ludzkoœci')
  insert into @titles (txt) values ('Telefon do Boga')
  insert into @titles (txt) values ('Wieczne ciemnoœci')
  insert into @titles (txt) values ('Mrok')
  insert into @titles (txt) values ('Mrok w œrodku dnia')
  insert into @titles (txt) values ('Ciemnoœæ')
  insert into @titles (txt) values ('Piorunem w ³eb')
  insert into @titles (txt) values ('Marsz troli')
  insert into @titles (txt) values ('Szyderstwa Z³ego')
  insert into @titles (txt) values ('Okrponoœci œwiata')
  insert into @titles (txt) values ('Umrzeæ po raz ostatni')
  insert into @titles (txt) values ('Potêpienie')
  insert into @titles (txt) values ('Ból mózgu')
  insert into @titles (txt) values ('Wieczne wymioty')
  insert into @titles (txt) values ('Zatrute dusze')
  insert into @titles (txt) values ('Uciekaj')
  insert into @titles (txt) values ('Apokalipsa')
  insert into @titles (txt) values ('Z³udzenie pryska')
  insert into @titles (txt) values ('Makabra')
  insert into @titles (txt) values ('Zag³ada œwiata')
  insert into @titles (txt) values ('Œmieræ')
  insert into @titles (txt) values ('Spokój')

  insert into @ENDINGS (e, n, txt) values (0, 0, '.')
  insert into @ENDINGS (e, n, txt) values (0, 1, '...')
  insert into @ENDINGS (e, n, txt) values (0, 2, '.')
  insert into @ENDINGS (e, n, txt) values (0, 3, '!')
  insert into @ENDINGS (e, n, txt) values (0, 4, '.')

  insert into @ENDINGS (e, n, txt) values (1, 0, '')
  insert into @ENDINGS (e, n, txt) values (1, 1, '...')
  insert into @ENDINGS (e, n, txt) values (1, 2, '')
  insert into @ENDINGS (e, n, txt) values (1, 3, '!')
  insert into @ENDINGS (e, n, txt) values (1, 4, '')

  insert into @TRYB2ORDER (r, w, v) values (0,0, 0) -- ABAB
  insert into @TRYB2ORDER (r, w, v) values (0,1, 1)
  insert into @TRYB2ORDER (r, w, v) values (0,2, 2)
  insert into @TRYB2ORDER (r, w, v) values (0,3, 3)
  insert into @TRYB2ORDER (r, w, v) values (1,0, 0) -- ABBA
  insert into @TRYB2ORDER (r, w, v) values (1,1, 1)
  insert into @TRYB2ORDER (r, w, v) values (1,2, 3)
  insert into @TRYB2ORDER (r, w, v) values (1,3, 2)
  insert into @TRYB2ORDER (r, w, v) values (2,0, 0) -- AABB
  insert into @TRYB2ORDER (r, w, v) values (2,1, 2)
  insert into @TRYB2ORDER (r, w, v) values (2,2, 1)
  insert into @TRYB2ORDER (r, w, v) values (2,3, 3)


  declare @XLIMIT int, @TCNT int
  select top 1 @XLIMIT = w+1 from @data order by w desc
  select top 1 @TCNT = n+1 from @titles order by n desc

  declare @z int, @w int, @r int
  declare @title varchar(100)
  declare @strofa1 varchar(100), @strofa2 varchar(100), @strofa3 varchar(100), @strofa4 varchar(100)
  declare @end2 varchar(10), @end4 varchar(10)

  declare @numer TABLE (w int not null, z int not null, v int) -- int numer[4][XLIMIT];
  declare @ending TABLE (n int not null, z int not null, v int) -- int ending[2][XLIMIT];

  set @r = cast(RAND()*@TCNT as int) -- 0..TCNT-1
  select top 1 @title = txt from @titles where n=@r+1

  set @z = 0
  while @z < @cnt
  begin
    set @w = 0
    while @w < 4
    begin
       insert into @numer (w, z, v) values (@w, @z, -1)
       set @w = @w + 1
    end
    insert into @ending (n, z, v) values (0, @z, cast(RAND()*5 as int))
    insert into @ending (n, z, v) values (1, @z, cast(RAND()*5 as int))
    set @z = @z + 1
  end

  set @z = 0
  while @z < @cnt
  begin
    set @w = 0
    while @w < 4
    begin

      while 1=1
      begin
        set @r = cast(RAND()*@XLIMIT as int)
        update @numer set v = @r where w=@w and z=@z
        if @z = 0 BREAK
        if @powtorzeniaOk = 1 BREAK
        if (select count(*) from @numer where w=@w and v=@r and z<>@z) = 0 BREAK -- checkUniqOK
      end

      set @w = @w + 1
    end
    set @z = @z + 1
  end

  set @poem = char(13)+char(10)+@title+char(13)+char(10)+char(13)+char(10)

  set @z = 0
  while @z < @cnt
  begin
    set @strofa1 = ''
    set @strofa2 = ''
    set @strofa3 = ''
    set @strofa4 = ''

    select top 1 @strofa1 = txt from @data d
      inner join @numer n on n.v=d.w
      inner join @TRYB2ORDER t on t.v=n.w and t.v=d.z
      where n.z=@z and t.w=0 and t.r=@tryb_rym

    select top 1 @strofa2 = txt from @data d
      inner join @numer n on n.v=d.w
      inner join @TRYB2ORDER t on t.v=n.w and t.v=d.z
      where n.z=@z and t.w=1 and t.r=@tryb_rym

    select top 1 @strofa3 = txt from @data d
      inner join @numer n on n.v=d.w
      inner join @TRYB2ORDER t on t.v=n.w and t.v=d.z
      where n.z=@z and t.w=2 and t.r=@tryb_rym

    select top 1 @strofa4 = txt from @data d
      inner join @numer n on n.v=d.w
      inner join @TRYB2ORDER t on t.v=n.w and t.v=d.z
      where n.z=@z and t.w=3 and t.r=@tryb_rym

    set @end2 = ''
    set @end4 = ''
    select @end2 = txt from @ENDINGS a inner join @ending e on a.n=e.v where a.e=1 and e.n=0 and e.z=@z
    select @end4 = txt from @ENDINGS a inner join @ending e on a.n=e.v where a.e=0 and e.n=1 and e.z=@z
    set @end2 = case when substring(@strofa2, len(@strofa2), 1) in ('?', '!') then '' else @end2 end
    set @end4 = case when substring(@strofa4, len(@strofa4), 1) in ('?', '!') then '' else @end4 end

    set @strofa1 = concat(@strofa1, char(13)+char(10))
    set @strofa2 = concat(@strofa2, @end2, char(13)+char(10))
    set @strofa3 = concat(@strofa3, char(13)+char(10))
    set @strofa4 = concat(@strofa4, @end4, char(13)+char(10))

    set @poem = concat(@poem, @strofa1, @strofa2, @strofa3, @strofa4, char(13)+char(10))
    set @z = @z + 1
  end

end

go

grant execute on dbo.TurboWieszcz to public
go


-- how to run later (SQL above should be executed only once)

/*
declare @poem varchar(max)
execute dbo.TurboWieszcz 6, 0, 0, @poem out
print(@poem)
*/

