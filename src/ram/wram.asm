SECTION "WRAM0", WRAM0

wVirtualOAM:: ; c000
	ds OAM_SIZE

	ds $c540 - $c0a0

wc540:: db ; c540
wc541:: db ; c541

wc542:: db ; c542

	ds $c544 - $c543

wc544:: db ; c544

wc545:: db ; c545

wc546:: db ; c546

wc547:: db ; c547
wc548:: dw ; c548
wc54a:: db ; c54a

	ds $c56a - $c54b

; if TRUE then resetting game through A+B+START+SELECT is disabled
wResetDisabled:: db ; c56a
wResetDelay::    db ; c56b

wFrameCounter:: db ; c56c
wc56d:: db ; c56d

wc56e:: db ; c56e
wc56f:: db ; c56f
wc570:: db ; c570

wJoypadPressed:: db ; c571
wJoypadDown::    db ; c572

wc573:: db ; c573

wc574:: db ; c574

wc575:: db ; c575
wc576:: db ; c576
wc577:: db ; c577
wc578:: db ; c578

wc579:: db ; c579

wc57a:: db ; c57a

	ds $c57d - $c57b

; palettes either for CGB or DMG
UNION
wCGBPals::
wBGPals:: ds 8 palettes ; c57d
wOBPals:: ds 8 palettes ; c58d
NEXTU
wDMGPals::
wBGP::  db ; c57d
wOBP0:: db ; c57e
wOBP1:: db ; c57f
ENDU

wc5fd:: db ; c5fd

	ds $c63d - $c5fe

wc63d:: db ; c63d

	ds $c645 - $c63e

wc645:: db ; c645

	ds $c67d - $c646

wc67d:: db ; c67d

wc67e:: db ; c67e
wc67f:: db ; c67f

wc680:: db ; c680

wc681::            dw ; c681
wc683::            dw ; c683
wLCDCSettingsPtr:: dw ; c685

wLCDCSettings:: ; c687
	ds $4

	ds $c6cf - $c68b

wc6cf:: db ; c6cf

	ds $c717 - $c6d0

wEntities:: ; c717
FOR n, 0, NUM_ENTITIES
wEntity{u:n}:: entity_struct wEntity{u:n}
ENDR

wd217:: dw ; d217

wEntityPtr:: dw ; d219

wd21b:: db ; d21b

	ds $d545 - $d21c

wd545:: db ; d545

wd546:: db ; d546

wd547:: db ; d547

wd548:: db ; d548

	ds $d54b - $d549

wd54b:: db ; d54b

wd54c:: db ; d54c

wd54d:: db ; d54d

wd54e:: db ; d54e

wd54f:: db ; d54f

	ds $d551 - $d550

wd551:: db ; d551

	ds $d771 - $d552

wd771:: db ; d771

	ds $d782 - $d772

wd782:: db ; d782

	ds $d786 - $d783

wd786:: db ; d786

	ds $d7b1 - $d787

wd7b1:: db ; d7b1

	ds $d7f1 - $d7b2

wd7f1:: db ; d7f1

wd7f2:: db ; d7f2

wd7f3:: db ; d7f3

wd7f4:: db ; d7f4

wd7f5:: db ; d7f5

	ds $d7f7 - $d7f6

wd7f7:: db ; d7f7

wd7f8:: db ; d7f8

wd7f9:: db ; d7f9

wd7fa:: db ; d7fa

wd7fb:: db ; d7fb

wd7fc:: db ; d7fc

wd7fd:: db ; d7fd

wd7fe:: db ; d7fe

wd7ff:: db ; d7ff

wd800:: db ; d800

wd801:: db ; d801

wd802:: db ; d802

wd803:: db ; d803

wd804:: db ; d804

wd805:: db ; d805

wd806:: db ; d806

wd807:: db ; d807

wd808:: db ; d808

	ds $d80b - $d809

wd80b:: db ; d80b

