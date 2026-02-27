EmptyTexts::
	dw EmptyText
	dw EmptyText
	dw EmptyText
	dw EmptyText
	dw EmptyText

EmptyText:
	db " \0"

TryAgainTexts::
	dw TryAgainTextEN
	dw TryAgainTextFR
	dw TryAgainTextDE
	dw TryAgainTextIT
	dw TryAgainTextES

TryAgainTextFR:
	db "REESSAYER?\0"
TryAgainTextDE:
	db "NOCHMAL VERSUCHEN?\0"
TryAgainTextIT:
	db "VUOI RIPROVARE?\0"
TryAgainTextES:
	db "¿INTENTAR OTRA VEZ?\0"
TryAgainTextEN:
	db "TRY AGAIN?\0"

YesNoTexts::
	dw YesNoTextEN
	dw YesNoTextFR
	dw YesNoTextDE
	dw YesNoTextIT
	dw YesNoTextES

YesNoTextFR:
	db "OUI / NO\0"
YesNoTextDE:
	db "JA / NEIN\0"
YesNoTextIT:
	db "SI / NO\0"
YesNoTextES:
	db "SI / NO\0"
YesNoTextEN:
	db "YES / NO\0"
; 0xf4099

SECTION "OptionsTexts", ROMX[$48b7], BANK[$3d]

OptionsTexts::
	dw OptionsTextEN
	dw OptionsTextFR
	dw OptionsTextDE
	dw OptionsTextIT
	dw OptionsTextES

OptionsTextEN:
	db "OPTIONS\0"
OptionsTextFR:
	db "OPTIONS\0"
OptionsTextDE:
	db "OPTIONEN\0"
OptionsTextIT:
	db "OPZIONI\0"
OptionsTextES:
	db "OPCIONES\0"

LanguageTexts::
	dw LanguageTextEN
	dw LanguageTextFR
	dw LanguageTextDE
	dw LanguageTextIT
	dw LanguageTextES

LanguageTextEN:
	db "LANGUAGE\0"
LanguageTextFR:
	db "LANGUE\0"
LanguageTextDE:
	db "SPRACHE\0"
LanguageTextIT:
	db "LINGUA\0"
LanguageTextES:
	db "IDIOMA\0"

TakeARideTexts::
	dw TakeARideTextEN
	dw TakeARideTextFR
	dw TakeARideTextDE
	dw TakeARideTextIT
	dw TakeARideTextES

TakeARideTextEN:
	db "TAKE A RIDE\0"
TakeARideTextFR:
	db "FAIRE UN TOUR\0"
TakeARideTextDE:
	db "SPRITZTOUR\0"
TakeARideTextIT:
	db "FATTI UNA CORSA\0"
TakeARideTextES:
	db "DA UNA VUELTA\0"

BestTimesTexts::
	dw BestTimesTextEN
	dw BestTimesTextFR
	dw BestTimesTextDE
	dw BestTimesTextIT
	dw BestTimesTextES

BestTimesTextEN:
	db "BEST TIMES\0"
BestTimesTextFR:
	db "MEILLEURS TEMPS\0"
BestTimesTextDE:
	db "BESTZEITEN\0"
BestTimesTextIT:
	db "TEMPI MIGLIORI\0"
BestTimesTextES:
	db "MEJORES TIEMPOS\0"

UndercoverTexts::
	dw UndercoverTextEN
	dw UndercoverTextFR
	dw UndercoverTextDE
	dw UndercoverTextIT
	dw UndercoverTextES

UndercoverTextEN:
	db "UNDERCOVER\0"
UndercoverTextFR:
	db "UN FLIC DANS LA MAFIA\0"
UndercoverTextDE:
	db "UNDERCOVER\0"
UndercoverTextIT:
	db "IN MISSIONE\0"
UndercoverTextES:
	db "SECRETO\0"

DrivingGamesTexts::
	dw DrivingGamesTextEN
	dw DrivingGamesTextFR
	dw DrivingGamesTextDE
	dw DrivingGamesTextIT
	dw DrivingGamesTextES

DrivingGamesTextEN:
	db "DRIVING GAMES\0"
DrivingGamesTextFR:
	db "AS DU VOLANT\0"
DrivingGamesTextDE:
	db "FAHRSPIELE\0"
DrivingGamesTextIT:
	db "MODALIT<BIG_À>DI GIOCO\0"
DrivingGamesTextES:
	db "PARTIDAS DE CONDUCCIcN\0"

CheatsTexts::
	dw CheatsTextEN
	dw CheatsTextFR
	dw CheatsTextDE
	dw CheatsTextIT
	dw CheatsTextES

