# Legt die SharePoint-Liste "Inventar" für die Canvas App an.
# Voraussetzung: PnP.PowerShell (Install-Module PnP.PowerShell -Scope CurrentUser)
# Alternativ die Spalten manuell anlegen (siehe README.md).

param(
    [Parameter(Mandatory = $true)]
    [string]$SiteUrl,          # z. B. https://contoso.sharepoint.com/sites/Lager
    [Parameter(Mandatory = $true)]
    [string]$ClientId          # App-Registrierung für PnP (Entra ID)
)

Connect-PnPOnline -Url $SiteUrl -Interactive -ClientId $ClientId

$list = "Inventar"
New-PnPList -Title $list -Template GenericList -OnQuickLaunch | Out-Null

# "Title" wird als Artikelname genutzt
Set-PnPField -List $list -Identity "Title" -Values @{ Title = "Artikelname" }

Add-PnPField -List $list -DisplayName "Artikelnummer"  -InternalName "Artikelnummer"  -Type Text   -AddToDefaultView | Out-Null
Add-PnPField -List $list -DisplayName "Kategorie"      -InternalName "Kategorie"      -Type Choice -AddToDefaultView `
    -Choices "Werkzeug", "Material", "Elektronik", "Büro", "Sonstiges" | Out-Null
Add-PnPField -List $list -DisplayName "Menge"          -InternalName "Menge"          -Type Number -AddToDefaultView | Out-Null
Add-PnPField -List $list -DisplayName "Mindestbestand" -InternalName "Mindestbestand" -Type Number -AddToDefaultView | Out-Null
Add-PnPField -List $list -DisplayName "Lagerort"       -InternalName "Lagerort"       -Type Text   -AddToDefaultView | Out-Null
Add-PnPField -List $list -DisplayName "Bemerkung"      -InternalName "Bemerkung"      -Type Note   -AddToDefaultView | Out-Null

# Ein paar Beispieldaten
$beispiele = @(
    @{ Title = "Akkuschrauber";   Artikelnummer = "WZ-1001"; Kategorie = "Werkzeug";   Menge = 4;   Mindestbestand = 2;  Lagerort = "Regal A1" },
    @{ Title = "Schrauben 4x40";  Artikelnummer = "MA-2001"; Kategorie = "Material";   Menge = 120; Mindestbestand = 200; Lagerort = "Regal B3" },
    @{ Title = "USB-C Kabel 1m";  Artikelnummer = "EL-3001"; Kategorie = "Elektronik"; Menge = 15;  Mindestbestand = 10; Lagerort = "Schrank C" },
    @{ Title = "Druckerpapier A4";Artikelnummer = "BU-4001"; Kategorie = "Büro";       Menge = 3;   Mindestbestand = 5;  Lagerort = "Büro EG" }
)
foreach ($b in $beispiele) { Add-PnPListItem -List $list -Values $b | Out-Null }

Write-Host "Liste '$list' wurde angelegt." -ForegroundColor Green
