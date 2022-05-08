# TurboWieszcz-SQL
Famous TurboWieszcz poem generator (in Polish only) - SQL version (MSSQL)

- Tested on: Microsoft SQL Server Express: 2012, 2014, 2016, 2019
- Will not work on MSSQL 2008 and below due to use of CONCAT.
- To run:
	**declare @poem varchar(max)
	execute dbo.TurboWieszcz 6, 0, 0, @poem out
	print(@poem)**

---

## The Story

This TurboWieszcz is based directly on (translated from): previous version written in Lazarus
which was based directly on: previous version written for Commodore C-64 sometime in 1993
by me (Jakub Noniewicz) and Freeak (Wojtek Kaczmarek)
which was based on:
idea presented in "Magazyn Amiga" magazine and implemented by Marek Pampuch.
also inspired by version written for iPhone by Tomek (Grych) Gryszkiewicz.
and versions written in C, JavaScript, Pascal, PHP and as CGI by Tomek (Grych) Gryszkiewicz.

Note: there are more versions - see [here](http://noniewicz.com/product.php?l=2&key=tw) for info.

---

* created: 2022-05-08


## (c)2022 Noniewicz.com, Jakub Noniewicz