CheatsTextFR:
	db "CODES SECRETS\0"
CheatsTextDE:
	db "CHEATS\0"
CheatsTextIT:
	db "CHEAT\0"
CheatsTextES:
	db "TRAMPAS\0"
CheatsTextEN:
	db "CHEATS\0"
; 0xf4a8d

SECTION "BackTexts", ROMX[$4b1f], BANK[$3d]

BackTexts::
	dw BackTextEN
	dw BackTextFR
	dw BackTextDE
	dw BackTextIT
	dw BackTextES

BackTextEN:
	db "BACK\0"
BackTextFR:
	db "RETOUR\0"
BackTextDE:
	db "ZURiCK\0"
BackTextIT:
	db "INDIETRO\0"
BackTextES:
	db "ATR<BIG_À>S\0"

LessThanTexts::
	dw LessThanText
	dw LessThanText
	dw LessThanText
	dw LessThanText
	dw LessThanText

LessThanText:
	db "<\0"

LargerThanTexts::
	dw LargerThanText
	dw LargerThanText
	dw LargerThanText
	dw LargerThanText
	dw LargerThanText

LargerThanText:
	db ">\0"

SECTION "ChooseACityTexts", ROMX[$4d71], BANK[$3d]

ChooseACityTexts::
	dw ChooseACityTextEN
	dw ChooseACityTextFR
	dw ChooseACityTextDE
	dw ChooseACityTextIT
	dw ChooseACityTextES

ChooseACityTextEN:	
	db "CHOOSE A CITY\0"
ChooseACityTextFR:	
	db "CHOISIR UNE VILLE\0"
ChooseACityTextDE:	
	db "STADT WeHLEN\0"
ChooseACityTextIT:	
	db "SCEGLI UNA CITT<BIG_À>\0"
ChooseACityTextES:	
	db "ELIGE UNA CIUDAD\0"
; 0xf4dca

SECTION "ContinueGameTexts", ROMX[$4e8d], BANK[$3d]

ContinueGameTexts::
	dw ContinueGameTextEN
	dw ContinueGameTextFR
	dw ContinueGameTextDE
	dw ContinueGameTextIT
	dw ContinueGameTextES

ContinueGameTextFR:	
	db "CONTINUER PARTIE\0"
ContinueGameTextDE:	
	db "SPIEL FORTSETZEN\0"
ContinueGameTextIT:	
	db "CONTINUA PARTITA\0"
ContinueGameTextES:	
	db "CONTINUAR\0"
ContinueGameTextEN:	
	db "CONTINUE GAME\0"
; 0xf4ee2

SECTION "NewGameTexts", ROMX[$4f87], BANK[$3d]

NewGameTexts::
	dw NewGameTextEN
	dw NewGameTextFR
	dw NewGameTextDE
	dw NewGameTextIT
	dw NewGameTextES

NewGameTextFR:	
	db "NOUVELLE PARTIE\0"
NewGameTextDE:	
	db "NEUES SPIEL\0"
NewGameTextIT:	
	db "NUOVA PARTITA\0"
NewGameTextES:	
	db "JUEGO NUEVO\0"
NewGameTextEN:	
	db "NEW GAME\0"

MiamiTexts::
	dw MiamiText
	dw MiamiText
	dw MiamiText
	dw MiamiText
	dw MiamiText

MiamiText:
	db "MIAMI\0"
; 0xf4fe0

SECTION "LosAngelesTexts", ROMX[$5004], BANK[$3d]

LosAngelesTexts::
	dw LosAngelesText
	dw LosAngelesText
	dw LosAngelesText
	dw LosAngelesText
	dw LosAngelesTextES

LosAngelesTextES:
	db "LOS <BIG_Á>NGELES\0"
LosAngelesText:
	db "LOS ANGELES\0"
; 0xf5026

SECTION "NewYorkTexts", ROMX[$50a6], BANK[$3d]

NewYorkTexts::
	dw NewYorkText
	dw NewYorkText
	dw NewYorkText
	dw NewYorkText
	dw NewYorkTextES

NewYorkTextES:
	db "NUEVA YORK\0"
NewYorkText:
	db "NEW YORK\0"
; 0xf50c4

SECTION "CodeTexts", ROMX[$521a], BANK[$3d]

CodeTexts::
	dw CodeTextEN
	dw CodeTextFR
	dw CodeTextDE
	dw CodeTextIT
	dw CodeTextES

CodeTextIT:
	db "CODICE:           \0"
CodeTextES:
	db "CODIGO:           \0"
CodeTextEN:
CodeTextFR:
CodeTextDE:
	db "CODE:           \0"
; 0xf525b
