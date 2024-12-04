# LOGGY - LOG SCRAPER TOOL

## OVERVIEW
The Log Scraper Tool is a PowerShell script designed to analyze log files efficiently.  
It extracts specific patterns and outputs the results in a structured format for easy analysis.

<img width="856" alt="image" src="https://github.com/user-attachments/assets/d477c0a7-25e5-46b5-a221-0331844c855f">

---

## FEATURES
- Process log files with customizable keywords and patterns.
- Save results in a tabular format (`structured_output.txt`).
- Log execution details, including errors, in `script_execution.txt`.
- Automatically creates an output directory named with the current date and time.

---

## USAGE INSTRUCTIONS

### 1. Clone or Download Files
- Clone the repository to your local machine using Git:
  ```bash
  git clone <repository_url>
  ```
- Or download the repository as a `.zip` file and extract it.

### 2. Run the Script
- Navigate to the extracted folder.
- Double-click `run_loggy.bat` to start the script.

### 3. Provide Input
- When prompted, enter the directory path containing your log files.
  - Example:
    ```
    C:\Path\To\Your\LogFiles
    ```

### 4. View Output
- The script creates a new folder in the same directory as the script, named with a timestamp (e.g., `2024-11-28_14-30-00`).
- This folder contains:
  - **`structured_output.txt`**: Extracted data in a tabular format.
  - **`script_execution.txt`**: A detailed log of the script's execution.


---

## CUSTOMIZATION
1. **Keywords**:
   - Edit the `$Keywords` array in `loggy.ps1` to include the log events you want to extract:
     ```powershell
     $Keywords = @(
         "SendOpenResponse",
         "PlanVersionNumber",
         "initialData",
         "copy",
         "paste",
         "Save",
         "Submit"
     )
     ```

2. **Log File Pattern**:
   - The script currently processes files matching the pattern `*pe.log` by default.

---

## OUTPUT FORMAT
The results are saved in `structured_output.txt` with the following format:

| Uptime | WorksheetEventEnd_Name | Date/Time               | LogFileName |
|--------|-------------------------|-------------------------|-------------|
| 28     | SendOpenResponse        | Thu Nov 28 10:30:00 2024 | log1.log   |
| 30     | PlanVersionNumber       | Thu Nov 28 10:30:10 2024 | log2.log   |

---

## ERROR HANDLING
- Missing directories are created automatically.
- Errors during script execution are logged in `script_execution.txt`.

---

## TROUBLESHOOTING
- Ensure PowerShell has the necessary permissions to access the log files and create output directories.
- Check `script_execution.txt` for error details if the script fails.

---

## LICENSE
This tool is provided as-is for internal use. You can modify it to suit your requirements.
