# Log Archiver Script

This script is designed to manage and maintain log files by archiving and cleaning them up based on their age. It compresses old log files into an archive and removes logs and archives older than specified retention periods.

## Features

Automatically compress log files older than a specified number of days.

Moves the compressed archives to a specified or default directory.

Deletes archived log files after archiving.

Cleans up archives older than a specified retention period.

Generates a log file to record the archiving process.

## Usage

To run the script, use the following command:

```bash
git clone https://github.com/badreddinkaztaoui/fq_log_archive_script
cd fq_log_archive_script
chmod +x log-archive.sh
./log_archive.sh <log_directory> [archive_directory] [max_age_days] [retention_days]
```

## Arguments

<log_directory> (Required): The directory containing the log files to be archived.

[archive_directory] (Optional): The directory where archives will be stored. Defaults to archives/ inside the log directory.

[max_age_days] (Optional): Number of days after which logs are archived. Defaults to 7 days.

[retention_days] (Optional): Number of days to retain archives. Archives older than this will be deleted. Defaults to 30 days.

## Notes

- Ensure the script has executable permissions. Use chmod +x log_archiver.sh to grant execute permissions.

- Avoid running the script on directories with frequent writes to prevent conflicts during file operations.

## Project Page

For more informations about this project visite [roadmap.sh/log-archive-tool]([https://roadmap.sh/projects/log-archive-tool])