wd80c:: db ; d80c

wd80d:: db ; d80d

wd80e:: db ; d80e

wd80f:: db ; d80f

	ds $d81e - $d810

wd81e:: db ; d81e

wd81f:: db ; d81f

wd820:: db ; d820

wd821:: db ; d821

wd822:: db ; d822

wd823:: db ; d823

wd824:: db ; d824

	ds $d826 - $d825

wd826:: db ; d826

wd827:: db ; d827

wd828:: db ; d828

wd829:: db ; d829

wd82a:: db ; d82a

wd82b:: db ; d82b

wd82c:: db ; d82c

	ds $d82e - $d82d

wd82e:: db ; d82e

	ds $d830 - $d82f

wd830:: db ; d830

wd831:: db ; d831

	ds $d833 - $d832

wd833:: db ; d833

wd834:: db ; d834

wd835:: db ; d835

wd836:: db ; d836

wd837:: db ; d837

wd838:: db ; d838

wd839:: db ; d839

wd83a:: db ; d83a

wd83b:: db ; d83b

	ds $d83f - $d83c

wd83f:: db ; d83f

	ds $d868 - $d840

wd868:: db ; d868

	ds $d86a - $d869

wd86a:: db ; d86a

	ds $d877 - $d86b

wd877:: db ; d877

	ds $d895 - $d878

wd895:: db ; d895

wd896:: db ; d896

wd897:: db ; d897

	ds $d8e5 - $d898

wd8e5:: db ; d8e5

	ds $d8e8 - $d8e6

wd8e8:: db ; d8e8

wd8e9:: db ; d8e9

wd8ea:: db ; d8ea

wd8eb:: db ; d8eb

	ds $da23 - $d8ec

wda23:: db ; da23

	ds $da2a - $da24

wda2a:: db ; da2a

	ds $da2d - $da2b

wda2d:: db ; da2d

	ds $da2f - $da2e

wda2f:: db ; da2f

	ds $da31 - $da30

wda31:: db ; da31

	ds $da4a - $da32

wda4a:: db ; da4a

wda4b:: db ; da4b

	ds $da76 - $da4c

wda76:: db ; da76

	ds $da82 - $da77

wda82:: db ; da82

wda83:: db ; da83

	ds $da94 - $da84

wda94:: db ; da94

wda95:: db ; da95

wda96:: db ; da96

wda97:: db ; da97

wda98:: db ; da98

wda99:: db ; da99

	ds $da9b - $da9a

wda9b:: db ; da9b

wda9c:: db ; da9c

wda9d:: db ; da9d

	ds $db81 - $da9e

wdb81:: db ; db81

	ds $db83 - $db82

wdb83:: db ; db83

	ds $db85 - $db84

wdb85:: db ; db85

	ds $dbc5 - $db86

wdbc5:: db ; dbc5

	ds $dbdb - $dbc6

wdbdb:: db ; dbdb

wdbdc:: db ; dbdc

	ds $dc26 - $dbdd

wdc26:: db ; dc26

	ds $dc2f - $dc27

wdc2f:: db ; dc2f

wdc30:: db ; dc30

wdc31:: db ; dc31

wdc32:: db ; dc32

wdc33:: db ; dc33

	ds $dc38 - $dc34

wdc38:: db ; dc38

wdc39:: db ; dc39

	ds $dc7a - $dc3a

wdc7a:: db ; dc7a

wdc7b:: db ; dc7b

wdc7c:: db ; dc7c

wdc7d:: db ; dc7d

wdc7e:: db ; dc7e

	ds $dc80 - $dc7f

wdc80:: db ; dc80

	ds $dc82 - $dc81

wdc82:: db ; dc82

	ds $dc8e - $dc83

wdc8e:: db ; dc8e

wdc8f:: db ; dc8f

wdc90:: db ; dc90

	ds $dc95 - $dc91

wdc95:: db ; dc95

	ds $e000 - $dc96
