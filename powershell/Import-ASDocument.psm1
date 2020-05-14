<#
.Synopsis
   This module is used to import csv data to the database
.DESCRIPTION
   Initial phase 
.EXAMPLE
   Import-ASDocument -ConnectionString "Data Source=$Server; Integrated Security=True;" -ASDocument "CRVFX205_Entidade" -Database "AJW" -Directory "C:\"
#>
function Import-ASDocument {

    [CmdletBinding()]
    Param (
        # ConnectionString Connectionstring to the destination instance
        [Parameter(Mandatory=$true)]
        [string] $ConnectionString,

        # ASDocument Name of the document and table to be used
        [Parameter(Mandatory=$true)]
        [ValidateSet("CRVFX212_MbRef", "CRVFX203_Operacao","CRVFX204_Contrato", `
            "CRVFX205_Entidade", "CRVFX206_Interveniente", "CRVFX207_Advogado",  `
            "CRVFX208_Recuperador", "CRVFX209_Solicitador", "CRVFX210_Balcao",  `
            "CRVFX211_TipoInterveniente", "CRVFX219_ÁreaGeografica",  ` 
            "CRVFX220_DocumentoIdentificacao", "CRVFX221_DetalheDivida", "CRVFX222_Acordo",  `
            "CRVFX223_AcordoPrestacao","CRVFX224_DividaAcordo","CRVFX225_Colateral",  `
            "CRVFX226_FamiliaColateral", "CRVFX227_TipoColateral", "CRVFX228_TipoDocumentoIdentificacao",  `
            "CRVFX229_EstadoProcessual","CRVFX230_EstadoDivida","CRVFX231_EstadoAcordo", "CRVFX213_OperacoesCRE")]
        [string] $ASDocument,

        [Parameter(Mandatory=$true)]
        [string] $Database,

        [Parameter(Mandatory=$true)]
        [string] $Directory
    )

    Process {

        $crvRegex =  ($ASDocument.Split("_")[0]) + "*.dat"
        $tempFile = $ASDocument + ".dat"
        # remove quotes
        cd $Directory
        $lastCrvfxFile = Get-ChildItem $crvRegex | Sort-Object CreationTime -Descending | Select-Object -First 1
        (Get-Content $lastCrvfxFile) -replace '"', '' | Out-File -FilePath $tempFile -Force -Encoding bigendianunicode


         $importCsvParams = @{
            # fileinfo
            Path = $tempFile
            Encoding = "ASCII"
            Delimiter = ";"
            NoHeaderRow = $true
            TrimmingOption = "All"
            ParseErrorAction = "AdvanceToNextLine"

            # database info
            SqlInstance = $ConnectionString
            Database = $Database
            Schema = "import"
            Table = $ASDocument
            Truncate = $true
            KeepOrdinalOrder = $true
            KeepNulls = $true
        }
        Import-DbaCsv @importCsvParams

        Remove-Item -Path $tempFile
    }
}
#Export-ModuleMember -Function Import-ASDocument
