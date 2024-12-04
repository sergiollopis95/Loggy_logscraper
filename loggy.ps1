# Print script details
Write-Output "################################################################################################################"
Write-Output "#                             ____                                             _________             __   "
Write-Output "#  |    |    ____   ____    /   _____/ ________________  ______   ___________  \__    ___/___   ____ |  |  "
Write-Output "#  |    |   /  _ \ / ___\   \_____  \_/ ___\_  __ \__  \ \____ \_/ __ \_  __ \   |    | /  _ \ /  _ \|  |  "
Write-Output "#  |    |__(  <_> ) /_/  >  /        \  \___|  | \// __ \|  |_> >  ___/|  | \/   |    |(  <_> |  <_> )  |__"
Write-Output "#  |_______ \____/\___  /  /_______  /\___  >__|  (____  /   __/ \___  >__|      |____| \____/ \____/|____/"
Write-Output "#          \/    /_____/           \/     \/           \/|__|        \/                                   "
Write-Output "################################################################################################################"
Write-Output "Log Scraper Tool"
Write-Output "Version 1.0 - 2024"
Write-Output ""
Write-Output "Analyze Logs Efficiently:"
Write-Output "Retail | HLS | IoT"
Write-Output "-------------------------------------------------------------"

# Prompt user for the log directory
$LogDirectory = Read-Host "Enter the full path to the directory containing log files"

# Validate the input path
if (!(Test-Path -Path $LogDirectory)) {
    Write-Output "Error: The specified log directory does not exist: $LogDirectory"
    exit
}

# Create an output directory with the current date and time
$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$OutputPath = Join-Path -Path $ScriptDirectory -ChildPath $Timestamp

if (!(Test-Path -Path $OutputPath)) {
    New-Item -ItemType Directory -Force -Path $OutputPath | Out-Null
    Write-Output "Created output directory: $OutputPath"
}

# Define file paths within the output directory
$OutputFile = Join-Path -Path $OutputPath -ChildPath "structured_output.txt"
$LogFile = Join-Path -Path $OutputPath -ChildPath "script_execution.txt"

# Ensure the log file exists and add a header
if (!(Test-Path -Path $LogFile)) {
    New-Item -ItemType File -Path $LogFile -Force | Out-Null
}
Write-Output "Log Scraper Script Execution Log" | Out-File -FilePath $LogFile -Append
Write-Output "-------------------------------------------------------------" | Out-File -Append $LogFile

# FUNCTION: Search-LogPatterns
function Search-LogPatterns {
    param (
        [string]$PatternMain,    # Primary regex pattern to filter log lines.
        [string[]]$Keywords,     # Array of keywords to match specific log events.
        [string]$OutputFile      # File path for saving structured output.
    )

    # Initialize an empty array to store extracted results.
    $Results = @()
    Write-Output "Processing log files in $LogDirectory..." | Out-File -Append $LogFile

    # Add the table header to the results array
    $Results += "{0,-10}{1,-30}{2,-50}{3,-60}" -f "Uptime", "WorksheetEventEnd_Name", "Date/Time", "LogFileName"

    # Enumerate log files matching the specified pattern.
    Get-ChildItem -Path $LogDirectory -Include "*pe.log" -Recurse | ForEach-Object {
        try {
            $LogFilePath = $_.FullName
            $LogFileName = $_.Name  # Extract only the file name (e.g., "peinst_6532685_22045_pe.log").

            Write-Output "Processing file: $LogFileName" | Out-File -Append $LogFile

            # Read and process the file line by line.
            Get-Content -Path $LogFilePath | ForEach-Object {
                $Line = $_  # Store the current log line for processing.

                # Extract the "Uptime" attribute using regex.
                $Uptime = if ($Line -match "Uptime='(\d+)'") { $Matches[1] } else { "N/A" }

                # Extract the "LocalTime" attribute using regex.
                $LocalTime = if ($Line -match "LocalTime='([^']+)'") { $Matches[1] } else { "N/A" }

                # Extract the "WorksheetEventEnd Name" attribute using regex.
                $WorksheetEventEnd_Name = if ($Line -match "WorksheetEventEnd Name='([^']+)'") { $Matches[1] } else { "N/A" }

                # If the extracted event name matches any of the keywords, store the result.
                if ($WorksheetEventEnd_Name -ne "N/A" -and ($Keywords -contains $WorksheetEventEnd_Name)) {
                    # Format the result as "Uptime\tWorksheetEventEnd_Name\tLocalTime\tLogFileName".
                    $Results += "{0,-10}{1,-30}{2,-30}{3,-40}" -f $Uptime, $WorksheetEventEnd_Name, $LocalTime, $LogFileName
                }
            }
        }
        catch {
            # Log any errors that occur during file processing for debugging.
            $ErrorDetails = "Error processing file: $_.Name. Error: $_"
            Write-Output $ErrorDetails | Out-File -Append $LogFile
        }
    }

    # Write results to the output file if any matches were found.
    if ($Results.Count -gt 1) {  # Ensure results exist beyond the header
        $Results -join "`n" | Out-File -FilePath $OutputFile -Force
        Write-Output "Results written to $OutputFile" | Out-File -Append $LogFile
    } else {
        # Log a message if no matches were found.
        Write-Output "No matches found for pattern: $PatternMain" | Out-File -Append $LogFile
    }
}

# MAIN EXECUTION
$PatternMain = ".*"

# Define the keywords to match specific log events.
$Keywords = @(
    "SendOpenResponse",
    "PlanVersionNumber",
    "MD5SumMapfile_e6974935edbe5f0274a0e21bc270a71e",
    "initialData",
    "expand",
    "UnhideKPI",
    "copy",
    "paste",
    "pasteSpecialAllChildren",
    "autorecalc",
    "recalc",
    "saveWkshtState",
    "Save",
    "Submit",
    "HideKPIAll",
    "collapse",
    "paneLayoutChange",
    "formatChange",
    "Close",
    "getmemberlockedflag",
    "userEnableUndo",
    "getCustomLevelsFromCube",
    "GetRollupLevels",
    "skipto"
)

# Execute the log processing function with the defined parameters.
Search-LogPatterns -PatternMain $PatternMain -Keywords $Keywords -OutputFile $OutputFile

# Notify the user about successful script execution.
Write-Output "Script execution completed successfully." | Out-File -Append $LogFile
Write-Output "Script execution completed successfully."
